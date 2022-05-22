# dotfiles

Simple script to backup, restore and sync your dotfiles between multiple computers
(The idea is to use this in conjunction with git)

This repo contains the settings I like to use, so that I can set the up quickly on any PC.
If you wanted to use your own dotfiles, you just have to create a repo with manager.py in it, and start
adding files as explained below.

# Table of contents

* [Why?](#why)
* [Dependencies](#dependencies)
* [Usage](#usage)
* [Known issues](#known-issues)

## Why?
All options I could find for managing my dotfiles were either too complicated for my use case, not
multiplatform, or not open source (or all of those). Update: since doing this, I've found some other options.
I still like this one because of its simplicity, the fact that it has basically no dependencies and it's a
single file with no installation required. Also I may be biased

I wanted a simple script that required no installation, and that would get me up and running afap. Also, I tend to
work in multiple PCs at once, and different OSs, so I needed my dotfiles to easily sync between them.

## Dependencies
### If you just want to use the manager with your own dotfiles
- [python3](https://www.python.org/downloads/) (tested on python 3.8)
### If you also want to use my settings
- Run `curl -fsSL https://raw.githubusercontent.com/m-demare/dotfiles/master/dependencies.sh | bash` or
  similar
- Then you can `mkdir -p ~/localwork && git clone https://github.com/m-demare/dotfiles.git ~/localwork/dotfiles && cd
  localwork/dotfiles && python3 ./manager.py sync -f`

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

