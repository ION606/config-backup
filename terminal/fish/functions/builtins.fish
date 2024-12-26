function animate_typing
    set message $argv
    echo -e $message | pv -qL 30
end


function fish_greeting
    toilet FIMSH!
    # one for the display manager, one user one
    if test (count (pgrep -x fish)) -eq 2
        animate_typing "\e[38;5;207m❥ Welcome to your Fish shell! \e[0m"
    else
        echo -e "\e[38;5;207m❥ Welcome to your Fish shell! \e[0m"
    end
end
