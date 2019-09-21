![SCHEMA](https://github.com/kyomahooin/pmd85console/raw/master/schema.png "schema")

DESCRIPTION

Raspberry Pi 1A+ Tesla PMD-85 retro cosole powered by modified Petr Tuma <a href="https://github.com/ceresek/simpmd">simpmd</a> (c) 2008.

TODO

<pre>
-emulator:
  -sim_menu.c
  -tape select:
   -do not assign outside main/fc
    const std::string game[2] = {"foo","bar"};
    foo.clear();
    foo.push_back(game[0]);

-boot:
  -splash boot/shutdown image
  -loader
  -log
  -RF Kill delay fix
-LED
-3D case:
  -clip lock
  -AV cylinder
  -Netfabb
  -polishing
  -sticker
-Paper Box:
  -Tesla sticker
-Heatsink
</pre>

BUG

<pre>
-snd flood alsa lib pcm.c:(snd_pcm_recover) underrun occured
-mesa loader: failed to retrieve device information
</pre>

HARDWARE

<pre>
1x <a target="_blank" href="http://rpishop.cz/248-raspberry-pi-1a">Raspberry</a>(1A+)
1x <a target="_blank" href="https://www.ges.cz/cz/usb-napajec-napajeci-adapter-mw-5v-1-2a-sun-usb-GES07507424.html">Power adapter</a>(5V 1.2A)
1x <a target="_blank" href="https://www.mironet.cz/edimax-wireless-nano-usb-20-adapter-80211n-150mbps-sw-wps+dp117994/">USB Wifi dongle</a>(RTL8188CUS/50-75mA)
1x <a target="_blank" href="https://www.czc.cz/gembird-cablexpert-kabel-hdmi-hdmi-0-5m-1-4-m-m-stineny-zlacene-kontakty-cerna/248060/produkt">HDMI cable</a>(0.5m)
1x <a target="_blank" href="https://www.aliexpress.com/item/New-High-Quality-USB-To-TTL-Serial-Module-FTDI-FT232RL-USB-3-3V-5V-To-TTL/32971767031.html">USB FTDI TTL/UART</a>(3.3V 6-pin)
1x MicroSD(2GB)
1x Keyboard(Chicony KU-0108s/100mA)

1x <a target="_blank" href="https://www.ges.cz/cz/l-934gd-GES10700054.html">Green LED</a>(10mA 2.2V)
1x <a target="_blank" href="https://www.ges.cz/cz/l-934id-GES10701762.html">Red LED</a>(10mA 2V)
1x <a target="_blank" href="https://www.ges.cz/cz/rm0207-120r-1-GES05300318.html">Rezistor 120R</a>
1x <a target="_blank" href="https://www.ges.cz/cz/rm0207-150r-1-GES05300319.html">Rezistor 150R</a>
2x <a target="_blank" href="https://www.ges.cz/cz/bls-02-GES06614037.html">BLS 02</a>
4x <a target="_blank" href="https://www.ges.cz/cz/bls-contacts-GES06614047.html">BLS contact</a>
1x <a target="_blank" href="https://www.ges.cz/cz/tas-c130-0-GES13004464.html">Copper wire</a>(0.22mm 1m)
4x <a target="_blank" href="https://www.ges.cz/cz/esst-m2-2x6-GES06814889.html">Screw</a>(M2.2x6mm)
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

raspi-config > Advanced > GL Driver > Enable Fake KMS

apt-get update
apt-get install libgl1-mesa-dri

raspi-config > Advanced > GPU mem > 128
raspi-config > Advanced > Overclocking > Medium

sytemctl disable [avahi-daemon|bluetooth|dhcpcd|paxctld|rsync|triggerhappy|nfs-client.target|systemd-timesyncd|apt-daily|apt-daily-upgrade]

apt-get install vim mc ntpdate

/etc/fstab:

tmpfs	/tmp	tmpfs	defaults,noatime,nosuid,size=5m	0	0
tmpfs	/var/log	tmpfs	defaults,noatime,nosuid,mode=0755,size=5m	0	0

/etc/rc.local:

# NTP
/usr/sbin/ntpdate -b -4 tik.cesnet.cz > /dev/null 2>&1 &
# Firewall
/root/firewall &
# PMD-85
/root/simpmd/bin/run > /var/log/pmd.log && halt &

/etc/dhcpcd.conf:

interface wlan0
static ip_address=192.168.0.x85/24
static routers=192.168.0.1
static domain_name_servers=xx.xx.xx.xx xx.xx.xx.xx
</pre>

UART

<pre>
3.3V UART => | x | x | GND | TX | RX | ..

minicom -D /dev/ttyUSB0 -b 115200

[ctrl] > [A] > [Z] > [O] > Serial port setup > [F]low control > Off  
</pre>

LED

<pre>
            [>>]
             || -- GND
GPIO -- R -- | 

# ACT/PWR LED GPIO 32/36(BCM)
echo 'dtparam=act_led_gpio=32' >> /boot/config.txt
echo 'dtparam=pwr_led_gpio=36' >> /boot/config.txt
</pre>

PLYMOUTH

<pre>
apt-get install plymouth plymouth-themes

systemctl enable plymouth

cp -r theme-pmd85 /usr/share/plymouth/themes/

plymouth-set-default-theme -l

echo 'export FRAMEBUFFER=/dev/fb0' > /etc/initramfs-tools/conf.d/fb0

plymouth-set-default-theme -R theme-pmd85

/usr/share/plymouth/plymouthd.defaults:
Theme=theme-pmd85

/boot/cmdline.txt:
console=tty2 logo.nologo quiet splash plymouth.ignore-serial-consoles vt.global_cursor_default=0
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
       schema.png - Retro console schamatic.    
atari-classic.ttf - TTF font by Mark Simonson (c) 2016.

        openscad/ - 3D printable retro case.
          simpmd/ - Modified SDL2 PMD-85 emulator source code by Petr Tuma (c) 2008.
     theme-pmd85/ - Splash Plymouth theme.
</pre>

SOURCE

https://github.com/KyomaHooin/pmd85console

