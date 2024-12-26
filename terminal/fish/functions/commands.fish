# Helper function to remove options from $argv
function remove_options
    # Filter out arguments starting with '-' using string match
    for arg in $argv
        if not string match -q -- '-*' $arg
            echo $arg
        end
    end
end

# 'ls' wrapper
function ls_cute
    echo "🌸 OWO what's this??? 🌸"
    command ls $argv
    echo "🌼 look at the stuffs! 🌼"
end
alias ls="ls_cute"

# 'cd' wrapper
function cd_cute
    echo "nyooming to $argv[1]! ✨"
    builtin cd $argv
end
alias cd="cd_cute"

# 'rm' wrapper
function rm_cute
    echo "🗑️ oh nyo! Deleting $argv :<"
    command rm $argv

    # echo "🗑️ oh nyo! Deleting $argv... Are you sure? 😿"
    # read -p "type 'yes' to confirm: " confirm
    # if test "$confirm" = "yes"
    #     command rm $argv
    #     echo "💔 $argv is gone... but you'll recover! qwq"
    # else
    #     echo "😌 phew! nyo dedge :3 🌈"
    # end
end
alias rm="rm_cute"

# 'mkdir' wrapper
function mkdir_cute
    echo "🏗️ building diwectowy $(remove_options $argv) uwu! 🏡"
    command mkdir $argv
    echo "✨ all done! $(remove_options $argv)[1] is ready for use. 🎉"
end
alias mkdir="mkdir_cute"

# 'cp' wrapper
function cp_cute
    set args (remove_options $argv)  # Extract non-option arguments
    echo "📂 copying $args[1] to $args[2]... Be careful with those precious files! 🛠️"
    command cp $argv
    echo "✨ yay! $args[1] has a shiny twin at $args[2]. 🌟"
end
alias cp="cp_cute"

# 'mv' wrapper
function mv_cute
    set args (remove_options $argv)  # Extract non-option arguments
    echo "🚚 moving $args[1] to $args[2] nyow... 🌈"
    command mv $argv
    echo "✨ done! $args[1] has found a new home at $args[2]. 🌟"
end
alias mv="mv_cute"

# 'git' wrapper
function git_cute
    echo -e "🐙 Git scawy qwq...but I'll twy to do \033[1;32mgit $argv\033[0m anyways!🌟"
    command git $argv
    echo "🎉 done! (phew) 🌠"
end
alias git="git_cute"

# 'sudo' wrapper
function sudo_cute
    echo "🥺 gib power pls, I pwomise I won't rm -rf / --no-preserve-root 🥺"
    command sudo $argv
    echo "✨ a-am big nyow! a-and scawy!!! ✨"
end
alias sudo="sudo_cute"

# 'yay' wrapper
function yay_cute
    echo "✨ Running yay with command: yay $argv"
    command yay $argv
    if test $status -ne 0
        echo "💔 aur naur! The command failed! 💔"
    else
        echo "🎉 YAY command completed! 🌟"
    end
end
alias yay="yay_cute"

# 'exit' wrapper
function exit_cute
    echo "😢 qwq, you're leaving the shell... bai baiii! 👋"
    builtin exit
end
alias exit="exit_cute"

# 'clear' wrapper
function clear_cute
    echo "🌈 Clearing the clutter UMU! ✨"
    command clear
end
alias clear="clear_cute"
