ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE='fg=8'

source /packages/doas-zsh-plugin/doas.plugin.zsh

alias us="loadkeys us"
alias be="loadkeys azerty"
alias colemak="loadkeys colemak"

alias ls="exa -l -F --header -s type"
alias cl="clear"
alias ..="cd .."
alias sudo="doas"
alias vim="nvim"
alias dvim="sudo nvim"
alias dnvim="sudo nvim"
alias svim="sudo nvim"
alias snvim="sudo nvim"
alias paru="paru --sudo doas"
alias df="df -h"

alias loadkeys="doas /usr/bin/loadkeys"
alias setcolors="doas /usr/bin/setcolors"