
A guide to allow for easier replication of my arch linux setup. Designed entirely for my own benefit.



# Steps

## Arch Linux Install
- Create an installation medium and follow the usual setup guide for the arch install.
- Once at the section regarding packages to install on the arch installation, you will diverge from the normal installation tutorial.
- Install the packages listed in the package markdown file to get started with the desktop environment.

## Config File Symlinks
- We're going to try doing symlinks for our configs so we can keep this centralized
- Command:

## Hyprland Setup

```bash
ln -s ~/arch_setup/hypr ~/.config/hypr
```
## Waybar Setup

```bash
ln -s ~/arch_setup/waybar ~/.config/waybar
```

## Wofi Setup

```bash
ln -s ~/arch_setup/wofi ~/.config/wofi
```
