//
// Retro PMD-85 console printable 3D case.
//

$fn=50;

piX=65;
piY=56;
piThick=1.27;
piHoleDia=2.75;
piHoleOffset=3.5;

usbWidth=13.16;
usbLength=17.05;
usbHeight=9.1-piThick;
usbOverHang=1.84;
usbY=17.6;

avWidth=7.20;
avLength=15;
avHeight=7.47-piThick;
avOverHang=2.44;
avX=53.5-avWidth/2;

hdmiWidth=11.47;
hdmiLength=15.04;
hdmiHeight=7.86-piThick;
hdmiOverHang=1.59;
hdmiX=32-(hdmiLength/2);

microWidth=5.59;
microLength=8.04;
microHeight=4.22-piThick;
microOverHang=1.9;
microX=10.6-(microLength/2);

cardWidth=13.04;
cardLength=17.18;
cardHeight=1.0;
cardOverHang=2.63;
cardY=piY/2-cardWidth/2;

gpioWidth=2.54*2;
gpioLength=20*2.54;
gpioHeight=6.10+2.5;
gpioX=(piX-gpioLength)/2;
gpioY=piY - gpioWidth -1.05;

module pi_hole() {
    cylinder(h=piThick+2, d=piHoleDia);
}

module rpi(edge=0) {
    color("seagreen")
    difference() {
        cube([piX, piY, piThick]);
        translate([piHoleOffset, piHoleOffset, -1]) pi_hole();
        translate([piX-piHoleOffset, piHoleOffset, -1]) pi_hole();
        translate([piHoleOffset, piY-piHoleOffset, -1]) pi_hole();
        translate([piX-piHoleOffset, piY-piHoleOffset, -1]) pi_hole();
    }
    color("Silver") {
        // USB
        translate([piX-usbWidth-usbOverHang+edge, piY-usbY-usbWidth, piThick])
            cube([usbLength, usbWidth, usbHeight]);
        // HDMI
        translate([hdmiX, -hdmiOverHang-edge, piThick])
            cube([hdmiLength, hdmiWidth, hdmiHeight]);
        // AV
        translate([avX, -avOverHang-edge, piThick])
            cube([avWidth, avLength, avHeight]);
        // microUSB
        translate([microX, -microOverHang-edge, piThick])
            cube([microLength, microWidth, microHeight+1]);
        // microSD
        translate([-cardOverHang-edge, cardY, -cardHeight])
            cube([cardLength, cardWidth,cardHeight]);
    }
    // GPIO Headers
    color("black") {
        translate([gpioX, gpioY, piThick])
            cube([gpioLength, gpioWidth, gpioHeight]);
    }
}

//rpi();
