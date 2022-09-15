skip_global_compinit=1  # Skip the not really helping Ubuntu global compinit

PATH="$HOME/.rbenv/shims/:$HOME/.rbenv/bin:$PATH"
PATH="~/.bin:/usr/local/sbin:$PATH"               # ensure dotfiles bin directory is loaded first
PATH="/usr/local/mysql/bin:$PATH"         # Export mysql path
# PATH="$HOME/.rbenv/versions/2.7.2/bin:$PATH"
PATH="/usr/local/texlive/2022/bin/x86_64-linux:$PATH"
# PATH="/opt/homebrew/opt/mysql/bin:$PATH"
export PATH

# mysql@5.7 is keg-only, which means it was not symlinked into /opt/homebrew,
# because this is an alternate version of another formula.

# If you need to have mysql@5.7 first in your PATH, run:
#   echo 'export PATH="/opt/homebrew/opt/mysql@5.7/bin:$PATH"' >> ~/.zshrc

# For compilers to find mysql@5.7 you may need to set:
#   export LDFLAGS="-L/opt/homebrew/opt/mysql@5.7/lib"
#   export CPPFLAGS="-I/opt/homebrew/opt/mysql@5.7/include"

# For pkg-config to find mysql@5.7 you may need to set:
#   export PKG_CONFIG_PATH="/opt/homebrew/opt/mysql@5.7/lib/pkgconfig"


# Rails bundler gem installation flags
export optflags="-Wno-error=implicit-function-declaration"
export OBJC_DISABLE_INITIALIZE_FORK_SAFETY=YES

if [[ "$OSTYPE" =~ ^darwin ]]; then
  export LDFLAGS="-L/opt/homebrew/opt/libffi/lib"
  export CPPFLAGS="-I/opt/homebrew/opt/libffi/include"
  export PKG_CONFIG_PATH="/opt/homebrew/opt/libffi/lib/pkgconfig"
fi

export EDITOR=nvim
export VISUAL="$EDITOR"
export CLICOLOR=1

export ZSH_TMUX_AUTOQUIT=false
export ZSH_TMUX_AUTOSTART=false
export ZSH_TMUX_AUTOSTART_ONCE=false
export ZSH_TMUX_AUTOCONNECT=false

export HOMEBREW_NO_ANALYTICS=1     
export HOMEBREW_NO_AUTO_UPDATE=1 # Disable Homebrew Autoupdate, uses homebrew/autoupdate
export HOMEBREW_CURLRC=1

export LS_COLORS='rs=0:no=00:mi=00:mh=00:ln=01;36:or=01;31:di=01;34:ow=04;01;34:st=34:tw=04;34:pi=01;33:so=01;33:do=01;33:bd=01;33:cd=01;33:su=01;35:sg=01;35:ca=01;35:ex=01;32:'

# follow symbolic links and don't want it to exclude hidden files
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
export JQ_ZSH_PLUGIN_EXPAND_ALIASES=0

# export DISABLE_SPRING=true

## .zshenv_private variables 

# TOKEN=''
# USERNAME=''

# export NPM_TOKEN=$TOKEN
# export GITHUB_PACKAGES_TOKEN=$TOKEN
# export GH_PACKAGES_ACCESS_TOKEN=$TOKEN

# export BUNDLE_RUBYGEMS__PKG__GITHUB__COM="$USERNAME:$TOKEN"
# export BUNDLE_GITHUB__COM=$TOKEN

# # jira Plugin Config
# export JIRA_URL=''
# export JIRA_NAME=''
# export JIRA_PROJECT_KEY=''
# export JIRA_DEFAULT_ACTION=''
