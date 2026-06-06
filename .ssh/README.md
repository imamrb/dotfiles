Multiple SSH Keys Settings for Different Github Accounts
=================================================================


Create Different Private and Public Key
-------------------------------------------

Create two different ssh key with work account and personal account email

```bash
    ssh-keygen -t rsc -C "work@company.com" -P '' -f 'id_rsa_work' # Work account
	ssh-keygen -t rsa -C "personal@example.com" -P '' -f 'id_rsa_personal'
```
2 keys created at:

```bash
	~/.ssh/id_rsa_work
	~/.ssh/id_rsa_personal
```
Then add keys ( Optional )

```bash
	ssh-add -D # Delete all cached keys first
	ssh-add ~/.ssh/id_rsa_work
	ssh-add ~/.ssh/id_rsa_personal

```

Finally, check saved keys

	ssh-add -l


Modify the SSH config
-------------------------------------------

```bash
	cd ~/.ssh/
	touch config
	subl -a config

```

Then add

```bash
	# Work account (work@company.com), - the default config
	Host github.com
	   HostName ssh.github.com
	   User git
	   Port 443
	   IdentityFile ~/.ssh/id_rsa_work
	   
	# Personal Account (personal@example.com)
	Host github.com-personal
	   HostName ssh.github.com
	   User git
	   Port 443
	   IdentityFile ~/.ssh/id_rsa_personal

```

Connect with Github
-------------------------------------------

	1. Copy the public key `pbcopy < ~/.ssh/id_rsa_personal.pub` and then log in to your personal GitHub account:
	2. Go to Settings
	3. Select SSH and GPG keys from the menu to the left.
	4. Click on New SSH key, provide a suitable title, and paste the key in the box below
	5. Click Add key — and you’re done!
	6. Repeat for work account

Test

```bash

ssh -T git@github.com
# You've successfully authenticated, but GitHub does not provide shell access.

ssh -T git@github.com-personal
# You've successfully authenticated, but GitHub does not provide shell access.

```

Clone Repo and Modify Git config
--------------------------------------------

Identity is handled automatically by `includeIf` in `.gitconfig`:

- **Work repos** cloned under `~/Work/` → auto-loads `~/.gitconfig-work` (work name/email/signingkey)
- **Personal repos** anywhere else → auto-loads `~/.gitconfig-local` (personal signingkey)

No need to manually `git config --local user.name` after each clone.

```bash
# Work account — clone into ~/Work/ (identity from ~/.gitconfig-work)
mkdir -p ~/Work
git clone git@github.com:company/<repo_name> ~/Work/<repo_name>

# Personal account — clone anywhere else (identity from ~/.gitconfig-local)
git clone git@github.com-personal:username/<repo_name>
```

See `.gitconfig` for the `includeIf` rules.

Then use normal flow to push code

```bash
	git add .
	git commit -m ":tada: Initial Commit"
	git push
```