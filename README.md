
DESCRIPTION

Raspberry Pi 1A+ Tesla PMD-85 retro cosole.

TODO

<pre>
-2717 + 384 drop
-threaded dispmanx + bcm_host(Amiberry)
-3D case
-Mato dcb_kbd_mato_state() / dcb_blk_rmap_state() (remain mato/consul drop)
-Emulator.cpp 257 bool FullRedrawExpected = true;
-RetrpPie/ libretro tune(?)
-SDL "utility libs"(?)
-CPU govenor tune(?)
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
1x MicroSD(2GB)
1x Keyboard(Chicony KU-0108s/100mA)
</pre>

SOFTWARE

<pre>
Fake KMS driver + Dispmanx
SDL 2.0.x
GPMD85Emulator
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

[ctrl]+[A] > [Z] > 'o' > Serial port setup > Hardware flow-control > No  

raspi-config > Advanced > GL Driver > Enable Fake KMS

apt-get install libgl1-mesa-dri

raspi-config > Advanced > GPU mem > 128
raspi-config > Advanced > Overclocking > Medium

sytemctl disable [avahi-daemon|bluetooth|dhcpcd|paxctld|plymouth|rsync|triggerhappy|nfs-client.target|systemd-timesyncd]

apt-get update
apt-get install vim git ntpdate

/etc/fstab:

tmpfs	/tmp	tmpfs	defaults,noatime,nosuid,size=5m	0	0
tmpfs	/var/log	tmpfs	defaults,noatime,nosuid,mode=0755,size=5m	0	0

/etc/rc.local:

/usr/sbin/ntpdate -b -4 tik.cesnet.cz > /dev/null 2>&1 &
</pre>

SDL

<pre>
wget --no-check-certificate https://www.libsdl.org/release/SDL2-2.0.9.tar.gz

apt-get install libgles2-mesa-dev libgbm-dev libudev-dev libasound2-dev liblzma-dev

autogen.sh
./configure --enable-video-kmsdrm --disable-video-opengl --disable-video-x11 --disable-video-rpi
make
make install

SDL + bcm_host_init() => gcc `sdl-config --cflags --libs` -lbcm_host -L/opt/vc/lib
</pre>

PMD

<pre>
apt-get istall autoconf

autoreconf -vfi
./configure --enable-trace
make
make install

bcm_host_init() => make LIBS='-lbcm_host' LDFLAGS='-L/opt/vc/lib'
</pre>

FILES

<pre>
              emulator/ - Modified PMD85 emulator source code by Martin Bórik & Roman Bórik.
pmd85emu_games_vpbg.zip - Origina VBG games binaries.
</pre>

SOURCE

https://github.com/KyomaHooin/pmd85console

