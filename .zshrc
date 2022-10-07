# if [ -n ${WSL_DISTRO_NAME} ]; then
    # WINUSER=$(cmd.exe /c "echo %USERNAME%" 2> /dev/null)
    # DEVTO="/mnt/c/Users/${WINUSER%?}/dev"
# else
    # DEVTO="$HOME/dev"
# fi
. "$HOME/.cargo/env"
export LANG=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=239"
export DISPLAY=:0
bindkey \^U backward-kill-line
bindkey "^[[1;5D" backward-word
bindkey "^[[1;5C" forward-word
DEVTO="$HOME/dev"
### Added by Zinit's installer
if [[ ! -f $HOME/.zinit/bin/zinit.zsh ]]; then
    print -P "%F{33}▓▒░ %F{220}Installing %F{33}DHARMA%F{220} Initiative Plugin Manager (%F{33}0x1ee7/zinit%F{220})…%f"
    command mkdir -p "$HOME/.zinit" && command chmod g-rwX "$HOME/.zinit"
    command git clone https://github.com/0x1ee7/zinit "$HOME/.zinit/bin" && \
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
  as"command" pick'kubectx' \
      ahmetb/kubectx \
  as"command" pick'kubens' \
      ahmetb/kubectx \
  as"command" from"gh-r" bpick'*linux-x86_64-v*' mv"bin/exa -> exa" cp"completions/exa.zsh -> _exa" blockf \
      ogham/exa \
  as"command" from"gh-r" bpick'*linux_amd64*' \
      junegunn/fzf \
      Aloxaf/fzf-tab \
  as"command" from"gh-r" bpick'*linux-amd64*' mv"bazel* -> bazel"\
      bazelbuild/bazelisk \
  trigger-load'!man' \
      ael-code/zsh-colored-man-pages \
  atload"FAST_HIGHLIGHT[git-cmsg-len]=69" \
      0x1ee7/fast-syntax-highlighting \
  atload"!_zsh_autosuggest_start" \
      zsh-users/zsh-autosuggestions

zinit ice id-as"junegunn/fzf-scripts" multisrc"shell/{completion,key-bindings}.zsh" nocompile
zinit load junegunn/fzf
if [[ -f /usr/share/google-cloud-sdk/completion.zsh.inc ]]; then
    zinit snippet OMZ::plugins/kubectl/kubectl.plugin.zsh
    zinit snippet /usr/share/google-cloud-sdk/completion.zsh.inc
fi
zinit snippet https://raw.githubusercontent.com/bazelbuild/bazel/master/scripts/zsh_completion/_bazel
zinit snippet https://raw.githubusercontent.com/docker/cli/master/contrib/completion/zsh/_docker
zinit wait lucid atload"ZINIT[COMPINIT_OPTS]=-C; zicompinit; zicdreplay" blockf for \
    zsh-users/zsh-completions

autoload -Uz compinit
compinit

export ZLE_RPROMPT_INDENT=0
export FZF_COMPLETION_TRIGGER='??'
if type fdfind &> /dev/null; then
    export FZF_DEFAULT_COMMAND='fdfind --type f'
    export FZF_DEFAULT_OPTS='--bind ctrl-s:toggle,ctrl-a:select-all,ctrl-d:deselect-all,ctrl-t:toggle-all'
    export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
    _fzf_compgen_path() {
        fdfind --hidden --follow --exclude ".git" . "$1"
    }

    # Use fdfind to generate the list for directory completion
    _fzf_compgen_dir() {
        fdfind --type d --hidden --follow --exclude ".git" . "$1"
    }
fi



zshaddhistory() { whence ${${(z)1}[1]} >/dev/null || return 2 }
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
setopt HIST_FIND_NO_DUPS           # ignore duplicated commands in find
setopt SHARE_HISTORY               # share command history data
setopt GLOB_COMPLETE               # set globcomplete
setopt MENU_COMPLETE               # set menucomplete
setopt COMBINING_CHARS             # set combiningcharacters
alias g="git"
alias gr="git co -"
alias vim="nvim"
alias dps='docker ps --format "table {{ printf \"%.3s\" .ID}} |> {{.Image}}\t{{.Names}}\t{{.Status}}"'
alias k='kubectl'
alias kc='kubectx'
alias kn='kubens'
alias j='jq --unbuffered'
alias ls='exa --color=auto'
alias l='ls'
alias la='ls -a'
alias ll='ls -lah --icons'
alias lg='ls -lah --git --icons'
alias tree='exa --icons --tree --level=2'
alias dev="cd $DEVTO"
alias dit='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
alias nohist="fc -p $HISTFILE; unset HISTFILE"
alias histon="fc -P"
alias wg="watch --color git diff --color=always --stat main -- ."
export HISTORY_IGNORE="(ls|ll|cd|pwd|dev|cd ..)"
function _hist_indicator(){
    cttime=$(date +%H:%M:%S)
    [[ ! -v HISTFILE ]] && export NOHIST="$cttime ❎ " || export NOHIST="$cttime "
}
precmd_functions+=(_hist_indicator)

zstyle ':completion:complete:*:options' sort false
zstyle ":completion:*:git-checkout:*" sort false
zstyle ':completion:*:descriptions' format '[%d]'
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'exa -1 --icons --color=always $realpath'
zstyle ':fzf-tab:*' switch-group ',' '.'
zstyle ':completion:*:*:*:*:processes' command "ps -u $USER -o pid,user,comm -w -w"
zstyle ':fzf-tab:complete:(kill|ps):argument-rest' fzf-preview \
  '[[ $group == "[process ID]" ]] && ps --pid=$word -o cmd --no-headers -w -w'
zstyle ':fzf-tab:complete:(kill|ps):argument-rest' fzf-flags --preview-window=down:3:wrap
export GPG_TTY=$(tty)
export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin
export USE_GKE_GCLOUD_AUTH_PLUGIN=True
