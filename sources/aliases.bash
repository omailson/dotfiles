alias vi='vim --cmd "let g:dotvim_vi = 1"'
alias ggo='xdg-open'
alias agora='date +"%d/%m %H:%M"'
alias genius='genius --nomixed' # Inicia o genius de forma que não mostre frações de forma mista
alias cakepath='export PATH=$PATH:`pwd`/cake/console'
alias xx='chmod +x'
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo utilities-terminal || echo dialog-error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'
alias cnf='pkgfile -v -b --'
alias webserver='python2 -m SimpleHTTPServer'

# ls aliases
if [ "$(uname)" == "Darwin" ]
then
	alias ls='ls -G'
else
	alias ls='ls --color=auto'
fi
alias l='ls'
alias la='ls -la'
alias ll='ls -l'
alias lh='ls -lh'

# Git aliases
alias k='gitk --all'
alias ks='git status'
alias kf='git diff'
alias kfc='git diff --cached'
alias ga='git-add-fpp'
alias t='tig --all'
alias ts='tig status'
alias q='qgit --all &'
