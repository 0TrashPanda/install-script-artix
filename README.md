# install-script-artix
This Script is a simple way to automate the installation process of the artix-base-runit ISO. This script saves time and reduces the chance of human error, making it an ideal tool for both novice and experienced Linux users.

## Usage:
This script is designed to be loaded on the machine where the Artix ISO is running.

Log in as **root** with the password "**artix**".
If qwerty is not your preferred layout, change it.
```bash
loadkeys colemak
```

Curl the correct version of the script:
```bash
curl -o installer_p1.sh https://raw.githubusercontent.com/0TrashPanda/install-script-artix/master/artix_installer_p1.sh
```
Change its execution policies:
```bash
chmod +x installer_p1.sh
```
and run it:
```bash
./installer_p1.sh
```
It will tell you what to do from this point forward.

## Standard:
Made to automate the grub process on BIOS boot systems
uses > `artix_installer_p1.sh`

## Manual grub:
Made to automate process on systems without doing grub automatically 
uses > `artix_installer_man_p1.sh`
mainly used for UEFI systems.

## Post install:
Made to automate the general setup after your artix install works
uses > `artix_postinstall.sh`
manly does the basic setup for servers

## Troubleshooting:
If you get the`curl failed to verify the legitimacy` error
please make sure your hardware clock int wrong.


## Assets:
There are some extra scripts and configs that we use in here, you shouldn't worry about this stuff too much. 
