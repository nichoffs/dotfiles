# This goes in ~/.zshrc to link to this
#if [ -r ~/.config/zshrc ]; then
#    source ~/.config/zshrc
#fi

# prompt setup

autoload -Uz vcs_info
precmd() { vcs_info }

zstyle ':vcs_info:git:*' formats '%b '
setopt PROMPT_SUBST
PROMPT='%F{green}%*%f %F{blue}%~%f %F{red}${vcs_info_msg_0_}%f$ '

# zsh autosuggestions and syntax highlighting
source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

# helpful aliases
alias venv="source venv/bin/activate"

# bison update
export PATH="/opt/homebrew/opt/bison@3.8/bin:$PATH"

export FIREWORKS_API_KEY="TZRkXJlFMGkc2feu9uw1DijEOXsXiP9zAOUAw25tGiTUFQOg"
