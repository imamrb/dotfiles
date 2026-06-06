# Set starting directory
if [[ $PWD == $HOME  && -d "$PWD/Work" ]]; then
  cd $PWD/Work/gdk/gitlab
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
# DISABLE_UNTRACKED_FILES_DIRTY="true" # Disable marking untracked files under VCS as dirty.


# History environment variables
HISTFILE=${HOME}/.zsh_history
export HISTSIZE=10000000               # Maximum number of history entries to keep alive in one session
export SAVEHIST=10000000               # Maximum number of history entries to keep.
HIST_STAMPS="mm/dd/yyyy"               # Set one of the following "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"

setopt HIST_EXPIRE_DUPS_FIRST          # Expire duplicates first
setopt HIST_IGNORE_DUPS                # Do not enter 2 consecutive duplicates into history
setopt HIST_IGNORE_ALL_DUPS
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
# setopt AUTO_CD                       # Change path without specifying cd

# only show full path when its a git directory powerlevel10k
function zsh_directory_name() {
  emulate -L zsh
  [[ $1 == d ]] || return
  while [[ $2 != / ]]; do
    if [[ -e $2/.git ]]; then
      typeset -ga reply=(${2:h:t}/${2:t} $#2)
      return
    fi
    2=${2:h}
  done
  return 1
}

export DISABLE_AUTO_TITLE="true"
precmd() {
  # sets the terminal tab title to current dir
  echo -ne "\e]1;${PWD##*/}\a"
}

source $ZSH/oh-my-zsh.sh

# - - - - - - - - - - - - - - - - - - - -
# Zinit
# - - - - - - - - - - - - - - - - - - - -

### Added by Zinit's installer
if [[ ! -f $HOME/.zinit/bin/zinit.zsh ]]; then
    print -P "%F{33}▓▒░ %F{220}Installing %F{33}DHARMA%F{220} Initiative Plugin Manager (%F{33}zdharma-continuum/zinit%F{220})…%f"
    command mkdir -p "$HOME/.zinit" && command chmod g-rwX "$HOME/.zinit"
    command git clone https://github.com/zdharma-continuum/zinit "$HOME/.zinit/bin" && \
        print -P "%F{33}▓▒░ %F{34}Installation successful.%f%b" || \
        print -P "%F{160}▓▒░ The clone has failed.%f%b"
fi

source "$HOME/.zinit/bin/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit

# Load a few important annexes, without Turbo
# (this is currently required for annexes)
zinit light-mode for \
    zdharma-continuum/zinit-annex-as-monitor \
    zdharma-continuum/zinit-annex-bin-gem-node \
    zdharma-continuum/zinit-annex-patch-dl \
    zdharma-continuum/zinit-annex-rust

### End of Zinit's installer chunk

# - - - - - - - - - - - - - - - - - - - -
# Theme
# - - - - - - - - - - - - - - - - - - - -

# Most Themes Use This Option.
setopt promptsubst

## needs: oh-my-zsh
zinit ice depth=1; zinit light romkatv/powerlevel10k

# zinit ice pick"async.zsh" src"pure.zsh"
# zinit light sindresorhus/pure

# zinit light spaceship-prompt/spaceship-prompt

# zinit ice svn
# zinit snippet OMZ::plugins/tmux

# compdef '_files -W "/System/Volumes/Data/Applications/*"' opena

# - - - - - - - - - - - - - - - - - - - -
# Begin zinits Plugins
# - - - - - - - - - - - - - - - - - - - -

# OMZ Plugins Load first
zinit wait lucid for \
        atload"unalias rs" OMZP::rails \
            OMZP::colored-man-pages \
            OMZP::extract \
            OMZP::jsontools\
            # OMZP::docker-compose \
        # as"completion" \
        #     OMZP::docker/_docker

# Some utilities
zinit wait"1" lucid light-mode for \
               djui/alias-tips \
    	       b4b4r07/emoji-cli
               # imamrb/jira.plugin.zsh

# delta git pager
# zinit ice wait lucid as"command" from"gh-r" mv"delta* -> delta" pick"delta/delta"
# zinit light dandavison/delta

# After automatic unpacking it provides program from github releases
# Each tool gets its own atclone to hoist nested completion files
zinit ice wait"1" lucid from"gh-r" as"null" sbin"fzf"
zinit light junegunn/fzf

zinit ice wait"1" lucid from"gh-r" as"null" sbin"**/fd" \
    atclone'ln -sf */autocomplete/_fd _fd' atpull'%atclone' completions
zinit light sharkdp/fd

zinit ice wait"1" lucid from"gh-r" as"null" sbin"**/bat" \
    atclone'ln -sf $PWD/*/autocomplete/bat.zsh $HOME/.local/share/zinit/completions/_bat' \
    atpull'%atclone'
zinit light sharkdp/bat

zinit ice wait"1" lucid from"gh-r" as"null" sbin"**/delta"
zinit light dandavison/delta

zinit ice wait"1" lucid from"gh-r" as"null" sbin"**/rg" \
    atclone'ln -sf */complete/_rg _rg' atpull'%atclone' completions
zinit light BurntSushi/ripgrep

# eza — eza-community doesn't ship macOS binaries, download from cargo-quickinstall
zinit ice wait"1" lucid as"null" \
    id-as"eza" \
    atclone'curl -fsSL https://github.com/cargo-bins/cargo-quickinstall/releases/download/eza-0.23.4/eza-0.23.4-aarch64-apple-darwin.tar.gz | tar xz' \
    atpull'%atclone' \
    sbin"eza"
zinit load eza-community/eza

# git extensions
zinit ice wait"1" lucid as"null" completions
zinit light paulirish/git-open


# diff so fancy
zinit ice wait lucid sbin"bin/git-dsf"
zinit light zdharma-continuum/zsh-diff-so-fancy

zinit ice wait"1" lucid as"program" from"gitlab.com" \
      mv"roulette.sh -> roulette" pick"roulette" \
      atpull'!git reset --hard' \
      atclone"./configure.sh"
zinit light imam_h/gitlab-roulette

## ajaira
# zinit wait lucid light-mode for \
#                  reegnz/jq-zsh-plugin \
#                  supercrabtree/k \
#                  micha/resty

# zinit ice wait node"tldr"
# zinit light zdharma-continuum/null

# zinit ice wait lucid gem'!pry'
# zinit light zdharma-continuum/null

## needs: zinit, fzf

# zoxide (replaces z)
zinit ice wait lucid from"gh-r" as"command" mv"zoxide* -> zoxide" \
    atclone"./zoxide init zsh > init.zsh" atpull"%atclone" src"init.zsh" nocompile'!' \
    completions
zinit light ajeetdsouza/zoxide

# tealdeer — fast tldr client (raw binary, no archive)
zinit wait"1" lucid from="gh-r" as="null" for \
    id-as="tealdeer" \
    mv="tealdeer-macos-aarch64 -> tldr" sbin="tldr" \
    bpick="*macos-aarch64" \
    atclone="curl -fsSLo _tldr https://raw.githubusercontent.com/tealdeer-rs/tealdeer/main/completion/zsh_tealdeer" \
    atpull="%atclone" \
    completions \
    tealdeer-rs/tealdeer

# Clean stale completion symlinks
find "$ZINIT_HOME/completions" -type l ! -exec test -e {} \; -delete 2>/dev/null

# tab completion
zinit wait lucid light-mode for \
               Aloxaf/fzf-tab

ZVM_INIT_MODE=sourcing
ZVM_LINE_INIT_MODE=$ZVM_MODE_INSERT  # start in insert mode (normal shell behavior)
ZVM_VI_INSERT_ESCAPE_BINDKEY=jk      # jk to escape to normal mode
zinit ice depth=1
zinit light jeffreytse/zsh-vi-mode

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
export ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=10
zinit ice wait lucid atload'_zsh_autosuggest_start'
zinit light zsh-users/zsh-autosuggestions

# Binds Ctrl-R to a widget that searches for multiple keywords
zinit ice wait lucid
zinit load zdharma-continuum/history-search-multi-word


# compinit Imporoved
# checking the cached .zcompdump file to see if it must be regenerated once a day.
_zicompinit_custom() {
  setopt extendedglob local_options
  autoload -Uz compinit
  local zcd=${ZDOTDIR:-$HOME}/.zcompdump
  local zcdc="$zcd.zwc"
  # Compile the completion dump to increase startup speed, if dump is newer or doesn't exist,
  # in the background as this is doesn't affect the current session
  if [[ ! -f "$zcd" ]] || [[ -f "$zcd"(#qN.m+1) ]]; then
        compinit -i -d "$zcd"
        { rm -f "$zcdc" && zcompile "$zcd" } &!
  else
        compinit -C -d "$zcd"
        { [[ ! -f "$zcdc" || "$zcd" -nt "$zcdc" ]] && rm -f "$zcdc" && zcompile "$zcd" } &!
  fi
}

# Syntax highlighting, place at end
# use this line for profiling
# zinit ice wait lucid atinit'zmodload zsh/zprof; zicompinit; zicdreplay' \
#                                                atload'zprof | head -n 20; zmodload -u zsh/zprof'
zinit ice wait lucid atinit'_zicompinit_custom; zicdreplay;'
zinit light zdharma-continuum/fast-syntax-highlighting

# Tab completions
zinit ice wait lucid blockf atpull'zinit creinstall -q .'
zinit light zsh-users/zsh-completions


# bat
export MANPAGER="sh -c 'col -bx | bat -l man -p'"
export MANROFFOPT="-c"
alias cat="bat --paging=never"

# fzf — use fd + bat preview
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
export FZF_DEFAULT_OPTS='--height 40% --layout=reverse --border'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_CTRL_T_OPTS="--preview 'bat --color=always --line-range :50 {}'"
# Rebind fzf file picker from C-t (used by tmux) to C-f — after all plugins load
function zvm_after_init() {
  bindkey '^F' fzf-file-widget 2>/dev/null || true
}

# Source aliases and functions
source ~/.aliases

# Load private environment variables if file exists
if [[ -f "$HOME/.zshenv_private" ]]; then
  source $HOME/.zshenv_private
fi


# zinit ice wait lucid gem'!pry'
# zinit light zdharma-continuum/null


# mise (lazy: installed from gh-r, activated after prompt)
# Note: mise ships both a raw binary and .tar.gz; bpick selects the archive
zinit wait"2" lucid from="gh-r" as="null" for \
    id-as="mise" sbin="**/mise" \
    bpick="*macos-arm64.tar.gz" \
    atclone='./mise/bin/mise completion zsh > _mise; chmod +x mise/bin/mise' \
    atpull="%atclone" \
    atload='eval "$(mise activate zsh --shims)"' \
    jdx/mise


# ASDF

# zinit ice wait lucid fsrc"asdf.sh -> asdf"
# zinit light asdf-vm/asdf

# # NVM
# zinit ice wait lucid
# zinit light lukechilds/zsh-nvm

# rbenv
# zinit ice wait lucid
# zinit light htlsne/zinit-rbenv
# or
# eval "$(rbenv init - --no-rehash)"

# # direnv
# eval "$(direnv hook zsh)"

# eval "$(rbenv init -)"

## these files can also be loaded using turbo mode
## Requires zinit update <file> command to run after updating the file

# zinit ice wait lucid
# zinit snippet ~/.zsh_aliases
# zinit ice wait lucid
# zinit snippet ~/.zsh_functions

PATH="/usr/local/sbin:$PATH"
PATH="$HOME/.bin:$PATH"
PATH="$HOME/.local/share/bin:$PATH"
PATH="/opt/homebrew/opt/ruby/bin:$PATH"
PATH="$HOME/.local/share/mise/shims:$PATH"
PATH="$HOME/.local/bin:$PATH"
export PATH

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh


# >>> opentmux >>>
export OPENCODE_PORT=4096
alias opencode='opentmux'
# <<< opentmux <<<
