#!/bin/bash

# Make sure you're sudo
if [ "$EUID" -ne 0 ]; then
  echo "Please run as root using $(sudo -i) then try again"
  exit
fi

sudo pacman -Sy --needed --noconfirm --noconfirm fzf git yay
USERTEMP=$(who | awk '{print $1}' | sort -u | fzf)

# Explain what the script will do and ask for confirmation
echo "This script will install and configure the following:
- Configuration files from https://github.com/ION606/swaybackup.git
- Librewolf browser
- Visual Studio Code
- Various modern and nerd fonts
- The latest versions of Java (multiple versions)
- Alacritty terminal
- Nautilus file manager
- Node.js and NPM packages
- Git and GitHub CLI
- Neovim
- Gparted
- VLC media player
- GCC and G++ (development tools)
- Asciiquarium (fun ASCII aquarium)
- Thunderbird (email client)
- Grim and Slurp (screenshot tools)
- Xclip (clipboard management)
- Qbittorrent (torrent client)
- GIMP (image editing)
- Audacity (audio editing)
- Python3-pip (Python package manager)
- Docker and Minikube (containerization and Kubernetes)
- Gnome Tweaks (desktop customization)
- TexLive (LaTeX tools and fonts)
- Obsidian (note-taking app)
- Starship (customizable shell prompt)
- Tailscale (VPN)
- Warp (Cloudflare's VPN)
- auto-cpufreq (battery optimizer)
- change and configure the default login to lemurs
- Remove Thunar and Foot (if present)
- Clean up and update the system

Do you want to proceed? (Y/N, default Y): "
read answer
answer=${answer:-y}

if [ "$answer" != "y" ]; then
  echo "Installation aborted."
  exit
fi

# Make temporary directory
mkdir $USERTEMP/Downloads/tempinstall || ""
cd $USERTEMP/Downloads/tempinstall

# Configuration Files
git clone https://github.com/ION606/config-backup.git
cd config-backup

# sway
mv -f waybar/config /etc/xdg/waybar/
mv -f waybar/style.css /etc/xdg/waybar/
mv -f config $USERTEMP/.config/sway/config

# replace "ion606" with the selected user
sed -i "s/ion606/$USERTEMP/g" config

# hyprland
mv -f hyprland/hy3.conf /home/$USERTEMP/config/hypr/hy3.conf
mv -f hyprland/hyprland.conf /home/$USERTEMP/config/hypr/hyprland.conf

# i3
mv -f i3/config /home/$USERTEMP/config/i3/config
mv -f i3/lockscreen.sh /home/$USERTEMP/config/i3/lockscreen.sh

# terminal
mv -f terminal/fish /home/$USERTEMP/.config/
mkdir -p /home/$USERTEMP/.config/alacritty/
mv -f terminal/alacritty.toml /home/$USERTEMP/.config/alacritty/
mv -f terminal/starship.toml /home/$USERTEMP/.config/

# battery
mkdir -p $USERTEMP/auto-cpufreq/auto-cpufreq.conf
mv auto-cpufreq.conf $USERTEMP/auto-cpufreq/auto-cpufreq.conf

# set up automations in child process
mkdir -p $USERTEMP/.automations && cp -r -f auto/* $USERTEMP/.automations/ && $(sudo pacman -Sy --needed --noconfirm dunst && sudo bash $USERTEMP/.automations/setupauto.sh $USERTEMP &>$USERTEMP/setuplogs.log) &

# Installs
# Librewolf
curl -fsSL https://rpm.librewolf.net/librewolf-repo.repo | pkexec tee /etc/yum.repos.d/librewolf.repo

# Fonts
yay -Sy ttf-bitstream-vera ttf-droid gsfonts ttf-ms-win11-auto || echo "failed to install fonts!"

# Install Java
LATEST_JDK=$(sudo dnf list available | grep -E 'java-[0-9]+-openjdk' | awk '{print $1}' | sort -V | tail -n 1) && yay -Sy --needed --noconfirm $LATEST_JDK || echo "failed to install Java!"

# # Proton VPN
# wget "https://repo.protonvpn.com/fedora-$(cat /etc/fedora-release | cut -d\  -f 3)-stable/protonvpn-stable-release/protonvpn-stable-release-1.0.1-2.noarch.rpm" \
# 	&& dnf install ./protonvpn-stable-release-1.0.1-2.noarch.rpm \
# 	|| echo "failed to install Proton VPN!"

# General Package Install
yay -Sy --needed --noconfirm - <packages.txt || echo "failed to install some packages!"

# login manager stuffs
sudo systemctl disable display-manager.service
sudo systemctl enable lemurs.service
sudo mv -f lemurs-config.toml /etc/lemurs/config.toml

mv -f Librewolf/chrome /home/$USERTEMP/.librewolf/

npm install -g @bitwarden/cli alacritty-themes typescript || echo "failed to install Typescript!"

mkdir -p $USERTEMP/.icons
echo -e "https://www.gnome-look.org/p/1305251\nhttps://www.gnome-look.org/p/2091068" >$USERTEMP/.icons/links.txt

alacritty-themes --create && alacritty-themes Hyper || echo "alacritty theme install failed!"
cp -r $USERTEMP/.config/wofi/ wofi >/dev/null 2>&1 &
gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'

# Remove old programs
yay -R thunar foot || ""

# Clean-up and update
yay && yay -Scc
cd ../ && rm -rf tempinstall || echo "failed to remove temporary directory at $PWD/tempinstall"

# history preferences
HISTIGNORE="*shutdown now*:*reboot*:erasedups"

# Log-ins and installs
bw login
gh auth login
exit
