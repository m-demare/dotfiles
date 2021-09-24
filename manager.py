#!/usr/bin/env python

import os
import sys
import json
import re

symlink_data_file = "./data.json"

def read_data():
    data = []
    if os.path.isfile(symlink_data_file):
        data = json.load(open(symlink_data_file, 'rb'))
    return data

def write_data(data):
    json.dump(data, open(symlink_data_file, 'wb'))

def abs_path(path):
    return os.path.abspath(os.path.expanduser(path))

def remove_home(path):
    return re.sub('^/home/[^\/]+', '~', path)

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

    for f in data:
        src, dst = f['src'], f['dst']
        dst = abs_path(dst)
        if os.path.isdir(dst) or os.path.isfile(dst) or os.path.islink(dst):
            print("Ignoring " + dst + " since it already exists")
            continue
        if not os.path.isdir(src) and not os.path.isfile(src):
            print("Ignoring " + src + " since source file doesn't exist")
            continue
        
        os.symlink(abs_path(src), dst)

def list():
    data = read_data()
    for f in data:
        print(f["name"]+': ' + f['dst'] + ' -> ' + f['src'] + '\n')

actions = {
    'add': add,
    'rm': rm,
    'sync': sync,
    'list': list
}

if __name__=='__main__':
    if len(sys.argv) > 1 and sys.argv[1] in actions:
        try:
            actions[sys.argv[1]]()
            print("Done!")
        except Exception as e:
            print(e)
    else:
        print("Usage: ./manager.py [action] [params]")
        print("Actions:\n - " + ("\n - ".join(actions.keys())))

