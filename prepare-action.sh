#!/usr/bin/env bash
#clone ISO sources and joun the path:
git clone https://github.com/endeavouros-team/EndeavourOS-ISO.git
cd "EndeavourOS-ISO"

# Get mirrorlist for offline installs
mkdir "airootfs/etc/pacman.d"
wget -qN --show-progress -P "airootfs/etc/pacman.d/" "https://raw.githubusercontent.com/endeavouros-team/EndeavourOS-ISO/main/mirrorlist"

# Get wallpaper for installed system
wget -qN --show-progress -P "airootfs/root/" "https://raw.githubusercontent.com/endeavouros-team/endeavouros-theming/master/backgrounds/endeavouros-wallpaper.png"

# Make sure build scripts are executable
chmod +x "./"{"mkarchiso","run_before_squashfs.sh"}

# Build liveuser skel
get_pkg() {
    pacman -Syw "$1" --noconfirm --cachedir "airootfs/root/packages"
}

get_pkg "endeavouros-skel-xfce4"

# current downgrade mesa for calamares lag in vms:
wget https://archive.archlinux.org/packages/m/mesa/mesa-22.1.7-1-x86_64.pkg.tar.zst
mv mesa-22.1.7-1-x86_64.pkg.tar.zst "airootfs/root/packages/"

chown -R build:build "airootfs/root/endeavouros-skel-liveuser"
cd "airootfs/root/endeavouros-skel-liveuser"
sudo -u build makepkg -f