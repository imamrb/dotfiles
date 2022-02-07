skip_global_compinit=1  # Skip the not really helping Ubuntu global compinit

PATH="$HOME/.rbenv/shims:$HOME/.rbenv/bin:$PATH"
PATH="~/.bin:/usr/local/sbin:$PATH"               # ensure dotfiles bin directory is loaded first
PATH="/usr/local/opt/mysql@5.7/bin:$PATH"         # Export mysql path
# PATH="$HOME/.rbenv/versions/2.7.2/bin:$PATH"

# Load private environment variables if file exists
if [ -f "$HOME/.zshenv_private" ]; then
  source $HOME/.zshenv_private
fi

export PATH

export optflags="-Wno-error=implicit-function-declaration"
export LDFLAGS="-L/opt/homebrew/opt/libffi/lib"
export CPPFLAGS="-I/opt/homebrew/opt/libffi/include"
export PKG_CONFIG_PATH="/opt/homebrew/opt/libffi/lib/pkgconfig"
export OBJC_DISABLE_INITIALIZE_FORK_SAFETY=YES

export EDITOR=nvim
export VISUAL="$EDITOR"
export CLICOLOR=1

export ZSH_TMUX_AUTOQUIT=false
export ZSH_TMUX_AUTOSTART=false
export ZSH_TMUX_AUTOSTART_ONCE=false
export ZSH_TMUX_AUTOCONNECT=false

export HOMEBREW_NO_ANALYTICS=1     
export HOMEBREW_NO_AUTO_UPDATE=1 # Disable Homebrew Autoupdate, uses homebrew/autoupdate

export LS_COLORS='rs=0:no=00:mi=00:mh=00:ln=01;36:or=01;31:di=01;34:ow=04;01;34:st=34:tw=04;34:pi=01;33:so=01;33:do=01;33:bd=01;33:cd=01;33:su=01;35:sg=01;35:ca=01;35:ex=01;32:'

# follow symbolic links and don't want it to exclude hidden files
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
export JQ_ZSH_PLUGIN_EXPAND_ALIASES=0

export DISABLE_SPRING=true

# jira Plugin Config
JIRA_URL='https://welltravel.atlassian.net/'
JIRA_NAME='imam.hossain'
JIRA_PROJECT_KEY='LMS'
JIRA_DEFAULT_ACTION='rapidboard'
