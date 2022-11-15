setopt PROMPT_SUBST
prompt="%F{blue}%n%F{white}@%F{yellow}%M %F{white}in %F{green}${PWD/#$HOME/~}
 %F{magenta}> %F{white}"

 RPROMPT="%F{red}%?%F{white} %t"