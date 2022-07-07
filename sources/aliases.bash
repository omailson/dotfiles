alias vi='vim --cmd "let g:dotvim_vi = 1"'
alias ggo='xdg-open'
alias agora='date +"%d/%m %H:%M"'
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
alias ko='gitk origin/master'

alias ks='git status'
alias kf='git diff'
alias kfc='git diff --cached'
alias ga='git-add-fpp'

alias gs='git show --pretty=medium'
alias glog='git log --date=relative --pretty="format:%C(auto,yellow)%h %C(auto,blue)%>(12,trunc)%ad %C(auto,green)%<(7)%al %C(auto,reset)%s%C(auto,red)% gD% D"'

alias gcommitwip='git commit -m WIP'
alias gamend='git commit --amend --no-edit'
alias ad='arc diff HEAD~1 --allow-untracked'
alias adwip='ad --nounit --nolint --plan-changes --excuse wip'
