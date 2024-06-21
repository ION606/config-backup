#!/bin/bash

# Escalate Privilage
sudo su

# Make temporary directory
mkdir ~/Downloads/tempinstall || ""
cd ~/Downloads/tempinstall


# Configuration Files
git clone https://github.com/ION606/swaybackup.git
cd swaybackup
mv -f waybar/config /etc/xdg/waybar/
mv -f waybar/style.css /etc/xdg/waybar
mv -f config ~/.config/sway/config
mf -f lockscreen.sh ~/lockscreen.sh

# Installs

# Automatically Answer "Y"
echo assumeyes=True | sudo tee -a /etc/dnf/dnf.conf

# Librewolf
curl -fsSL https://rpm.librewolf.net/librewolf-repo.repo | pkexec tee /etc/yum.repos.d/librewolf.repo

# VS Code
rpm --import https://packages.microsoft.com/keys/microsoft.asc
printf "[vscode]\nname=packages.microsoft.com\nbaseurl=https://packages.microsoft.com/yumrepos/vscode/\nenabled=1\ngpgcheck=1\nrepo_gpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc\nmetadata_expire=1h" | sudo tee -a /etc/yum.repos.d/vscode.repo

# Fonts
dnf install https://download1.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm \
	https://download1.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm \
	install bitstream-vera-sans-fonts bitstream-vera-serif-fonts bitstream-vera-sans-mono-fonts \
	google-droid-sans-fonts google-droid-serif-fonts google-droid-sans-mono-fonts \
	urw-fonts msttcore-fonts-installer || echo "failed to install fonts!"

# Install Java
LATEST_JDK=$(sudo dnf list available | grep -E 'java-[0-9]+-openjdk' | awk '{print $1}' | sort -V | tail -n 1) && dnf install -y $LATEST_JDK || echo "failed to install Java!"

# Proton VPN
wget "https://repo.protonvpn.com/fedora-$(cat /etc/fedora-release | cut -d\  -f 3)-stable/protonvpn-stable-release/protonvpn-stable-release-1.0.1-2.noarch.rpm" \
	&& dnf install ./protonvpn-stable-release-1.0.1-2.noarch.rpm \
	|| echo "failed to install Proton VPN"

dnf install -y --refresh alacritty nautilus nodejs librewolf code \
	git gh proton-vpn-gnome-desktop neovim gparted liberation-fonts \
	vlc gcc gcc-c++ asciiquarium thunderbird grim slurp xclip \
	qbittorrent gimp audacity python3-pip
	|| echo "failed to install some packages!"

npm install -g @bitwarden/cli alacritty-themes typescript || echo "failed to install Typescript!"

alacritty-themes Hyper || echo "Theme install failed!"

# Remove old programs
dnf remove thunar foot || ""

# install vesktop
wget -O vesktop.rpm https://vencord.dev/download/vesktop/amd64/rpm && dnf install vesktop || echo "failed to install Vesktop!"

# Clean and update
sudo dnf clean all
sudo dnf update

# Revert the auto-answer "Y"
echo assumeyes=False | sudo tee -a /etc/dnf/dnf.conf

# log-ins and installs
bw login
gh auth login
msttcore-fonts-installer || echo "failed to run font installer!"
