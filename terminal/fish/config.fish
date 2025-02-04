if test -f ~/.config/fish/completions/glow.fish
    source ~/.config/fish/completions/glow.fish
end

if test -f ~/.config/fish/completions/glow.fish
    source ~/.config/fish/completions/glow.fish
end

if test -f ~/.config/fish/functions/builtins.fish
    source ~/.config/fish/functions/builtins.fish
end

if test -f ~/.config/fish/functions/commands.fish
    source ~/.config/fish/functions/commands.fish
end


# User specific aliases and functions

# Function to update Discord
function updateDiscord
    # The directory where the contents will be copied to
    set target_dir ~/Discord

    # Find the tar.gz file following the naming pattern
    set tar_file (find . -type f -name "discord-*.tar.gz" | head -n 1)

    # Check if the file was found
    if test -z "$tar_file"
        echo "No matching tar.gz file found."
        return 1
    end

    # Extract the tar.gz file
    tar -xzf "$tar_file"

    # Assuming the extracted content is a directory with a predictable name
    set extracted_dir (string replace ".tar.gz" "" $tar_file)

    # Copy the extracted contents to the target directory, overwriting existing files
    cp -rT "$extracted_dir" "$target_dir"

    rm "$tar_file"

    echo "Contents copied to $target_dir"
end

# Aliases
function submitty
    bash ~/runsubmitty.sh
end

function showinfo
    bash ~/.customscripts/swaybackup/auto/shownotif.sh info $argv
end

function sway
    sway --unsupported-gpu
end

function minecraft
    portablemc start forge:1.20.1-recommended -l itamar137@outlook.com
end

# Export paths and variables
set -x PATH ~/Downloads/flutter/bin $PATH
set -x PATH_TO_FX "~/javafx-sdk-22.0.1/lib"
set -x HISTCONTROL "shutdown *:ignoredups:erasedups"

set -x CC /usr/bin/gcc
set -x CXX "/usr/bin/g++"
set -x EDITOR nvim

# Clear history alias
function clearhist
    builtin history clear
end

function killvesktop
    kill -9 $(ps aux | grep vesktop | grep -v grep | awk '{print $2}' | head -n 1)
    ps aux | grep vesktop
end

# GTK and theme-related exports
set -x GTK_THEME "Adwaita:dark"
set -x GTK2_RC_FILES "/usr/share/themes/Adwaita-dark/gtk-2.0/gtkrc"
set -x QT_STYLE_OVERRIDE Adwaita-Dark

# SDKMAN
set -x SDKMAN_DIR "$HOME/.sdkman"
if test -s "$HOME/.sdkman/bin/sdkman-init.sh"
    source "$HOME/.sdkman/bin/sdkman-init.sh"
end

# PNPM
set -x PNPM_HOME "~/.local/share/pnpm"
if not contains "$PNPM_HOME" $PATH
    set -x PATH $PNPM_HOME $PATH
end

alias postgres="pg_ctl -D /var/lib/postgres/data -l logfile start"
alias temperature="sensors"


# User specific functions

# Function to update Discord
function updateDiscord
    # The directory where the contents will be copied to
    set target_dir ~/Discord

    # Find the tar.gz file following the naming pattern
    set tar_file (find . -type f -name "discord-*.tar.gz" | head -n 1)

    # Check if the file was found
    if test -z "$tar_file"
        echo "No matching tar.gz file found."
        return 1
    end

    # Extract the tar.gz file
    tar -xzf "$tar_file"

    # Assuming the extracted content is a directory with a predictable name
    set extracted_dir (string replace ".tar.gz" "" $tar_file)

    # Copy the extracted contents to the target directory, overwriting existing files
    cp -rT "$extracted_dir" "$target_dir"

    rm "$tar_file"

    echo "Contents copied to $target_dir"
end

# Aliases
function showinfo
    bash ~/.customscripts/swaybackup/auto/shownotif.sh info $argv
end

function sway
    sway --unsupported-gpu
end

function minecraft
    portablemc start forge:1.20.1-recommended -l itamar137@outlook.com
end

# Export paths and variables
set -x PATH ~/Downloads/flutter/bin $PATH
set -x PATH_TO_FX "~/javafx-sdk-22.0.1/lib"
set -x HISTCONTROL "shutdown *:ignoredups:erasedups"

set -x CC /usr/bin/gcc
set -x CXX "/usr/bin/g++"
set -x EDITOR nvim
set -x CFLAGS "--sysroot=/usr/share/wasi-sysroot"

# Clear history alias
function clearhist
    builtin history clear
end

function killvesktop
    kill -9 $(ps aux | grep vesktop | grep -v grep | awk '{print $2}' | head -n 1)
    ps aux | grep vesktop
end

# GTK and theme-related exports
set -x GTK_THEME "Adwaita:dark"
set -x GTK2_RC_FILES "/usr/share/themes/Adwaita-dark/gtk-2.0/gtkrc"
set -x QT_STYLE_OVERRIDE Adwaita-Dark

# SDKMAN
set -x SDKMAN_DIR "$HOME/.sdkman"
if test -s "$HOME/.sdkman/bin/sdkman-init.sh"
    source "$HOME/.sdkman/bin/sdkman-init.sh"
end

# PNPM
set -x PNPM_HOME "~/.local/share/pnpm"
if not contains "$PNPM_HOME" $PATH
    set -x PATH $PNPM_HOME $PATH
end

alias postgres="pg_ctl -D /var/lib/postgres/data -l logfile start"
alias temperature="sensors"

set -gx PATH /opt/cuda/bin $PATH
set -gx LD_LIBRARY_PATH /opt/cuda/lib64 $LD_LIBRARY_PATH

# colors
starship init fish | source

if test -f ~/.config/fish/conf.d/colors.fish
    source ~/.config/fish/conf.d/colors.fish
end
