#!/usr/bin/env python

import os
import sys
import json
import pickle

symlink_data_file = "./data"

def read_data():
    data = []
    if os.path.isfile(symlink_data_file):
        data = json.load(open(symlink_data_file, 'rb'))
    return data

def write_data(data):
    json.dump(data, open(symlink_data_file, 'wb'))


def add():
    if len(sys.argv) < 5:
        raise Exception("Exprected 3 parameters for add")
        return 
    
    dst, src, name = sys.argv[2], sys.argv[3], sys.argv[4]
    dst = os.path.abspath(dst)

    if not (os.path.isdir(dst) or os.path.isfile(dst)) or os.path.islink(dst):
        raise Exception("Dst file doesn't exist or is already symlink")
        return
    if os.path.isfile(src) or os.path.isdir(src):
        raise Exception("Source file aready exists")
        return
    
    data = read_data()

    for f in data:
        if f["name"] == name:
            raise Exception("No repeated names")

    os.rename(dst, src)

    os.symlink(os.path.abspath(src), dst)

    data.append({
        "src": src,
        "dst": dst,
        "name": name
    })

    write_data(data)


def rm():
    if len(sys.argv) < 3:
        raise Exception("Exprected 1 parameter for rm")
        return 

    data = read_data()
    name = sys.argv[2]
    f = next((i for i in data if i["name"]==name), None)
    
    if f is None:
        raise Exception("File does not exist")
        return

    if not os.path.islink(f["dst"]):
        raise Exception("Symlink does not exist")
        return

    os.unlink(f["dst"])

    os.rename(f["src"], f["dst"])

    data = [i for i in data if i["name"]!=name]
    write_data(data)

def init():
    data = read_data()

    for f in data:
        src, dst = f['src'], f['dst']
        if os.path.isdir(dst) or os.path.isfile(dst) or os.path.islink(dst):
            print("Ignoring " + dst + " since it already exists")
            continue
        
        os.symlink(os.path.abspath(src), dst)


actions = {
    'add': add,
    'rm': rm,
    'init': init
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

