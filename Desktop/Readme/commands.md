apt-mark showmanual = To show manually installed apps
apt list --manual-installed | grep -F \[installed\] : 
to get a list of packages that resulted from user commands and their dependencies only,

# Tlp stat
sudo tlp-stat -s -c -b 

# Google accounts gnome workaround
WEBKIT_DISABLE_COMPOSITING_MODE=1 gnome-control-center

# Show drivers
lspci -v | less

# Change Default Terminal
sudo update-alternatives --config x-terminal-emulator

# Shortcuts
```
Ctrl + `= focus terminal in vscode 
Ctrl + 1 =  focus editor in vscode

```
# see repository list
sudo nano /etc/apt/sources.list

# see key list 
sudo apt-key list
sudo apt-key del 73C62A1B

# Run pgAdmin4
source bin/activate
python lib/python3.8/site-packages/pgadmin4/pgAdmin4.py

lsof -wni tcp:3000
kill -9 PID

# RabbitMQ
systemctl is-enabled rabbitmq-server.service 
sudo systemctl enable rabbitmq-server

localhost:15672
imam07
abcdqrty

## Git 

Delete all remote branches which are not in remote 
get fetch --prune

Delete all local branches except master
git branch | grep -v "master" | xargs git branch -D