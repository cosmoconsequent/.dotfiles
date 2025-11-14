# global
HISTFILE="$HOME/.zsh_history"
HISTSIZE=10000
SAVEHIST=10000

setopt HIST_IGNORE_ALL_DUPS

bindkey -e
bindkey '^[[3~' delete-char

# fpaths
[[ -d "$HOME/.zsh/pure" ]] && fpath+=($HOME/.zsh/pure)
[[ -d "$HOMEBREW_PREFIX/share/zsh/site-functions" ]] && fpath+="$HOMEBREW_PREFIX/share/zsh/site-functions"
[[ -d "$HOMEBREW_PREFIX/share/zsh-completions" ]] && fpath+="$HOMEBREW_PREFIX/share/zsh-completions"

# theme
autoload -U promptinit; promptinit
prompt pure

# completions
zstyle ':completion:*' completer _expand _complete _ignored _correct _approximate
autoload -Uz compinit; compinit

[[ -s "$NVM_DIR/bash_completion" ]] && . "$NVM_DIR/bash_completion"

# plugins
load_plugin() {
    local plugin_name=$1
    local arch_path="/usr/share/zsh/plugins/$plugin_name/$plugin_name.zsh"
    local brew_path="$HOMEBREW_PREFIX/share/$plugin_name/$plugin_name.zsh"

    if [[ -f "$arch_path" ]]; then
        source "$arch_path"
    elif [[ -f "$brew_path" ]]; then
        source "$brew_path"
    fi
}

load_plugin "zsh-autosuggestions"
load_plugin "zsh-history-substring-search"
load_plugin "zsh-syntax-highlighting" # load last

unset -f load_plugin

bindkey "^ " autosuggest-accept
bindkey "^P" history-substring-search-up
bindkey "^N" history-substring-search-down

# utils
export GPG_TTY="$(tty)" # pass-git-helper

[[ -S "$XDG_RUNTIME_DIR/ssh-agent.socket" ]] && \
    export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/ssh-agent.socket"

if command -v zoxide >/dev/null 2>&1; then
    eval "$(zoxide init zsh)"
fi

if command -v fzf >/dev/null 2>&1; then
    source <(fzf --zsh)
    export FZF_DEFAULT_COMMAND="fd --type f --strip-cwd-prefix --hidden --follow --exclude .git"
    export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
    export FZF_CTRL_R_OPTS="--preview 'echo {}' --preview-window down:3:hidden:wrap --bind '?:toggle-preview'"
fi

mkcd() {
    mkdir -p "$1" && cd "$1"
}

function config {
    git --git-dir="$HOME/.dotfiles/" --work-tree="$HOME" $@
}

# aliases
alias l="eza -l --group-directories-first --git"
alias la="l -a"
alias lt="l -TL 3"
alias lta="lt -a"

alias fz="fzf --preview 'bat --style=numbers --color=always {} 2>/dev/null || cat {} 2>/dev/null || echo {}'"
alias fze="$EDITOR \$(fz)"

alias gl='git log --oneline --graph --decorate'

# startup
if [[ -z "$DISPLAY" && "$XDG_VTNR" -eq 1 ]]; then
    if command -v hyprland >/dev/null 2>&1; then
        exec hyprland
    elif command -v sway >/dev/null 2>&1; then
        exec sway
    fi
fi

if [[ ( -n "$DISPLAY" || -n "$TERM_PROGRAM" ) && -z "$TMUX" ]]; then
    tmux has -t main 2>/dev/null && tmux a -t main || tmux new -t main
fi

true
