# global
HISTFILE="$HOME/.zsh_history"
HISTSIZE=10000
SAVEHIST=10000

setopt INC_APPEND_HISTORY HIST_IGNORE_ALL_DUPS HIST_REDUCE_BLANKS HIST_IGNORE_SPACE

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
zstyle ':completion:*:git-(checkout|switch):*' sort false
zstyle ':completion:*' menu no
zstyle ':fzf-tab:*' use-fzf-default-opts yes
zstyle ':fzf-tab:*' fzf-bindings 'tab:toggle+down' 'btab:toggle+up' # match fzf
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always $realpath'
# set descriptions format to enable group support
zstyle ':completion:*:descriptions' format '[%d]'
zstyle ':fzf-tab:*' switch-group '<' '>'
autoload -Uz compinit; compdump=($HOME/.zcompdump(Nmh-24)); (( $#compdump )) && compinit -C || compinit

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

load_plugin "fzf-tab"
load_plugin "zsh-history-substring-search"
load_plugin "zsh-autosuggestions" # wraps widgets
load_plugin "zsh-syntax-highlighting" # wraps widgets; load last

unset -f load_plugin

bindkey "^ " autosuggest-accept
bindkey "^P" history-substring-search-up
bindkey "^N" history-substring-search-down

# utils
alias l='eza -l --group-directories-first --git'
alias lt='l -TL 3'
alias gl='git log --oneline --graph --decorate'

config() {
    git --git-dir="$HOME/.dotfiles/" --work-tree="$HOME" "$@"
}
compdef config=git

command -v zoxide &>/dev/null && eval "$(zoxide init zsh)"

if command -v fzf &>/dev/null; then
    source <(fzf --zsh)
    export FZF_DEFAULT_OPTS="--layout=reverse --info=inline-right"
    export FZF_DEFAULT_COMMAND="fd --type f --strip-cwd-prefix --hidden --follow --exclude .git"
    export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
    export FZF_CTRL_T_OPTS="--preview 'bat --style=numbers --color=always {} 2>/dev/null || cat {}'"
    export FZF_CTRL_R_OPTS="--preview 'echo {}' --preview-window down:3:hidden:wrap --bind '?:toggle-preview'"
fi

[[ -S "$XDG_RUNTIME_DIR/ssh-agent.socket" ]] && \
    export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/ssh-agent.socket"

export GPG_TTY="$(tty)" # pass-git-helper

command -v fnm &>/dev/null && eval "$(fnm completions --shell zsh)"

# startup
if [[ -z "$DISPLAY" && "$XDG_VTNR" -eq 1 ]]; then
    if command -v start-hyprland &>/dev/null; then
        exec start-hyprland
    elif command -v sway &>/dev/null; then
        exec sway
    fi
fi

if [[ ( -n "$DISPLAY" || -n "$TERM_PROGRAM" ) && -z "$TMUX" ]]; then
    tmux has -t main 2>/dev/null && tmux a -t main || tmux new -s main
fi

true
