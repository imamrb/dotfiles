skip_global_compinit=1  # Skip the not really helping Ubuntu global compinit

PATH="$HOME/.rbenv/shims:$HOME/.rbenv/bin:$PATH"
PATH="~/.bin:/usr/local/sbin:$PATH"               # ensure dotfiles bin directory is loaded first
PATH="$PATH:/usr/local/opt/mysql@5.7/bin"         # Export mysql path
# PATH="$HOME/.rbenv/versions/2.7.2/bin:$PATH"

export PATH

export EDITOR=nano
export VISUAL="$EDITOR"
export CLICOLOR=1

export HOMEBREW_NO_ANALYTICS=1     
export HOMEBREW_NO_AUTO_UPDATE=1 # Disable Homebrew Autoupdate, uses homebrew/autoupdate

# jira Plugin Config

JIRA_URL='https://welltravel.atlassian.net/'
JIRA_NAME='imam.hossain'
JIRA_PROJECT_KEY='LMS'
JIRA_DEFAULT_ACTION='rapidboard'
