# Dotfiles ⚡

 - Shell: https://github.com/ohmyzsh/ohmyzsh
 - Theme: https://github.com/romkatv/powerlevel10k
 - Plugin Manager: https://github.com/zdharma/zinit

Setup scripts for mac: [/Documents/MacSetup](Documents/MacSetup)

## Prerequisite

```bash
# 1. Install oh_my_zsh
   sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# 2. Install zinit
   sh -c "$(curl -fsSL https://raw.githubusercontent.com/zdharma-continuum/zinit/HEAD/scripts/install.sh)"
```

## Installing on a new machine
- Clone the repository to ~/.dotfiles folder
- Ignore the repo to avoid tracking itself
- Define an alias named `dotfiles` which will work substitute `git` command
- Don't show untracked files in `dotfiles status`
- Backup the existing files to `.dotfiles-backup` folder and replace them with newer ones.
- Checkout the actual content from your .dotfiles repository to $HOME

```bash


   git clone --bare git@github.com:imamrb/dotfiles.git $HOME/.dotfiles

   alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
   dotfiles config --local status.showUntrackedFiles no
   mkdir -p .dotfiles-backup && \
   dotfiles checkout 2>&1 | egrep "\s+\." | awk {'print $1'} | \
   xargs -I{} mv {} .dotfiles-backup/{}
   dotfiles checkout

```

For Details Explanation of these commands, checkout this blog [here](https://www.ackama.com/blog/posts/the-best-way-to-store-your-dotfiles-a-bare-git-repository-explained).

## Thanks to

- https://github.com/mathiasbynens/dotfiles
- https://github.com/holman/dotfiles
- https://github.com/paulirish/dotfiles
- https://github.com/skwp/dotfiles
- https://github.com/donnemartin/dev-setup
- https://github.com/thoughtbot/dotfiles
- https://github.com/webpro/awesome-dotfiles
- https://github.com/zdharma/zinit-configs
