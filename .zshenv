typeset -U path PATH

export EDITOR="nvim"

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

command -v fnm &>/dev/null && eval "$(fnm env --shell zsh)"

local_bin_path() {
    [[ -d "$HOME/bin" ]] && export PATH="$HOME/bin:$PATH"
    [[ -d "$HOME/.local/bin" ]] && export PATH="$HOME/.local/bin:$PATH"
}
local_bin_path

true
