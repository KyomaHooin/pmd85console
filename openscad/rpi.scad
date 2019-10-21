//
// Retro PMD-85 console printable 3D case.
//

$fn=50;

piX=65;
piY=56;
piThick=1.27;
piHoleDia=2.75;
piHoleOffset=3.5;

usbWidth=13.16+1;
usbLength=17.05+1;
usbHeight=9.1-piThick-0.5;
usbOverHang=1.84;
usbY=17.6;

avWidth=7.20+1;
avLength=15;
avHeight=7.47-piThick+1;
avOverHang=2.44;
avX=53.5-avWidth/2;

hdmiWidth=11.47;
hdmiLength=15.04+1;
hdmiHeight=7.86-piThick+0.5;
hdmiOverHang=1.59;
hdmiX=32-(hdmiLength/2);

microWidth=5.59;
microLength=8.04+1;
microHeight=4.22-piThick+1;
microOverHang=1.9;
microX=10.6-(microLength/2);

cardWidth=13.04+1;
cardLength=17.18;
cardHeight=1.0+1;
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
        hull() {
            translate([2,2,0])cylinder(r=2,h=piThick);
            translate([piX-2,2,0])cylinder(r=2,h=piThick);
            translate([2,piY-2,0])cylinder(r=2,h=piThick);
            translate([piX-2,piY-2,0])cylinder(r=2,h=piThick);
        }
        translate([piHoleOffset, piHoleOffset, -1]) pi_hole();
        translate([piX-piHoleOffset, piHoleOffset, -1]) pi_hole();
        translate([piHoleOffset, piY-piHoleOffset, -1]) pi_hole();
        translate([piX-piHoleOffset, piY-piHoleOffset, -1]) pi_hole();
    }
    color("Silver") {
        // USB
        translate([piX-usbWidth-usbOverHang+edge, piY-usbY-usbWidth+0.5, piThick+0.5])
            cube([usbLength, usbWidth, usbHeight]);
        // HDMI
        translate([hdmiX, -hdmiOverHang-edge, piThick])
            cube([hdmiLength, hdmiWidth, hdmiHeight]);
        // AV
        translate([avX, -avOverHang-edge, piThick-0.5])
            cube([avWidth, avLength, avHeight]);
        // microUSB
        translate([microX, -microOverHang-edge, piThick-0.5])
            cube([microLength, microWidth, microHeight]);
        // microSD
        translate([-cardOverHang-edge, cardY, -cardHeight+0.5])
            cube([cardLength, cardWidth,cardHeight]);
    }
    // GPIO Headers
    color("black") {
        translate([gpioX, gpioY, piThick])
            cube([gpioLength, gpioWidth, gpioHeight]);
    }
}
