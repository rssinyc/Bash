# .bashrc

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

# User specific environment
if ! [[ "$PATH" =~ "$HOME/.local/bin:$HOME/bin:" ]]
then
    PATH="$HOME/.local/bin:$HOME/bin:$PATH"
fi
export PATH

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

# User specific aliases and functions
if [ -d ~/.bashrc.d ]; then
	for rc in ~/.bashrc.d/*; do
		if [ -f "$rc" ]; then
			. "$rc"
		fi
	done
fi

unset rc
export LS_COLORS='di=37:fi=37:ln=37:ex=37:bd=37:cd=37:su=37:sg=37:tw=37:ow=37:'

# History stuff
shopt -s histappend
PROMPT_COMMAND='history -a ;$PROMPT_COMMAND'
export HISTTIMEFORMAT="%F %T "
PROMPT_COMMAND='echo -ne "\033]0;`hostname`\007"'
HISTFILE=~/history/.hist$$

# Prompt
#export PS1="\e[1;32m[\u@\h \W]\$ \e[m "
export PS1="\[\e[32m\][\[\e[m\]\[\e[36m\]\u\[\e[m\]\[\e[37m\]@\[\e[m\]\[\e[37m\]\h\[\e[m\]:\[\e[34m\]\w\[\e[m\]\[\e[32m\]]\[\e[m\]\[\e[32;36m\]\\$\[\e[m\] "
