skip_global_compinit=1  # Skip the not really helping Ubuntu global compinit

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

# follow symbolic links and don't want it to exclude hidden files
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
export JQ_ZSH_PLUGIN_EXPAND_ALIASES=0

export ENABLE_SPRING=1
