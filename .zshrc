source /packages/zsh-autosuggestions/zsh-autosuggestions.zsh
source /packages/doas-zsh-plugin/doas.plugin.zsh
source /packages/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /packages/zsh-history-substring-search/zsh-history-substring-search.zsh
source /packages/zsh-completions/zsh-completions.plugin.zsh


alias ls="exa -l -F --header -s type"
alias cl="clear"
alias us="loadkeys us"
alias be="loadkeys azerty"
alias colemak="loadkeys colemak"
alias ..="cd .."
alias sudo="doas"
alias vim="nvim"
alias dvim="sudo nvim"
alias dnvim="sudo nvim"
alias svim="sudo nvim"
alias snvim="sudo nvim"
alias loadkeys="doas /usr/bin/loadkeys"
alias paru="paru --sudo doas"

# init the starship prompt
eval "$(starship init zsh)"