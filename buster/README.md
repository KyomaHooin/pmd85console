Install Raspbian using Noobs (https://www.raspberrypi.org/downloads/noobs/)
<pre>
# do these steps on a Linux system with an SD card inserted into a card reader
# all data on the card will be erased thus make sure you have a backup!
# at least 8GB SD card is recommended

# get the latest raspbian lite
wget https://downloads.raspberrypi.org/raspbian_lite_latest

# check target device (sd card) and set target variable accordingly
lsblk | grep ^sd
target=sdXY
sudo umount /dev/${target}*
unzip -p raspbian_lite_latest | pv | sudo dd of=/dev/${target} bs=4M
sudo mount /dev/${target}1 /mnt
sudo touch /mnt/ssh
# configure wifi if wired ethernet is not present
cat << EOF >> /mnt/wpa_supplicant.conf
country=CZ
ctrl_interface=DIR=/var/run/wpa_supplicant GROUP=netdev
update_config=1
network={
ssid="Wireless LAN"
scan_ssid=1
psk="cleartext"
key_mgmt=WPA-PSK
}
EOF
sudo umount /mnt
# remove the card from the reader, put into Raspi and boot from it
</pre>
Recompile SDL2 with KMS support
<pre>
# log in to raspberry pi (user: pi, password: raspberry) via SSH
# and change default password
passwd

sudo vi /etc/apt/sources.list
# uncomment deb-src in /etc/apt/sources.list

# do system update
sudo apt-get update
sudo apt-get upgrade
# install packages necessary to rebuild SDL with KMS enabled
sudo apt-get install devscripts build-essential libgbm-dev libgl1-mesa-dri git
sudo apt-get build-dep libsdl2

# install vim, mc and ntpdate (optional)
apt-get install vim mc ntpdate

# pull libsdl2 sources and rebuild
apt-get source libsdl2
cd libsdl2*/
sed -i '/enable-video-wayland/s/$/ --enable-video-kmsdrm --disable-video-opengl --disable-video-x11 --disable-video-rpi/' debian/rules
debuild -- clean
debuild -us -uc

# install KMS-enabled libsdl2
sudo dpkg -i ../libsdl2*.deb
sudo apt-mark hold sdl2-2.0.0 libsdl2-doc
</pre>
Performance tuning
<pre>
# disable swap
dphys-swapfile swapoff
dphys-swapfile uninstall

# turn-off unnecessary services
systemctl disable avahi-daemon bluetooth paxctld rsync triggerhappy triggerhappy.socket nfs-client.target \
                  systemd-timesyncd apt-daily apt-daily.timer apt-daily-upgrade apt-daily-upgrade.timer \
                  dphys-swapfile rc-local wifi-country keyboard-setup systemd-rfkill getty@tty1 exim4

# in case you have a chance to use UART for debugging, disable networking for faster boot
systemctl disable networking dhcpcd ssh systemd-timesyncd wpa_supplicant
</pre>
Additional configuration
<pre>
# Enable fake KMS
sudo raspi-config # > Advanced > GL Driver > Enable Fake KMS

# Change memory split and overclock
sudo raspi-config # > Advanced > GPU mem > 128
sudo raspi-config # > Overclocking > Medium

# use /tmp and /var/log as in-memory filesystems
echo "
tmpfs    /tmp      tmpfs    defaults,noatime,nosuid,size=5m            0  0
tmpfs    /var/log  tmpfs    defaults,noatime,nosuid,mode=0755,size=5m  0  0
" | sudo tee -a /etc/fstab

# reboot
</pre>
Compile and install simpmd
<pre>
# clone pmd85console project
git clone https://github.com/KyomaHooin/pmd85console.git

# compile modified simpmd
cd pmd85console/simpmd
# install dependencies
sudo apt install libghc-sdl2-ttf-dev
make PMD_BUILD=RELEASE PMD_SHARE=/usr/share/simpmd/

sudo cp bin/mem2raw bin/ptp2raw bin/rawinfo bin/simpmd /usr/bin
sudo install -dm755 /usr/share/simpmd
sudo cp data/roms/M* /usr/share/simpmd
sudo cp data/font/atari-classic.ttf /usr/share/simpmd
sudo cp data/logo/* /usr/share/simpmd
sudo cp data/tapes/games-pmd1/* /usr/share/simpmd
sudo cp data/tapes/games-pmd2/* /usr/share/simpmd
</pre>
Install Plymouth and customize boot
<pre>
sudo apt-get install plymouth plymouth-themes
sudo cp -r ~/pmd85console/theme-pmd85 /usr/share/plymouth/themes/
sudo plymouth-set-default-theme -R theme-pmd85
sudo sed -i '/DeviceTimeout=/s/.*/DeviceTimeout=10/' /usr/share/plymouth/plymouthd.defaults
sudo sudo systemctl disable plymouth-start
sudo sed -i '1s/$/ logo.nologo quiet splash plymouth.ignore-serial-consoles vt.global_cursor_default=0/' /boot/cmdline.txt
echo "boot_delay=0" | sudo tee -a /boot/config.txt
sudo cp ~/pmd85console/raspberry/pmd85.service /etc/systemd/system
sudo systemctl enable pmd85.service
</pre>
