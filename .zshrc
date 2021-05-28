# Profiling 
# run zprof from terminal
# zmodload zsh/zprof

# Set starting path
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

# supress console output during initialization 
POWERLEVEL9K_INSTANT_PROMPT=quiet

# auto-update oh-my-zsh (in days).
UPDATE_ZSH_DAYS=15

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion.
# Case-sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to automatically update without prompting.
# DISABLE_UPDATE_PROMPT="true"

# Uncomment the following line if pasting URLs and other text is messed up.
# DISABLE_MAGIC_FUNCTIONS="true"

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# Caution: this setting can cause issues with multiline prompts (zsh 5.7.1 and newer seem to work)
# See https://github.com/ohmyzsh/ohmyzsh/issues/5765
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
HIST_STAMPS="mm/dd/yyyy"


# History environment variables
HISTFILE=${HOME}/.zsh_history
HISTSIZE=50000                # Maximum number of history entries to keep alive in one session
SAVEHIST=10000                # Maximum number of history entries to keep.


setopt HIST_EXPIRE_DUPS_FIRST # Expire duplicates first
setopt HIST_IGNORE_DUPS       # Do not enter 2 consecutive duplicates into history
setopt HIST_IGNORE_SPACE      # Ignore command lines with leading spaces
setopt HIST_REDUCE_BLANKS     # Ignore unecessary whitespace
setopt HIST_VERIFY            # Reload results of history expansion before executing
setopt HIST_NO_STORE          # Don't store calls to `history` or `fc`
setopt SHARE_HISTORY          # Constantly share history between shell instances
setopt EXTENDED_HISTORY       # Save time stamps and durations
setopt INC_APPEND_HISTORY     # Constantly update $HISTFILE
setopt NO_HIST_BEEP           # Disable that awful beep when you hit the edges of the history

source $ZSH/oh-my-zsh.sh

# load aliases and functions
source ~/.zsh_aliases
source ~/.zsh_functions


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

# git
zinit wait lucid for \
        OMZL::git.zsh \
  atload"unalias grv" \
        OMZP::git

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
		         OMZP::jira

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

# Don't bind these keys until ready
bindkey -r '^[[A'
bindkey -r '^[[B'
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

# Tab completions
zinit ice wait lucid blockf atpull'zinit creinstall -q .'
zinit light zsh-users/zsh-completions

# Syntax highlighting
zinit ice wait lucid atinit'zicompinit; zicdreplay'
zinit light zdharma/fast-syntax-highlighting

# Lazy load NVM
export NVM_COMPLETION=true
export NVM_LAZY_LOAD=true
zinit ice wait lucid
zinit light lukechilds/zsh-nvm

# rbenv
zinit ice wait lucid
zinit light htlsne/zinit-rbenv

# or
# eval "$(rbenv init - --no-rehash)"

# - - - - - - - - - - - - - - - - - - - -
# END Zinit stuff
# - - - - - - - - - - - - - - - - - - - -

# https://gist.github.com/ctechols/ca1035271ad134841284  ################
autoload -Uz compinit
if [[ -n ${ZDOTDIR}/.zcompdump(#qN.mh+24) ]]; then
	compinit;
else
	compinit -C;
fi;

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
