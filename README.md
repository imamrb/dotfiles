# @Imam Dotfiles

Yet another dotfiles repository customized for my needs.


This is a git bare repository. To install on a new machine, the steps are as follows...

## Installing on a new machine

```bash
# 1. Clone the repository to ~/.dotfiles folder

   git clone --bare git@github.com:Santho07/dotfiles.git $HOME/.dotfiles
 
# 2. Ignore the repo to avoid tracking itself

   echo ".dotfiles" >> .gitignore

# 3. Define an alias named `dotfiles` which will work substitute `git` command

   alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'

# 4. Don't show untracked files in `dotfiles status`

   dotfiles config --local status.showUntrackedFiles no

# 5. Set the flag showUntrackedFiles to no on this specific (local) repository
   
   config config --local status.showUntrackedFiles no


# 6. Backup the existing files to `.dotfiles-backup` folder and replace them with newer ones.

   mkdir -p .dotfiles-backup && \
   dotfiles checkout 2>&1 | egrep "\s+\." | awk {'print $1'} | \
   xargs -I{} mv {} .dotfiles-backup/{}

# 7. Checkout the actual content from your .dotfiles repository to $HOME
   
   dotfiles checkout

```

For Details Explanation and workthrough managing dotfiles using git bare repository, checkout this blogs

- https://www.ackama.com/blog/posts/the-best-way-to-store-your-dotfiles-a-bare-git-repository-explained
- https://www.atlassian.com/git/tutorials/dotfiles

## Thanks to

- https://github.com/mathiasbynens/dotfiles
- https://github.com/holman/dotfiles
- https://github.com/thoughtbot/dotfiles
- https://github.com/webpro/awesome-dotfiles
- https://github.com/zdharma/zinit-configs