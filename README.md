# dotfiles

Simple script to backup, restore and sync your dotfiles between multiple computers
(The idea is to use this in conjunction with git)

This repo contains the settings I like to use, so that I can set the up quickly on any PC.
If you wanted to use your own dotfiles, you just have to create a repo with manager.py in it, and start
adding files as explained below.

## Dependencies
- python3 (tested on python 3.8)

## Usage

### Add files or directories
Moves the file to your dotfiles repo, and symlinks them to their original path

```bash
./manager.py add fileInFs fileInRepo name
```
E.g:
```bash
./manager.py add ~/.config/nvim/ ./vim/nvim nvim
```

### Remove file or directories
Undoes the symlink and moves the file back to its original location

```bash
./manager.py rm name
```
E.g:
```bash
./manager.py rm nvim
```

### List your added files

```bash
./manager.py list
```

### Sync the files you've added in another computer
Creates any missing symlinks that you've added on another PC
Run this after a `git pull`/`git clone`
```bash
./manager.py sync [OPTIONS]
```
**Options**
    --force, -f
        Overrides dst files if they already exist
        Use with caution

Note: this doesn't remove the symlinks that were removed on another PC, it only adds them. Added files are updated automatically on pull

### Unsync files
Removes all symlinks and replaces them with the actual files, but doesn't remove the files from the repo
Mainly intended for testing purposes

```bash
./manager.py unsync
```


## Known issues
On windows, you need a shell with admin privilege to create symlinks

