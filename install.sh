#! /bin/bash

clear
echo "
 ___ _   _ ____ _____  _    _     _       ____  _   _
|_ _| \ | / ___|_   _|/ \  | |   | |     / ___|| | | |
 | ||  \| \___ \ | | / _ \ | |   | |     \___ \| |_| |
 | || |\  |___) || |/ ___ \| |___| |___ _ ___) |  _  |
|___|_| \_|____/ |_/_/   \_|_____|_____(_|____/|_| |_|
"
echo [Info] Installing packages
for i in $(cat packages.txt); do
	echo [Info] Installing $i
	sudo pacman -S $i --needed
done

echo "[Info] Installing AUR packages, continue?"
read -rp "[y/n]: " yn

case "$yn" in
    y|Y)
        while read -r package; do
            yay -S "$package"
        done < aur.txt
        ;;
    n|N)
        ;;
    *)
        echo "[Error] Please enter y or n."
        exit 1
        ;;
esac

echo "[Info] Copying config"
cp -rf ./config/* "$HOME/.config/"
