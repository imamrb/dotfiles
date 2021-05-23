# Imam's Dotfiles

## Installing:
<!-- clone the repository to ~/.dotfiles folder -->
1. git clone --bare git@github.com:Santho07/dotfiles.git $HOME/.dotfiles
<!-- .dotfiles repo can track everything inside $HOME directory. Ignore the repo to avoid tracking itself  -->
2. echo ".dotfiles" >> .gitignore
<!-- define an alias named `dotfiles` which will work substitute `git` command -->
3. alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'
4. dotfiles config --local status.showUntrackedFiles no
<!-- Checkout the actual content from your .dotfiles repository to $HOME. 
Git pulls the tracked files out of the compressed database in the Git directory and places them in the work tree. -->
5. dotfiles checkout

For a detail workthrough of how to track dotfiles using a git bare repo, check this awesome blog https://www.ackama.com/blog/posts/the-best-way-to-store-your-dotfiles-a-bare-git-repository-explained

