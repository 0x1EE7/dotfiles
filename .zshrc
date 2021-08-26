# if [ -n ${WSL_DISTRO_NAME} ]; then
    # WINUSER=$(cmd.exe /c "echo %USERNAME%" 2> /dev/null)
    # DEVTO="/mnt/c/Users/${WINUSER%?}/dev"
# else
    # DEVTO="$HOME/dev"
# fi
bindkey \^U backward-kill-line
DEVTO="$HOME/dev"
### Added by Zinit's installer
if [[ ! -f $HOME/.zinit/bin/zinit.zsh ]]; then
    print -P "%F{33}▓▒░ %F{220}Installing %F{33}DHARMA%F{220} Initiative Plugin Manager (%F{33}zdharma/zinit%F{220})…%f"
    command mkdir -p "$HOME/.zinit" && command chmod g-rwX "$HOME/.zinit"
    command git clone https://github.com/zdharma/zinit "$HOME/.zinit/bin" && \
        print -P "%F{33}▓▒░ %F{34}Installation successful.%f%b" || \
        print -P "%F{160}▓▒░ The clone has failed.%f%b"
fi
source "$HOME/.zinit/bin/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit
### End of Zinit's installer chunk
zinit lucid for \
    as"command" from"gh-r" atinit'export N_PREFIX="$HOME/n"; [[ :$PATH: == *":$N_PREFIX/bin:"* ]] || PATH+=":$N_PREFIX/bin"' atload'eval "$(starship init zsh)"' bpick'*unknown-linux-gnu*' \
    starship/starship
zinit wait lucid light-mode for \
  pick'async.zsh' \
      mafredri/zsh-async \
  atinit"zicompinit; zicdreplay" atload"FAST_HIGHLIGHT[git-cmsg-len]=80"\
      zdharma/fast-syntax-highlighting \
  atload"_zsh_autosuggest_start" \
      zsh-users/zsh-autosuggestions \
  blockf atpull'zinit creinstall -q .' \
      zsh-users/zsh-completions \
      zinit-zsh/z-a-bin-gem-node \
  as"command" from"gh-r" bpick'*linux_amd64*' \
      junegunn/fzf \
      Aloxaf/fzf-tab \
  as"command" from"gh-r" bpick'*linux-amd64*' mv"bazel* -> bazel"\
      bazelbuild/bazelisk \
  trigger-load'!man' \
      ael-code/zsh-colored-man-pages

export LC_ALL="en_US.UTF-8"
export ZLE_RPROMPT_INDENT=0
export FZF_COMPLETION_TRIGGER='>>'
zinit ice as"command" id-as"junegunn/fzf-scripts" multisrc"shell/{completion,key-bindings}.zsh" nocompile
zinit load junegunn/fzf

zshaddhistory() { whence ${${(z)1}[1]} >| /dev/null || return 1 }
## History file configuration
HISTFILE="$HOME/.zsh_history"
HISTSIZE=120000
SAVEHIST=100000
## History command configuration
setopt EXTENDED_HISTORY            # record timestamp of command in HISTFILE
setopt HIST_EXPIRE_DUPS_FIRST      # delete duplicates first when HISTFILE size exceeds HISTSIZE
setopt HIST_IGNORE_DUPS            # ignore duplicated commands history list
setopt HIST_IGNORE_SPACE           # ignore commands that start with space
setopt HIST_VERIFY                 # show command with history expansion to user before running it
setopt SHARE_HISTORY               # share command history data
alias g="git"
alias vim="nvim"
alias dps='docker ps --format "table {{ printf \"%.3s\" .ID}} |> {{.Image}}\t{{.Names}}\t{{.Status}}"'
alias l='exa'
alias la='exa -a'
alias ll='exa -lah --icons'
alias lg='exa -lah --git --icons'
alias ls='exa --color=auto'
alias dev="cd $DEVTO"
alias dito='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
zstyle ':completion:complete:*:options' sort false
zstyle ":completion:*:git-checkout:*" sort false
zstyle ':completion:*:descriptions' format '[%d]'
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'exa -1 --color=always $realpath'
zstyle ':completion:*:*:*:*:processes' command "ps -u $USER -o pid,user,comm -w -w"
zstyle ':fzf-tab:complete:(kill|ps):argument-rest' fzf-preview \
  '[[ $group == "[process ID]" ]] && ps --pid=$word -o cmd --no-headers -w -w'
zstyle ':fzf-tab:complete:(kill|ps):argument-rest' fzf-flags --preview-window=down:3:wrap
export GPG_TTY=$(tty)

