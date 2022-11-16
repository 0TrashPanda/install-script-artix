# setopt PROMPT_SUBST
# prompt="%F{blue}%n%F{white}@%F{yellow}%M %F{white}in %F{green}${PWD/#$HOME/~}
#  %F{magenta}> %F{white}"

 RPROMPT="%F{red}%?%F{white} %t"

autoload -Uz colors && colors

PROMPT_INFO_USER='true'
PROMPT_INFO_HOST='true'
PROMPT_INFO_GIT='true'

PROMPT_INFO_INDICATOR='╭─ ' # ─ ╴

PROMPT_PRIMARY_INDICATOR='╰→ ' # › ❯
PROMPT_SECONDARY_INDICATOR=''

PROMPT_INFO_SEPERATOR=' › ' # ∙ ❯ ›
PROMPT_ERROR_INDICATOR='x'

PROMPT_INFO_GIT_DIRTY_INDICATOR='*'
PROMPT_INFO_GIT_PUSH_INDICATOR='↑'
PROMPT_INFO_GIT_PULL_INDICATOR='↓'

###### Prompt Configuration ####################################################

function _prompt_print_info {
  setopt local_options extended_glob

  local prompt_info

  # --- prompt info indicator
  prompt_info+="${fg[default]}${PROMPT_INFO_INDICATOR}${reset_color}"

  # --- username
  if [[ $PROMPT_INFO_USER == 'true' ]]
  then
    local user_name=$USER
    if [ $EUID = 0 ] # highlight root user
    then
      prompt_info+="${fg_bold[red]}${user_name}${reset_color}"
    else
      prompt_info+="${fg[cyan]}${user_name}${reset_color}"
    fi
  fi

  # --- hostname
  if [[ $PROMPT_INFO_HOST == 'true' ]]
  then
    if [[ $PROMPT_INFO_USER == 'true' ]]
    then
      prompt_info+="${fg_bold[default]}@${reset_color}"
    fi
    # hostname without domain
    local host_name=${${HOST:-HOSTNAME}%%.*}
    prompt_info+="${fg[blue]}${host_name}${reset_color}"
  fi

  # --- directory
  # abbreviate $HOME with '~'
  local working_dir=${PWD/#$HOME/'~'}
  # abbreviate intermediate directories with first letter of directory name
  # working_dir=${working_dir//(#m)[^\/]##\//${MATCH[1]}/}
  prompt_info+="${fg[default]}${PROMPT_INFO_SEPERATOR}${reset_color}${fg[yellow]}${working_dir}${reset_color}"

  # --- git info
  if [[ $PROMPT_INFO_GIT == 'true' ]] && [[ $commands[git] ]] &&
     [[ $(git rev-parse --is-inside-work-tree 2> /dev/null || echo false) != 'false' ]]
  then
    prompt_info+="${fg[default]}${PROMPT_INFO_SEPERATOR}${reset_color}"

    # branch name
    local branch=$(git branch --show-current HEAD)
    if [[ $branch ]]
    then
      prompt_info+="${fg[green]}${branch}${reset_color}"
    else
      prompt_info+="${fg[magenta]}HEAD detached${reset_color}"
      prompt_info+="${fg[default]}${PROMPT_INFO_SEPERATOR}${reset_color}"
      # tag name
      local tag=$(git tag --sort=-creatordate --points-at HEAD | head -1)
      if [[ $tag ]]
      then
        prompt_info+="${fg[green]}${tag}${reset_color}"
      else
        # commit hash
        local commit_hash=$(git rev-parse --short HEAD)
        prompt_info+="${fg[green]}${commit_hash}${reset_color}"
      fi

    fi

    # dirty indicator
    local dirty_indicator
    if ! (git diff --exit-code --quiet && git diff --cached --exit-code --quiet)
    then
      dirty_indicator=$PROMPT_INFO_GIT_DIRTY_INDICATOR
    else
      if [[ $(git ls-files | wc -l) -lt 10000 ]]
      then # check for untracked files
        if [[ $(git ls-files --others --exclude-standard | wc -l) -gt 0 ]]
        then
          dirty_indicator=$PROMPT_INFO_GIT_DIRTY_INDICATOR
        fi
      else # skip check for large repositories
        dirty_indicator='?'
      fi
    fi
    if [[ $dirty_indicator ]]
    then
      prompt_info+="${fg_bold[magenta]}${dirty_indicator}${reset_color}"
    fi

    # commits ahead and behind
    if [[ $branch ]]
    then
      local remote_branch=$(git rev-parse --abbrev-ref --symbolic-full-name @{upstream} 2> /dev/null)
      if [[ $remote_branch ]]
      then
        read ahead behind <<<$(git rev-list --left-right --count $branch...$remote_branch)
        if [[ $ahead -gt 0 ]]
        then
          prompt_info+="${fg_bold[magenta]}${PROMPT_INFO_GIT_PUSH_INDICATOR}${reset_color}"
        fi
        if [[ $behind -gt 0 ]]
        then
          prompt_info+="${fg_bold[magenta]}${PROMPT_INFO_GIT_PULL_INDICATOR}${reset_color}"
        fi
      fi
    fi
  fi

  # \033[0K\r prevents strange line wrap behaviour when resizing terminal window
  printf "\033[0K\r${prompt_info}\n"
}

precmd_functions=($precmd_functions _prompt_print_info)

PS1="%{${fg[default]}%}${PROMPT_PRIMARY_INDICATOR}%{${reset_color}%}"
PS2="%{${fg[default]}%}${PROMPT_SECONDARY_INDICATOR}%{${reset_color}%}"

###### Handle Exit Codes #######################################################

typeset -g _prompt_line_executed
function _prompt_line_executed_preexec {
  _prompt_line_executed='true'
}
function _prompt_line_executed_precmd {
  _prompt_line_executed='false'
}
preexec_functions=(_prompt_line_executed_preexec $preexec_functions)
precmd_functions=(_prompt_line_executed_precmd $precmd_functions )

function _prompt_print_status {
  local exec_status=$status
  if [[ $_prompt_line_executed != 'true' ]]
  then
    return
  fi

  if [[ $exec_status != 0 ]]
  then
    printf '\033[2K\r' # clear line; prevents strange line wrap behaviour when resizing terminal window
    printf "${fg_bold[red]}${PROMPT_ERROR_INDICATOR} ${exec_status}${reset_color}\n"
  fi
}
precmd_functions=(_prompt_print_status $precmd_functions)

# print exit code when command line is interupted
function _promp_handle_interupt {
  if [[ "$ZSH_EVAL_CONTEXT" != 'trap:shfunc' ]]
  then
    return
  fi

  if [[ "${PREBUFFER}${BUFFER}" ]]
  then
    printf '\n'
    printf '\033[2K\r' #clear line
    printf "${fg_bold[default]}∙ 130${reset_color}"
  fi
}
trap "_promp_handle_interupt; return 130" INT

###### clears screen with prompt info ###########################################
function clear-screen-widget {
  tput clear
  _prompt_print_info
  zle reset-prompt
}
zle -N clear-screen-widget
bindkey "^L" clear-screen-widget

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