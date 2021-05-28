# My Dotfiles

Yet another dotfiles repository customized for my needs.

I have followed [bare git](https://www.saintsjd.com/2011/01/what-is-a-bare-git-repository/) strategy to backup my dotfiles. 
Learn more about it in this blog post: [The best way to store your dotfiles: A bare Git repository](https://www.atlassian.com/git/tutorials/dotfiles) 

Feel free to take the bits and use of your own.

## Prequisite


```bash
# 1. Install oh_my_zsh
   
   sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

# 2. Install zinit

   sh -c "$(curl -fsSL https://raw.githubusercontent.com/zdharma/zinit/master/doc/install.sh)"

# 3. Install fzf
   brew install fzf
   
```

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

# 5. Backup the existing files to `.dotfiles-backup` folder and replace them with newer ones.

   mkdir -p .dotfiles-backup && \
   dotfiles checkout 2>&1 | egrep "\s+\." | awk {'print $1'} | \
   xargs -I{} mv {} .dotfiles-backup/{}

# 6. Checkout the actual content from your .dotfiles repository to $HOME
   
   dotfiles checkout

```

For Details Explanation of these commands, checkout this blog [here](https://www.ackama.com/blog/posts/the-best-way-to-store-your-dotfiles-a-bare-git-repository-explained).


## Thanks to

- https://github.com/mathiasbynens/dotfiles
- https://github.com/holman/dotfiles
- https://github.com/paulirish/dotfiles
- https://github.com/skwp/dotfiles
- https://github.com/thoughtbot/dotfiles
- https://github.com/webpro/awesome-dotfiles
- https://github.com/zdharma/zinit-configs