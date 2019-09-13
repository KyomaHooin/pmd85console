![PMD](https://github.com/kyomahooin/pmd85console/raw/master/pmd85.png "pmd85")

DESCRIPTION

Raspberry Pi 1A+ Tesla PMD-85 retro cosole powered by modified Petr Tuma <a href="https://github.com/ceresek/simpmd">simpmd</a> (c) 2008.

TODO

<pre>
-game menu + tape select + exit + [esc]
-bootloader
-splash boot + splash shutdown
-LED
-3D printable case -
-Polish + Sticker
-Paper Box
</pre>

BUG

<pre>
-snd flood alsa lib pcm.c:(snd_pcm_recover) underrun occured
-mesa loader: failed to retrieve device information
</pre>

HARDWARE

<pre>
1x <a href="http://rpishop.cz/248-raspberry-pi-1a">Raspberry</a>(1A+)
1x <a href="https://www.ges.cz/cz/usb-napajec-napajeci-adapter-mw-5v-1-2a-sun-usb-GES07507424.html">Power adapter</a>(5V 1.2A)
1x <a href="https://www.mironet.cz/edimax-wireless-nano-usb-20-adapter-80211n-150mbps-sw-wps+dp117994/">USB Wifi dongle</a>(RTL8188CUS/50-75mA)
1x <a href="https://www.czc.cz/gembird-cablexpert-kabel-hdmi-hdmi-0-5m-1-4-m-m-stineny-zlacene-kontakty-cerna/248060/produkt">HDMI cable</a>(0.5m)
1x <a href="https://www.aliexpress.com/item/New-High-Quality-USB-To-TTL-Serial-Module-FTDI-FT232RL-USB-3-3V-5V-To-TTL/32971767031.html">USB FTDI TTL/UART</a>(3.3V 6-pin)
1x MicroSD(2GB)
1x Keyboard(Chicony KU-0108s/100mA)
1x <a href="https://www.ges.cz/cz/l-934gd-GES10700054.html">Green LED</a>(10mA 2.2V)
1x <a href="https://www.ges.cz/cz/l-934id-GES10701762.html">Red LED</a>(10mA 2V)
1x <a href="https://www.ges.cz/cz/rm0207-120r-1-GES05300318.html">Rezistor 120R</a>
1x <a href="https://www.ges.cz/cz/rm0207-150r-1-GES05300319.html">Rezistor 150R</a>
</pre>

SOFTWARE

<pre>
Fake KMS driver + Dispmanx
SDL 2.0.x + SDL2_ttf
simpmd
</pre>

RPI

<pre>
wget --no-check-certificate https://downloads.raspberrypi.org/raspbian_lite_latest
umount /dev/sd[12] 2>/dev/null
unzip -p 2018-11-13-raspbian-stretch-lite.zip | dd of=/dev/sda bs=4M

touch /boot/ssh
cat << EOF >> /boot/wpa_supplicant.conf
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

3.3V UART => | x | x | GND | TX | RX | ..

minicom -D /dev/ttyUSB0 -b 115200

[ctrl] > [A] > [Z] > [O] > Serial port setup > [F]low control > Off  

raspi-config > Advanced > GL Driver > Enable Fake KMS

apt-get update
apt-get install libgl1-mesa-dri

raspi-config > Advanced > GPU mem > 128
raspi-config > Advanced > Overclocking > Medium

sytemctl disable [avahi-daemon|bluetooth|dhcpcd|paxctld|rsync|triggerhappy|nfs-client.target|systemd-timesyncd]

apt-get install vim mc git ntpdate plymouth-themes

#cp -r theme/* /usr/share/plymouth/themes/
#plymouth-set-default-theme pmd85
#/boot/cmdline.txt:
#logo.nologo quiet loglevel=3 plymouth.ignore-serial-console plymouth.enable=0 splash 

/etc/fstab:

tmpfs	/tmp	tmpfs	defaults,noatime,nosuid,size=5m	0	0
tmpfs	/var/log	tmpfs	defaults,noatime,nosuid,mode=0755,size=5m	0	0

/etc/rc.local:

# NTP
/usr/sbin/ntpdate -b -4 tik.cesnet.cz > /dev/null 2>&1 &
# Firewall
/root/firewall &
#
/root/simpmd/bin/run > /var/log/pmd.log && halt &

# PWR LED GPIO 32 / ACT LED GPIO 36
#echo 'pwr_led_gpio=12'>> /boot/config.txt
#echo 'act_led_gpio=16' >> /boot/config.txt

</pre>

SDL2

<pre>
wget --no-check-certificate https://www.libsdl.org/release/SDL2-2.0.9.tar.gz

apt-get install libgles2-mesa-dev libgbm-dev libudev-dev libasound2-dev liblzma-dev

autogen.sh
./configure --enable-video-kmsdrm --disable-video-opengl --disable-video-x11 --disable-video-rpi
make
make install

wget --no-check-certificate https://www.libsdl.org/projects/SDL_ttf/release/SDL2_ttf-2.0.15.tar.gz
autogen.sh
./configure
make
make install
</pre>

SIMPMD

<pre>
make clean
make
</pre>

FILES

<pre>
pmd85.png - Original 1985 computer.    

openscad/ - 3D printable retro case.
  simpmd/ - Modified SDL2 PMD-85 emulator source code by Petr Tuma (c) 2008.
   theme/ - Splash Plymouth theme.
</pre>

SOURCE

https://github.com/KyomaHooin/pmd85console

