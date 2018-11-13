
DESCRIPTION

Raspberry Pi 1A+ Tesla PMD-85 retro-cosole.

TODO

<pre>
-flashload
-cursor fix
-border + inner border fix
-progress / run ico drop
-multithread dispmanx(Amiberry)
-snd flood alsa lib pcm.c:(snd_pcm_recover) underrun occured
-menu delay fix(issues)
-mesa loader: failed to retrieve device information
-CPU govenor tune(?)
-Amiberry path = bcm_init.h + dispmanx thread
-bcm_host_init() + bcm_host_deinit()
-RetrpPie tune(?)
-glxgears/glestest.c test
-SDL "utility libs"(?)
-Default config
-3D case
</pre>

HARDWARE

<pre>
1x <a href="http://rpishop.cz/248-raspberry-pi-1a">Raspberry</a>(1A+)
1x <a href="https://www.ges.cz/cz/usb-napajec-napajeci-adapter-mw-5v-1-2a-sun-usb-GES07507424.html">Power adapter</a>(5V 1.2A)
1x <a href="https://www.mironet.cz/edimax-wireless-nano-usb-20-adapter-80211n-150mbps-sw-wps+dp117994/">USB Wifi dongle</a>(RTL8188CUS)
1x <a href="https://www.czc.cz/gembird-cablexpert-kabel-hdmi-hdmi-0-5m-1-4-m-m-stineny-zlacene-kontakty-cerna/248060/produkt">HDMI cable</a>(0.5m)
1x MicroSD(2G)
1x Keyboard(Chicony KU-0108 100mA)
</pre>

SOFTWARE REQUIREMENT

<pre>
Fake KMS driver => GLES2.0 + Dispmanx
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

        [3.3V UART!]
 ___ ___ _____ ____ ____ ___
| x | x | GND | TX | RX | ..
|___|___|__6__|_8__|_10_|___
| x | x |  x  | x  | x  | ..
|___|___|_____|____|____|___


minicom -D /dev/ttyUSB0 -b 115200

[ctrl]+[A] > [Z] > 'o' > Serial port setup > Hardware flow-control > No  

raspi-config > Advanced > GL Driver > Enable Fake KMS

lsmod

apt-get install libgl1-mesa-dri

raspi-config > Advanced > GPU mem > 128
raspi-config > Advanced > Overclocking > Medium

sytemctl disable [avahi-daemon|bluetooth|dhcpcd|paxctld|plymouth|rsync|triggerhappy|nfs-client.target|rc-local|systemd-timesyncd]

apt-get update
apt-get install vim git
</pre>

SDL

<pre>

wget --no-check-certificate https://www.libsdl.org/release/SDL2-2.0.9.tar.gz

apt-get install libfreetype6-dev libgles2-mesa-dev libgbm-dev libudev-dev libasound2-dev liblzma-dev

autogen.sh <- (?)
./configure --enable-video-kmsdrm --disable-video-opengl --disable-video-x11 --disable-video-rpi
make -j4
make install

FPS: 25 CPU: 45-50

glestest.c

glestest.cpp => gcc `sdl-config --flags --libs` -lbcm_host -L/opt/vc/lib
</pre>

GPMD

<pre>
apt-get istall (build-essential|libtool|autoconf|autotools-dev|pkg-config)

bcm_host_init() => make LIBS='-lbcm_host' LDFLAGS='-L/opt/vc/lib'
debug => ./configure --enable-trace

autoreconf -vfi
./configure --enable-trace
make
make install

function `[f]` keys are any of Alt, Win, Mac or Meta keys
main menu appear with `[f]+F1` or with the "menu key"
for start/stop of tape emulator use `[f]+P` hotkey
</pre>

FILES

<pre>
emulator/ - Modified PMD85 emulator source code by Martin Bórik & Roman Bórik.
    game/ - Game binaries by VBG Software.
</pre>

SOURCE

https://github.com/KyomaHooin/GPMD85Emulator

