function animate_typing
	set message $argv
	echo -e $message | pv -qL 30
end

function fish_greeting
	# added the default welcome messafe to the shorter list
	set -l sarcastic \
		"Welcome to your Fish shell!" \
		"Oh joy, another terminal session…" \
		"Brace yourself, it's gonna be a thrilling day." \
		"Hope you brought coffee for this adventure…" \
		"Did you commit that to prod yet?" \
		"404: motivation not found." \
		"Ctrl+C to stop procrastination? Good luck." \
		"Remember: semicolons matter."

	set -l cute \
		"OWO hai!" \
		"didge you know um uhh um......I forgor qwq" \
		"one time I went to the store to buy a shormk but they didn't have the big one so I cried but THEN the employee went to the back and got me a big one!!!" \
		"You're the semicolon in my life; you complete me." \
		"May your loops never break." \
		"You auto‑complete my heart." \
		"Hope your day compiles without errors!" \
		"Error 418: I'm a teapot, but I pour you coffee." \
		"Keep calm and git commit." \
		"Roses are red, violets are blue, my CPU overclocks only for you." \
		"You’re the missing semicolon that makes my code compile." \
		"Our bond is stronger than SSL encryption." \
		"Life without you is like a null pointer—undefined!" \
		"You’re the 1 in my binary." \
		"Your smile debugs all my errors." \
		"Every moment with you is O(log n) sweet." \
		"You make my heart execute in constant time." \
		"You are the ping to my pong." \
		"Together we’re a perfect merge commit." \
		"You've got the key to my encryption." \
		"My favorite language is the language of your laugh." \
		"Our love is more durable than immutable objects."

	# pick either sarcastic (0) or cute (1)
	set -l rc (random 0 1)
	if test $rc -eq 0
		set msg (random choice $sarcastic)
	else
		set msg (random choice $cute)
	end

	toilet FIMSH!
	if test (count (pgrep -x fish)) -eq 2
		animate_typing "\e[38;5;207m❥ $msg\e[0m"
	else
		echo -e "\e[38;5;207m❥ $msg\e[0m"
	end
end

