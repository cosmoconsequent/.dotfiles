typeset -U path PATH

[[ -x /home/linuxbrew/.linuxbrew/bin/brew ]] && eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
brew_env() {
    [[ -x /opt/homebrew/bin/brew ]] && eval "$(/opt/homebrew/bin/brew shellenv)"
}
brew_env

llvm_path() {
    [[ -d "$HOMEBREW_PREFIX/opt/llvm/bin" ]] && export PATH="$HOMEBREW_PREFIX/opt/llvm/bin:$PATH"
}
llvm_path
command -v clang &>/dev/null && export CC="clang"
command -v clang++ &>/dev/null && export CXX="clang++"

[[ -s "$HOME/.cargo/env" ]] && . "$HOME/.cargo/env"

[[ -d /usr/local/go/bin ]] && export PATH="/usr/local/go/bin:$PATH"

# node available to all shells, --use-on-cd hook only in interactive shells
if command -v fnm &>/dev/null; then
    # drop inherited fnm links and add this shell's own, isolating `fnm use`
    path=(${path:#*fnm_multishells*/bin})
    if [[ -o interactive ]]; then
        eval "$(fnm env --shell zsh --use-on-cd)"
    else
        eval "$(fnm env --shell zsh)"
    fi
fi

local_bin_path() {
    [[ -d "$HOME/bin" ]] && export PATH="$HOME/bin:$PATH"
    [[ -d "$HOME/.local/bin" ]] && export PATH="$HOME/.local/bin:$PATH"
}
local_bin_path

if command -v nvim &>/dev/null; then
    export EDITOR="nvim"
    export MANPAGER="nvim +Man!"
fi

true
