# dotfiles

Simple script to backup, restore and sync your dotfiles between multiple computers
(The idea is to use this in conjunction with git)

## Dependencies
- python3 (tested on python 3.8)

## Usage

### Add files or directories

```bash
./manager.py add fileInFs fileInRepo name
```
E.g:
```bash
./manager.py add ~/.config/nvim/ ./vim/nvim nvim
```

### Remove file or directories

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

Run this after a `git pull`
```bash
./manager.py sync
```
Note: this doesn't remove the symlinks that were removed on another PC, it only adds them

