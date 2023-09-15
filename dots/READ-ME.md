## Install packages
sudo apt update
sudo apt upgrade -y
sudo apt install -y dunst i3 terminator polybar rofi compton hsetroot

- Move images from wallpapers to ~/Pictures/
cp -R ~/build/dots/wallpapers ~/Pictures/wallpapers
cp -R ~/build/dots/dunst ~/.config/
cp -R ~/build/dots/i3 ~/.config/
cp -R ~/build/dots/i3status ~/.config/
cp -R ~/build/dots/polybar ~/.config/
cp -R ~/build/dots/rofi ~/.config/
cp -R ~/build/dots/compton.conf ~/.config/
sudo mv ~/.config/polybar/config.ini /etc/polybar/config.ini
sudo ln -s /etc/polybar/config.ini ~/.config/polybar/config.ini