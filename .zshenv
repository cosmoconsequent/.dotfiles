[[ -d "$HOME/bin" ]] && export PATH="$HOME/bin:$PATH"
[[ -d "$HOME/.local/bin" ]] && export PATH="$HOME/.local/bin:$PATH"

[[ -x /home/linuxbrew/.linuxbrew/bin/brew ]] && \
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

export EDITOR="nvim"

[[ -d "$HOMEBREW_PREFIX/opt/llvm/bin" ]] && export PATH="$HOMEBREW_PREFIX/opt/llvm/bin:$PATH"
if command -v clang >/dev/null 2>&1; then
    export CC="clang"
    export CXX="clang++"
fi

[[ -s "$HOME/.cargo/env" ]] && . "$HOME/.cargo/env"

[[ -d /usr/local/go/bin ]] && export PATH="/usr/local/go/bin:$PATH"

export NVM_DIR="$HOME/.nvm"
[[ -s "$NVM_DIR/nvm.sh" ]] && . "$NVM_DIR/nvm.sh"

true
