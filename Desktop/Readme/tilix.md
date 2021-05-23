Adding An Alias: The Better Way
The steps to adding aliases for oh-my-zsh is as easy as reading the instructions embedded in the docs provided. But, if you’re like me and they weren’t immediately clear, here are the five steps you’ll need:

Go to the folder $ cd ~/.oh-my-zsh/custom
Create a new .zsh file. You can name it what ever you’d like, but for testing, I created aliases.zsh
Add you new aliases to your new file. You can do this by opening the file with your preferred text editor. Here’s what mine looked like
#An alias to naviage up one directory level
alias up='cd ..'
Save and quit the editor
Restart your terminal or use $ source ~/.zshrc
Voila! Your new custom aliases will now be available!