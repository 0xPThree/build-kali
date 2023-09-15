#!/bin/bash

# This script is intended to be run on a clean Kali install
# It installs and configures a number of additional tools, and changes a few useful settings
# Note that some versions are hard-coded in this script and needs to be changed when updating

Red='\e[31m'
Green='\e[32m'
Yellow='\e[33m'
Blue='\e[34m'
NOCOLOR="\e[0m"

# Exit directly if something exit with none zero exit code (exit-on-error)
set -e

# Make sure script isn't run as root
if [[ $EUID -eq 0 ]];
then
    echo -e "${Red}Script running with root privileges, re-run as standard user.${NOCOLOR}"
    exit
fi

echo -e "${Red}
  __ )         _)  |      |       ___|              _)         |   
  __ \   |   |  |  |   _' |     \___ \    __|   __|  |  __ \   __| 
  |   |  |   |  |  |  (   |           |  (     |     |  |   |  |   
 ____/  \__,_| _| _| \__,_|     _____/  \___| _|    _|  .__/  \__| 
                                                       _|          
${NOCOLOR}"

echo -e "Root privileges required to update and install some packages."
sudo -v

######################################################################
# FUNCTIONS
## Help function for count statistics
func_count() {
	PACKAGE_COUNT=$(<$1 wc -l)
	PACKAGES=$(cat $1)
	count=1
}

## Install packages with apt-get, pip3 and go
func_install() {
	func_count $1
	for content in $PACKAGES; 
	do 
		printf "${Green} $count/$PACKAGE_COUNT\t> $content ${NOCOLOR}\n"
		if [ $2 == "apt-get" ]; then
			sudo DEBIAN_FRONTEND=noninteractive apt-get install -qq $content >/dev/null
		elif [ $2 == "pip3" ]; then
			pip3 install --quiet $content >/dev/null
		elif [ $2 == "go" ]; then
			go install $content >/dev/null
		elif [ $2 == "nim" ]; then
			nimble install -y $content >/dev/null
		else 
			printf "${Red}[!] Something went wrong when trying to install.${NOCOLOR}\n"
		fi
		let count=count+1
	done
}

## Download packages with git clone
func_git-clone() {
	func_count $1
	for content in $PACKAGES;
	do
		printf "${Green} $count/$PACKAGE_COUNT\t> $content ${NOCOLOR}\n"
		dir_name=$(echo $content | awk -F/ '{print tolower($NF)}')
		git clone --quiet $content ~/tools/$dir_name >/dev/null
		let count=count+1
	done
}

## Create python3 virtual environment
func_wget() {
	func_count $1
	for content in $PACKAGES;
	do
		printf "${Green} $count/$PACKAGE_COUNT\t> $content ${NOCOLOR}\n"
		wget -qq $content -P ~/tools/
		let count=count+1
	done
}

## Create python3 virtual environment
func_create_venv() {
	printf "${Green}  ?/?\t> $2 ${NOCOLOR}\n"
	cd $1
	python3 -m venv venv
	source venv/bin/activate
	if [[ -f "requirements.txt" ]]; then
		pip3 install -r requirements.txt
	fi
	if [[ -f "setup.py" ]]; then
		pip3 install .
	fi
	deactivate
	cd
}
: '
######################################################################
# UPDATE MACHINE
printf  "\n${Yellow}[i] Update/Upgrade Host: $(echo $(hostname && uname -r)) ${NOCOLOR}\n" 
sudo DEBIAN_FRONTEND=noninteractive apt-get update >/dev/null
sudo DEBIAN_FRONTEND=noninteractive apt-get upgrade -y 2>&1 >/dev/null
printf "${Green}[\xE2\x9C\x94] Host updated successfully ${NOCOLOR}\n\n" 

######################################################################
# INSTALL PACKAGES

printf "${Yellow}[i] Installing Packages ${NOCOLOR}\n"

# APT-GET
printf "${Blue} (apt-get) ${NOCOLOR}\n"
func_install packages/apt_packages.txt apt-get

# Extend sudo session (15 min default timeout)
sudo -v

# PIP3
printf "${Blue} (pip3) ${NOCOLOR}\n"
func_install packages/pip3_packages.txt pip3
export PATH=$HOME/.local/bin:$PATH

# GO
printf "${Blue} (go) ${NOCOLOR}\n"
func_install packages/go_packages.txt go
export GOROOT=/usr/lib/go
export GOPATH=$HOME/go
export PATH=$GOPATH/bin:$GOROOT/bin:$PATH

# NIM
printf "${Blue} (nim) ${NOCOLOR}\n"
func_install packages/nim_packages.txt nim
echo "export PATH=$HOME/.nimble/bin:$PATH" >> ~/.bashrc
export PATH=$HOME/.nimble/bin:$PATH

printf "${Green}[\xE2\x9C\x94] Packages installed successfully ${NOCOLOR}\n\n" 

######################################################################
# GIT
echo -ne "${Yellow}[i] Cloning Git Repositories ${NOCOLOR}\n"
mkdir -p ~/tools
func_git-clone packages/git_repos.txt
printf "${Green}[\xE2\x9C\x94] Repositories cloned successfully ${NOCOLOR}\n\n" 

######################################################################
# WGET / CURL
echo -ne "${Yellow}[i] Downloading Additional Scripts and Applications ${NOCOLOR}\n"
func_wget packages/wget_urls.txt

printf "${Green}[\xE2\x9C\x94] Scripts and applications downloaded successfully ${NOCOLOR}\n\n" 

# Extend sudo session (15 min default timeout)
sudo -v

######################################################################
# BURPSUITE PRO
echo -ne "${Yellow}[i] Installing Burp Suite Pro ${NOCOLOR}\n"
wget -qq --show-progress "https://portswigger.net/burp/releases/download?product=pro&version=2023.9.4&type=Linux" -O ~/tools/burppro.sh
chmod u+x ~/tools/burppro.sh
~/tools/burppro.sh -q
wget -qq --show-progress "https://repo1.maven.org/maven2/org/python/jython-standalone/2.7.3/jython-standalone-2.7.3.jar" -O ~/BurpSuitePro/jython-standalone-2.7.3.jar
printf "${Green}[\xE2\x9C\x94] Burp Suite Pro installed successfully ${NOCOLOR}\n\n" 
'
######################################################################
# CREATE PYTHON3 VENV
: ' # Removed venv/poetry section as its very time consuming and resource heavy. Suggest to do this manually if needed.

echo -ne "${Yellow}[i] Creating Virtual Environments - Venv & Poetry ${NOCOLOR}\n"
printf "${Green} 1/4\t> prepparing tools requirements.txt for venv ${NOCOLOR}\n"
echo "impacket" >> ~/tools/finduncommonshares/requirements.txt
echo "impacket" >> ~/tools/lsa-reaper/requirements.txt

printf "${Green} 2/4\t> creating venvs ${NOCOLOR}\n"
func_create_venv ~/tools/adexplorersnapshot.py.git adexplorersnapshot
func_create_venv ~/tools/adidnsdump adidnsdump
func_create_venv ~/tools/apachetomcatscanner apachetomcatscanner
func_create_venv ~/tools/arsenal.git arsenal
func_create_venv ~/tools/bloodyad.git bloodyad
func_create_venv ~/tools/coercer coercer
func_create_venv ~/tools/cve-2020-1472.git zerologon
func_create_venv ~/tools/finduncommonshares finduncommonshares
func_create_venv ~/tools/ldaprelayscan.git ldaprelayscan
#func_create_venv ~/tools/lsa-reaper lsa-reaper								# Requirement error
func_create_venv ~/tools/lsassy lsassy
func_create_venv ~/tools/minidump.git minidump
func_create_venv ~/tools/mitm6.git mitm6
func_create_venv ~/tools/pkinittools pkinittools
func_create_venv ~/tools/pywerview.git pywerview
func_create_venv ~/tools/pywhisker.git pywhisker
func_create_venv ~/tools/rubeustoccache.git rubeustoccache
#func_create_venv ~/tools/sccmhunter.git sccmhunter							# Suuuuuuuuper slow to complete
func_create_venv ~/tools/seeyoucm-thief.git seeyoucm-thief
func_create_venv ~/tools/vcenter_saml_login.git vcenter_saml_login
func_create_venv ~/tools/vortex.git vortex

# Latest Crackmapexec
printf "${Green} 3/4\t> creating poetry environment for crackmapexec ${NOCOLOR}\n"
cd ~/tools/crackmapexec
poetry install
poetry run crackmapexec

# DonPAPI
printf "${Green} 3/4\t> creating poetry environment for donpapi ${NOCOLOR}\n"
cd ~/tools/donpapi.git
poetry update
poetry install
poetry run DonPAPI

printf "${Green}[\xE2\x9C\x94] Virtual environments created successfully ${NOCOLOR}\n\n" 

######################################################################
# LOOK AND FEEL
echo -ne "${Yellow}[i] Customizing Environment ${NOCOLOR}\n"
printf "${Blue} (apt-get) ${NOCOLOR}\n"
func_install dots/apt_packages.txt apt-get
printf "${Green} [\xE2\x9C\x94] copying wallpapers to ~/Pictures/wallpapers/  ${NOCOLOR}\n"
mkdir ~/Pictures/wallpapers
cp -R dots/wallpapers ~/Pictures/wallpapers
'
printf "${Green} [\xE2\x9C\x94] copying dots ${NOCOLOR}\n"
cp -R dots/dunst ~/.config/
cp -R dots/i3 ~/.config/
cp -R dots/i3status ~/.config/
cp -R dots/polybar ~/.config/
cp -R dots/rofi ~/.config/
cp -R dots/compton.conf ~/.config/
cp -R dots/terminator ~/.config/
sh -c "$(wget -qq https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O - &)" >/dev/null &
sleep 5
cp -R dots/oh-my-zsh/common.zsh-theme ~/.oh-my-zsh/custom/themes/
cp -R dots/oh-my-zsh/zshrc ~/.zshrc

printf "${Green} [\xE2\x9C\x94] configuring polybar  ${NOCOLOR}\n"
sudo mv ~/.config/polybar/config.ini /etc/polybar/config.ini
sudo ln -s /etc/polybar/config.ini ~/.config/polybar/config.ini

printf "${Green}[\xE2\x9C\x94] Customization completed successfully ${NOCOLOR}\n\n" 

######################################################################
# END
printf "\n${Green}[\xE2\x9C\x94] All done! Reboot your computer and change window manager to i3. ${NOCOLOR}\n"
printf "${Red}[!] Don't forget to install Burp Plugins and License. ${NOCOLOR}\n\n"
zsh
