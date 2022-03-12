#!/usr/bin/env python3

import os
import sys
import json
import re
import traceback
from shutil import copy2, copytree, rmtree

symlink_data_file = "./data.json"

def read_data():
    data = []
    if os.path.isfile(symlink_data_file):
        data = json.load(open(symlink_data_file, 'r'))
    return data

def write_data(data):
    json.dump(data, open(symlink_data_file, 'w'))

def abs_path(path):
    return os.path.abspath(os.path.expanduser(path))

def remove_home(path):
    home = re.escape(os.path.expanduser('~'))
    return re.sub(f'^{home}', '~', path)

def get_containing_dir(path):
    return re.sub(r'[^\/\\]+[\\/\\]?$', "", path)

def get_file_or_dir_name(path):
    return re.findall(r'[^\/\\]*[\\/\\]?[^\/\\]+[\\/\\]?$', remove_home(path))[0]


def add():
    if len(sys.argv) < 5:
        raise Exception("Exprected 3 parameters for add")

    dst, src, name = sys.argv[2], sys.argv[3], sys.argv[4]
    dst = abs_path(dst)

    if not (os.path.isdir(dst) or os.path.isfile(dst)) or os.path.islink(dst):
        raise Exception("Dst file doesn't exist or is already symlink")
    if os.path.isfile(src) or os.path.isdir(src):
        raise Exception("Source file aready exists")

    data = read_data()

    for f in data:
        if f["name"] == name:
            raise Exception("No repeated names")

    if not os.path.isdir(get_containing_dir(src)):
        os.makedirs(get_containing_dir(src))

    os.rename(dst, src)

    os.symlink(abs_path(src), dst)

    data.append({
        "src": src,
        "dst": remove_home(dst),
        "name": name
    })

    write_data(data)


def rm():
    if len(sys.argv) < 3:
        raise Exception("Exprected 1 parameter for rm")

    data = read_data()
    name = sys.argv[2]
    f = next((i for i in data if i["name"]==name), None)

    if f is None:
        raise Exception("File does not exist")

    dst, src = f["dst"], f["src"]
    dst = abs_path(dst)

    if not os.path.islink(dst):
        raise Exception("Symlink does not exist")

    os.unlink(dst)

    os.rename(src, dst)

    data = [i for i in data if i["name"]!=name]
    write_data(data)

def sync():
    data = read_data()

    force = False
    if len(sys.argv) > 2:
        for flag in sys.argv[2:]:
            if flag == "-f" or flag == "--force":
                force = True
                print("Sure hope you know what you're doing")
                break

    for f in data:
        src, dst = f['src'], f['dst']
        dst = abs_path(dst)
        if os.path.isdir(dst) or os.path.isfile(dst) or os.path.islink(dst):
            if not force:
                print("Ignoring " + dst + " since it already exists" + (" (It's a symlink)" if os.path.islink(dst) else ""))
                continue
            if os.path.islink(dst):
                os.unlink(dst)
            elif os.path.isfile(dst):
                os.remove(dst)
            else:
                rmtree(dst)

        if not os.path.isdir(src) and not os.path.isfile(src):
            print("Ignoring " + src + " since source file doesn't exist")
            continue

        print("Syncing " + get_file_or_dir_name(dst))

        if not os.path.isdir(get_containing_dir(dst)):
            os.makedirs(get_containing_dir(dst))

        os.symlink(abs_path(src), dst)

def unsync():
    data = read_data()

    for f in data:
        src, dst = f['src'], f['dst']
        dst = abs_path(dst)
        if not os.path.islink(dst):
            print("Ignoring " + dst + " since it doesn't exist")
            continue

        os.unlink(dst)

        if os.path.isdir(src):
            copytree(src, dst)
        else:
            copy2(src, dst)


def ls():
    data = read_data()
    for f in data:
        print(f["name"]+': ' + f['dst'] + ' -> ' + f['src'] + '\n')

actions = {
    'add': add,
    'rm': rm,
    'sync': sync,
    'unsync': unsync,
    'list': ls
}

if __name__=='__main__':
    if len(sys.argv) > 1 and sys.argv[1] in actions:
        try:
            actions[sys.argv[1]]()
            print("Done!")
        except Exception as e:
            print(traceback.format_exc())
    else:
        print("Usage: ./manager.py [action] [params]")
        print("Actions:\n - " + ("\n - ".join(actions.keys())))

