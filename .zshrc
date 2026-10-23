# -----------------------------------
# Oh My Zsh
# -----------------------------------
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="amuse"
zstyle ':omz:update' mode auto
ENABLE_CORRECTION="false"
COMPLETION_WAITING_DOTS="true"
HYPHEN_INSENSITIVE="true"
plugins=(git)

BREW_PREFIX="/opt/homebrew"
[[ -d $BREW_PREFIX ]] || BREW_PREFIX="$(brew --prefix)"
fpath=("$BREW_PREFIX/share/zsh/site-functions" $fpath)

source "$ZSH/oh-my-zsh.sh"

# -----------------------------------
# PATH
# -----------------------------------
typeset -U path
path=("$HOME/.local/bin" $path)

# -----------------------------------
# Histórico
# -----------------------------------
HISTFILE=~/.zsh_history
HISTSIZE=100000
SAVEHIST=100000

setopt SHARE_HISTORY
setopt EXTENDED_HISTORY
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_FIND_NO_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_REDUCE_BLANKS
setopt HIST_VERIFY

# Histórico enquanto escreves: lista abaixo da linha, ↑/↓ navegam nela (nativo, sem plugin)
typeset -g _hist_prefix=''
typeset -gi _hist_idx=0
typeset -ga _hist_matches
typeset -g _hist_accepted=''

_hist_load() {
  _hist_prefix=$BUFFER
  _hist_idx=0
  _hist_matches=(${(M)${(u)history[@]}:#${(b)_hist_prefix}?*})
  _hist_matches=(${_hist_matches[1,8]})
}

_hist_apply() {
  if (( _hist_idx == 0 )); then
    BUFFER=$_hist_prefix
  else
    BUFFER=${_hist_matches[_hist_idx]}
  fi
  CURSOR=${#BUFFER}
  POSTDISPLAY=''
}

_hist_down() {
  [[ $LASTWIDGET == _hist_(up|down) ]] || _hist_load
  (( ${#_hist_matches} )) || return
  (( _hist_idx < ${#_hist_matches} )) && (( _hist_idx++ ))
  _hist_apply
}

_hist_up() {
  if [[ $LASTWIDGET != _hist_(up|down) ]]; then
    _hist_load
    (( ${#_hist_matches} )) && _hist_idx=1
  elif (( _hist_idx > 0 )); then
    (( _hist_idx-- ))
  fi
  _hist_apply
}

_hist_tab() {
  if [[ $LASTWIDGET == _hist_(up|down) ]] && (( _hist_idx > 0 )); then
    _hist_accepted=$BUFFER
    zle -M ''
    return
  fi
  zle fzf-completion
}

_history_hint() {
  if [[ -n $_hist_accepted && $BUFFER == $_hist_accepted ]]; then
    zle -M ''
    return
  fi
  _hist_accepted=''
  if [[ $LASTWIDGET != _hist_(up|down) ]]; then
    if (( ${#BUFFER} < 2 )) || [[ $BUFFER == *$'\n'* ]]; then
      zle -M ''
      return
    fi
    _hist_load
  fi
  if (( ! ${#_hist_matches} )); then
    zle -M ''
    return
  fi
  local -a lines
  local i
  for i in {1..${#_hist_matches}}; do
    if (( i == _hist_idx )); then
      lines+=("> ${_hist_matches[i]}")
    else
      lines+=("  ${_hist_matches[i]}")
    fi
  done
  zle -M "${(F)lines}"
}

zle -N _hist_up
zle -N _hist_down
zle -N _hist_tab
bindkey '^[[A' _hist_up
bindkey '^[OA' _hist_up
bindkey '^[[B' _hist_down
bindkey '^[OB' _hist_down
bindkey '^P' _hist_up
bindkey '^N' _hist_down

autoload -Uz add-zle-hook-widget
add-zle-hook-widget line-pre-redraw _history_hint

# -----------------------------------
# Autocomplete nativo
# -----------------------------------
zstyle ':completion:*' completer _complete _match _approximate
zstyle ':completion:*:approximate:*' max-errors 1 numeric
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' verbose yes
zstyle ':completion:*' complete-options true
zstyle ':completion:*' squeeze-slashes true
zstyle ':completion:*' list-dirs-first true
zstyle ':completion:*:descriptions' format '%F{yellow}-- %d --%f'
zstyle ':completion:*:messages' format '%F{blue}-- %d --%f'
zstyle ':completion:*:warnings' format '%F{red}-- sem resultados --%f'
zstyle ':completion:*:*:kill:*' menu yes select
zstyle ':completion:*:kill:*' force-list always
zmodload zsh/complist
bindkey -M menuselect '^[[Z' reverse-menu-complete
bindkey -M menuselect '^[' send-break

# -----------------------------------
# fnm (Node.js)
# -----------------------------------
eval "$(fnm env --use-on-cd)"

# -----------------------------------
# fzf (Ctrl+R histórico, Ctrl+T ficheiros, Alt+C pastas)
# -----------------------------------
source <(fzf --zsh)
bindkey '^I' _hist_tab
export FZF_DEFAULT_OPTS='--height=40% --layout=reverse --border'
export FZF_CTRL_R_OPTS='--height=60%'
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git --exclude node_modules'
export FZF_CTRL_T_COMMAND=$FZF_DEFAULT_COMMAND
export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git --exclude node_modules'
export FZF_CTRL_T_OPTS='--preview "bat --style=numbers --color=always --line-range=:200 {}"'
export FZF_ALT_C_OPTS='--preview "ls -1A {}"'

_fzf_compgen_path() { fd --hidden --follow --exclude .git --exclude node_modules . "$1" }
_fzf_compgen_dir() { fd --type d --hidden --follow --exclude .git --exclude node_modules . "$1" }

# -----------------------------------
# zoxide (z <pasta>, zi para escolher)
# -----------------------------------
eval "$(zoxide init zsh)"

# -----------------------------------
# Aliases
# -----------------------------------
alias ll='ls -lah'
alias la='ls -A'
alias l='ls -CF'

alias gs='git status'
alias gc='git commit'

alias cls='clear'
alias clinica='cd ~/www/doutorfinancas'
alias front='cd ~/www/doutorfinancas/clinica.doutorfinancas.pt'
alias backend='cd ~/www/doutorfinancas/api.doutorfinancas.pt'

# -----------------------------------
# zsh-autosuggestions (→ aceita a sugestão)
# -----------------------------------
ZSH_AUTOSUGGEST_STRATEGY=(history completion)
ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=200
source "$BREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh"

# -----------------------------------
# zsh-syntax-highlighting (sempre por último)
# -----------------------------------
source "$BREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
