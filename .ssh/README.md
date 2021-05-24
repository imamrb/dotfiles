Multiple SSH Keys Settings for Different Github Accounts
=================================================================


Create Different Private and Public Key
-------------------------------------------

Create two different ssh key with work account and personal account email

```bash
    $ ssh-keygen -t rsc -C "imam.hossain@welldev.io" -P '' -f 'id_rsa' # Work account
	$ ssh-keygen -t rsa -C "imam.swe@gmail.com" -P '' -f 'id_rsa_personal'
```
2 keys created at:

```bash
	~/.ssh/id_rsa
	~/.ssh/id_rsa_personal
```
Then add keys ( Optional )

```bash
	ssh-add -D # Delete all cached keys first
	ssh-add ~/.ssh/id_rsa
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
	# Work account (imam.hossain@welldev.io), - the default config
	Host github.com
	   HostName ssh.github.com
	   User git
	   Port 443
	   IdentityFile ~/.ssh/id_rsa
	   
	# Personal Account ( imam.swe@gmail.com)
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
ssh -T git@github.com-personal

```

Clone Repo and Modify Git config
--------------------------------------------

```bash
	git clone git@github.com-personal:Santho07/<repo_name>
	
	#cd <repo_name> and modify git config
	
	git config --local user.name 'Imam Hossain'
	git config --local user.email 'imam.swe@gmail.com'
 
```
Or, set global git config

```bash
	$ git config --global user.name "Imam Hossain"
	$ git config --global user.email "imam.hossain@welldev.io"
```

Then use normal flow to push code

```bash
	$ git add .
	$ git commit -m ":tada: Initial Commit"
	$ git push
```