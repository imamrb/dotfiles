# Imam's Dotfiles

## Installing
1. Clone the repository to ~/.dotfiles folder

   `git clone --bare git@github.com:Santho07/dotfiles.git $HOME/.dotfiles`
 
2. Ignore the repo to avoid tracking itself

   `echo ".dotfiles" >> .gitignore`

3. Define an alias named `dotfiles` which will work substitute `git` command

   `alias dotfiles='/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME'`

4. Don't show untracked files in `dotfiles status`

   `dotfiles config --local status.showUntrackedFiles no`

5. Checkout the actual content from your .dotfiles repository to $HOME
   
   `dotfiles checkout`

For Details Explanation and workthrough managing dotfiles using git bare repository, checkout this blogs

- https://www.ackama.com/blog/posts/the-best-way-to-store-your-dotfiles-a-bare-git-repository-explained
- https://www.atlassian.com/git/tutorials/dotfiles
