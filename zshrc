# Homebrew configuration
export PATH=/opt/homebrew/bin:$PATH

# Starship prompt initialization
eval "$(starship init zsh)"

# Shell enhancements
source $(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source $(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh

# ImageMagick configuration
export MAGICK_HOME=/opt/homebrew/opt/imagemagick
export PATH="$MAGICK_HOME/bin:$PATH"
