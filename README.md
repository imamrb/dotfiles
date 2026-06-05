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

## Git Setup

### GPG key (signing commits)

```bash
# Generate a new GPG key (use your name/email, pick RSA 4096)
gpg --full-generate-key

# List keys to get the key ID
gpg --list-secret-keys --keyid-format=long

# Configure git to use it
git config --global user.signingkey <KEY_ID>
git config --global commit.gpgsign true

# Add the public key to GitHub: https://github.com/settings/gpg/keys
gpg --armor --export <KEY_ID> | pbcopy
```

### Per-machine config files

These are **not tracked** in dotfiles — create them on each machine:

**`~/.gitconfig-local`** — machine-specific signing key:

```ini
[user]
	signingkey = <KEY_ID>
```

**`~/.gitconfig-work`** — work identity (optional):

```ini
[user]
	name = Your Name
	email = you@company.com
	signingkey = <WORK_KEY_ID>
```

These are picked up automatically by `includeIf` in the shared `.gitconfig`:

| `includeIf` pattern          | Loads               | Purpose                           |
| ---------------------------- | ------------------- | --------------------------------- |
| `gitdir:~/`                  | `~/.gitconfig-local`  | Default signing key (per-machine) |
| `gitdir:~/Work/`             | `~/.gitconfig-work`  | Work identity                     |

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

   # Backup existing files and checkout dotfiles
   mkdir -p .dotfiles-backup && \
   dotfiles checkout 2>&1 | egrep "\s+\." | awk {'print $1'} | \
   xargs -I{} mv {} .dotfiles-backup/{}
   dotfiles checkout
```

> Note: repo-specific settings (fsmonitor, excludes, showUntrackedFiles) are auto-applied via `includeIf` in `.gitconfig`.

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
