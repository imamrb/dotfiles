# Set starting directory
if [[ $PWD == $(realpath ~) ]]; then
    cd $PWD/Projects
fi

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# - - - - - - - - - - - - - - - - - - - -
# Oh-my-zsh
# - - - - - - - - - - - - - - - - - - - -

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

POWERLEVEL9K_INSTANT_PROMPT=quiet      # Supress console output during initialization
UPDATE_ZSH_DAYS=15                     # Auto-update oh-my-zsh (in days).

# # This makes repository status check for large repositories much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"   # Disable marking untracked files under VCS as dirty.


# History environment variables
HISTFILE=${HOME}/.zsh_history
HISTSIZE=50000                         # Maximum number of history entries to keep alive in one session
SAVEHIST=10000                         # Maximum number of history entries to keep.
HIST_STAMPS="mm/dd/yyyy"               # Set one of the following "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"

setopt HIST_EXPIRE_DUPS_FIRST          # Expire duplicates first
setopt HIST_IGNORE_DUPS                # Do not enter 2 consecutive duplicates into history
setopt HIST_IGNORE_SPACE               # Ignore command lines with leading spaces
setopt HIST_REDUCE_BLANKS              # Ignore unecessary whitespace
setopt HIST_FIND_NO_DUPS               # Ignore duplicates when searching

setopt HIST_VERIFY                     # Reload results of history expansion before executing
setopt HIST_NO_STORE                   # Don't store calls to `history` or `fc`

setopt SHARE_HISTORY                   # Constantly share history between shell instances
setopt APPEND_HISTORY                  # Append history rather than overwrite
setopt EXTENDED_HISTORY                # Save time stamps and durations
setopt INC_APPEND_HISTORY              # Constantly update $HISTFILE

setopt NO_HIST_BEEP                    # Disable that awful beep when you hit the edges of the history
# setopt AUTO_CD                         # Change path without specifying cd


source $ZSH/oh-my-zsh.sh

# - - - - - - - - - - - - - - - - - - - -
# Zinit
# - - - - - - - - - - - - - - - - - - - -

### Added by Zinit's installer
if [[ ! -f $HOME/.zinit/bin/zinit.zsh ]]; then
    print -P "%F{33}▓▒░ %F{220}Installing %F{33}DHARMA%F{220} Initiative Plugin Manager (%F{33}zdharma/zinit%F{220})…%f"
    command mkdir -p "$HOME/.zinit" && command chmod g-rwX "$HOME/.zinit"
    command git clone https://github.com/zdharma/zinit "$HOME/.zinit/bin" && \
        print -P "%F{33}▓▒░ %F{34}Installation successful.%f%b" || \
        print -P "%F{160}▓▒░ The clone has failed.%f%b"
fi

source "$HOME/.zinit/bin/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# Load a few important annexes, without Turbo
# (this is currently required for annexes)
zinit light-mode for \
    zinit-zsh/z-a-rust \
    zinit-zsh/z-a-as-monitor \
    zinit-zsh/z-a-patch-dl \
    zinit-zsh/z-a-bin-gem-node

### End of Zinit's installer chunk

# - - - - - - - - - - - - - - - - - - - -
# Theme
# - - - - - - - - - - - - - - - - - - - -

# Most Themes Use This Option.
setopt promptsubst

## needs: oh-my-zsh
zinit ice depth=1; zinit light romkatv/powerlevel10k


# OMZ Plugins Load first
zinit wait lucid light-mode for \
		         OMZP::rails \
                 OMZP::colored-man-pages \
		         OMZP::jira


# Source aliases and functions
zinit ice wait lucid 
zinit snippet ~/.zsh_aliases
zinit ice wait lucid 
zinit snippet ~/.zsh_functions 
                

# - - - - - - - - - - - - - - - - - - - -
# Begin zinits Plugins
# - - - - - - - - - - - - - - - - - - - -

## needs: zinit, fzf

# z
zinit ice wait blockf lucid
zinit light rupa/z

# z tab completion
zinit wait lucid light-mode for \
		  	   changyuheng/fz \
		  	   andrewferrier/fzf-z \
		  	   changyuheng/zsh-interactive-cd

# diff so fancy
zinit ice wait lucid as"program" pick"bin/git-dsf"
zinit light zdharma/zsh-diff-so-fancy

# Don't bind these keys until ready
bindkey -r '^[[A' # Arrow Up, `cat -v` for checking
bindkey -r '^[[B' # Arrow Down
function __bind_history_keys() {
  bindkey '^[[A' history-substring-search-up
  bindkey '^[[B' history-substring-search-down
}
# History substring searching
zinit ice wait lucid atload'__bind_history_keys'
zinit light zsh-users/zsh-history-substring-search

# Autosuggestions, trigger precmd hook upon load
zinit ice wait lucid atload'_zsh_autosuggest_start'
zinit light zsh-users/zsh-autosuggestions
export ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=10

# Lazy load NVM
export NVM_LAZY_LOAD=true
zinit ice wait lucid
zinit light lukechilds/zsh-nvm

# rbenv
zinit ice wait lucid
zinit light htlsne/zinit-rbenv

# Tab completions
zinit ice wait lucid blockf atpull'zinit creinstall -q .'
zinit light zsh-users/zsh-completions

# Syntax highlighting, place at end
zinit ice wait lucid atinit'zicompinit; zicdreplay'
zinit light zdharma/fast-syntax-highlighting

# # direnv
# eval "$(direnv hook zsh)"

# or
# eval "$(rbenv init - --no-rehash)"

# - - - - - - - - - - - - - - - - - - - -
# END Zinit stuff
# - - - - - - - - - - - - - - - - - - - -

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
