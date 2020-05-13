#!/bin/bash
CURRENT_USER=$1
export CURRENT_USER=$1

# read user git details
read -p 'git username: ' git_username
read -p 'git useremail: ' git_useremail

# updating cores
apt update
apt upgrade -y
snap refresh

# install additional things 
apt install ubuntu-restricted-extras -y
apt install apt-transport-https curl

# git and config
apt install git -y
git config --global user.name "${git_username}"
git config --global user.email "${git_useremail}"
echo -e "\033[43m \033[30m you need to add gpg and ssh key manually. \033[0m"

# programming stuff
apt install gcc g++ -y
apt install vim -y
apt install python3-pip -y
curl -sL https://deb.nodesource.com/setup_12.x | sudo -E bash -
sudo apt-get install -y nodejs

# proxy stuff
apt install privoxy -y
mv /etc/privoxy/config /etc/privoxy/config.bak
cp -v ./configs/privoxy/config /etc/privoxy/config
service privoxy start
apt install python-m2crypto
pip3 install shadowsocks
apt install proxychains
mv /etc/proxychains.conf /etc/proxychains.conf.bak
cp ./configs/proxychains/proxychains.conf /etc/proxychains.conf
mv /etc/apt/apt.conf.d/proxy.conf /etc/apt/apt.conf.d/proxy.conf.bak
cp -v ./configs/apt/proxy.conf /etc/apt/apt.conf.d/proxy.conf

# installing vscode
snap install code --classic
sh ./configs/vscode/extensions.sh 
mv /home/$CURRENT_USER/.config/Code/User/settings.json /home/$CURRENT_USER/.config/Code/User/settings.json.bak
cp -v ./configs/vscode/settings.json /home/$CURRENT_USER/.config/Code/User/settings.json

# installing browsers
snap install brave
snap install chromium

apt install unzip

# installig zsh with hack font
apt install zsh -y
chsh -s $(which zsh)
curl -o /tmp/fonts/x-hack.tar.gz https://github.com/source-foundry/Hack/releases/download/v3.003/Hack-v3.003-ttf.tar.gz
tar -xzf /tmp/fonts/x-hack.tar.gz 
mkdir /home/$CURRENT_USER/.fonts
mv /tmp/fonts/hack* /home/$CURRENT_USER/.fonts/ 
fc-cache -f -v
git clone https://github.com/denysdovhan/spaceship-prompt.git "$ZSH_CUSTOM/themes/spaceship-prompt"
ln -s "$ZSH_CUSTOM/themes/spaceship-prompt/spaceship.zsh-theme" "$ZSH_CUSTOM/themes/spaceship.zsh-theme"
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git /home/$CURRENT_USER/zsh-syntax-highlighting
mv /home/$CURRENT_USER/.zshrc /home/$CURRENT_USER/.zshrc.bak
cp ./configs/zsh/zshrc /home/$CURRENT_USER/.zshrc 

# installing player
snap install --beta mpv 

# installing tweak
apt install gnome-tweak-tool -y 
# TODO: install extenstions

# installing social medias
snap install telegram-desktop --classic
snap install rambox
snap install discord

# installing android studio
snap install android-studio --classic

echo -e "\033[43m \033[30m Make sure your proxy in on and is set to 1080 to install docker. \033[0m"
read -p 'did you turn your proxy on(y/n): ' proxy_is_on
while [ proxy_is_on -ne "y" && proxy_is_on -ne 'Y' ]; do
    echo -e "\033[43m \033[30m Make sure your proxy in on and is set to 1080 to install docker. \033[0m"
    read -p 'did you turn your proxy on(y/n): ' proxy_is_on
done

# installing docker
apt remove docker docker-engine docker.io containerd runc -y
apt install apt-transport-https ca-certificates curl gnupg-agent software-properties-common -y
sudo -u $CURRENT_USER curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
apt update
apt install docker-ce docker-ce-cli containerd.io
usermod -aG docker $CURRENT_USER

# installing variety
add-apt-repository ppa:peterlevi/ppa -y
apt install variety -y



apt autoclean
apt autoclear

echo -e "\033[43m \033[30m for affective and make zsh your permanent shell reboot your system. \033[0m"

# lastly oh-my-zsh 
sudo -u $CURRENT_USER sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

echo -e "\033[43m \033[30m for affective and make zsh your permanent shell reboot your system. \033[0m"