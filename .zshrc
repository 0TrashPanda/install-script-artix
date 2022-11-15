setopt PROMPT_SUBST
prompt="%F{blue}%n%F{white}@%F{yellow}%M %F{white}in %F{green}${PWD/#$HOME/~}
 %F{magenta}> %F{white}"

 RPROMPT="%F{red}%?%F{white} %t"

alias ls="exa -l -F --header -s type"
alias cl="clear"
alias us="loadkeys us"
alias be="loadkeys azerty"
alias colemak="loadkeys colemak"
alias ..="cd .."