  #!/usr/bin/env bash

# Install command-line tools using Homebrew.

# Ask for the administrator password upfront.
sudo -v

# Keep-alive: update existing `sudo` time stamp until the script has finished.
while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

# Check for Homebrew,
# Install if we don't have it
if test ! $(which brew); then
  echo "Installing homebrew..."
  ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

# Make sure we’re using the latest Homebrew.
brew update

# Upgrade any already-installed formulae.
brew upgrade --all

# Install GNU core utilities (those that come with OS X are outdated).
# Don’t forget to add `$(brew --prefix coreutils)/libexec/gnubin` to `$PATH`.
brew install coreutils
sudo ln -s /usr/local/bin/gsha256sum /usr/local/bin/sha256sum

# Install some other useful utilities like `sponge`.
brew install moreutils
# Install GNU `find`, `locate`, `updatedb`, and `xargs`, `g`-prefixed.
brew install findutils
# Install GNU `sed`, overwriting the built-in `sed`.
brew install gnu-sed
# Install `wget` with IRI support.
brew install wget

# Install more recent versions of some OS X tools.
brew install vim
brew install git
brew install git-lfs
brew install git-flow
brew install git-extras

# Install ruby-build and rbenv
brew install ruby-build
brew install rbenv
LINE='eval "$(rbenv init -)"'
grep -q "$LINE" ~/.zshrc || echo "$LINE" >> ~/.zshrc
source ~/.zshrc

# Apps
brew install google-chrome
brew install slack

# Development tools
brew install visual-studio-code
brew install sublime-text
brew install recordit
brew install iterm2
brew install yarn
brew install chromedriver

# Libraries
brew install libxml2
brew install libxslt
brew link libxml2 --force
brew link libxslt --force
brew install cmake
brew install imagemagick
# ruby-vips gem dependency
brew install vips


# nvm install-latest-npm

# Install data stores
brew tap homebrew/services
brew install mysql@5.7
brew install postgresql
brew install redis
brew install sequel-pro


# Install Fonts
brew tap homebrew/cask-fonts
brew install font-hack-nerd-font
brew install font-fira-code-nerd-font
brew install font-fira-mono-nerd-font
brew install font-inconsolata

# Other Tools
brew install xpdf
brew install exa
brew tap homebrew/autoupdate

# Remove outdated versions from the cellar.
brew cleanup

## Setup Rails

# Install Necessary Ruby Versions
rbenv install 2.7.2
rbenv install 2.7.1
rbenv global 2.7.2

# Install some gems
brew install shared-mime-info
gem install ruby-vips
gem install bundler

############################################
#                  MORE                    #
############################################

# # Install RingoJS and Narwhal.
# # Note that the order in which these are installed is important;
# # see http://git.io/brew-narwhal-ringo.
# brew install ringojs
# brew install narwhal

# # Install Python
# brew install python
# brew install python3


# brew cask install --appdir="/Applications" atom
# brew cask install --appdir="/Applications" virtualbox
# brew cask install --appdir="/Applications" vagrant
# brew cask install --appdir="/Applications" macdown

# Misc casks
# brew cask install --appdir="/Applications" google-chrome
# brew cask install --appdir="/Applications" firefox
# brew cask install --appdir="/Applications" skype
# brew cask install --appdir="/Applications" slack
# brew cask install --appdir="/Applications" dropbox
# brew cask install --appdir="/Applications" evernote
# brew cask install --appdir="/Applications" 1password
#brew cask install --appdir="/Applications" gimp
#brew cask install --appdir="/Applications" inkscape

#Remove comment to install LaTeX distribution MacTeX
#brew cask install --appdir="/Applications" mactex

# # Install Docker, which requires virtualbox
# brew install docker
# brew install boot2docker

# # Install developer friendly quick look plugins; see https://github.com/sindresorhus/quick-look-plugins
# brew install qlcolorcode qlstephen qlmarkdown quicklook-json qlprettypatch quicklook-csv betterzip qlimagesize webpquicklook suspicious-package quicklookase qlvideo


# Install font tools.
# brew tap bramstein/webfonttools
# brew install sfnt2woff
# brew install sfnt2woff-zopfli
# brew install woff2

# # Install some CTF tools; see https://github.com/ctfs/write-ups.
# brew install aircrack-ng
# brew install bfg
# brew install binutils
# brew install binwalk
# brew install cifer
# brew install dex2jar
# brew install dns2tcp
# brew install fcrackzip
# brew install foremost
# brew install hashpump
# brew install hydra
# brew install john
# brew install knock
# brew install netpbm
# brew install nmap
# brew install pngcheck
# brew install socat
# brew install sqlmap
# brew install tcpflow
# brew install tcpreplay
# brew install tcptrace
# brew install ucspi-tcp # `tcpserver` etc.
# brew install homebrew/x11/xpdf
# brew install xz

# # Install other useful binaries.
# brew install ack
# brew install dark-mode
# #brew install exiv2

# brew install hub
# brew install lua
# brew install lynx
# brew install p7zip
# brew install pigz
# brew install pv
# brew install rename
# brew install rhino
# brew install speedtest_cli
# brew install ssh-copy-id
# brew install tree
# brew install webkit2png
# brew install zopfli
# brew install pkg-config libffi
# brew install pandoc

# # Install Heroku
# brew install heroku/brew/heroku
# heroku update

# # Core casks
# brew cask install --appdir="/Applications" alfred
# brew cask install --appdir="~/Applications" iterm2
# brew cask install --appdir="~/Applications" java
# brew cask install --appdir="~/Applications" xquartz