//
// Retro PMD-85 console printable 3D case.
//

$fn=50;

piX=56;
piY=65;
piThick=1.27;
piHoleDia=2.75;
piShieldLength=65;
piHoleOffset=3.5;

usbWidth=13.16+1;
usbLength=17.05;
usbHeight=9.1-piThick+1;
usbX=17.6;
usbOverHang=1.84;

avWidth=7.20+1;
avLength=15;
avHeight=7.47-piThick+1;
avOverHang=2.44;
avY=53.5-avWidth/2;

hdmiWidth=11.47;
hdmiLength=15.04+1;
hdmiHeight=7.86-piThick+1;
hdmiOverHang=1.59;
hdmiY=32-(hdmiLength/2);

microWidth=5.59;
microLength=8.04+1;
microHeight=4.22-piThick;
microOverHang=1.9;
microY=10.6-(microLength/2);

cardWidth=13.04;
cardLength=17.18;
cardHeight=1.0;
cardOverHang=2.63;
cardX=piX/2-cardWidth/2;

gpioWidth=2.54*2;
gpioLength=20*2.54;
gpioHeight=6.10+2.5;
gpioX=1.05;// ?
gpioY=piHoleOffset+29-gpioLength/2;

module pi_hole() {
    cylinder(h=piThick+2, d=piHoleDia);
}

module rpi(edgeCut=0) {
    color("seagreen")
    difference() {
        cube([piX, piY, piThick]);
        translate([piHoleOffset, piHoleOffset, -1]) pi_hole();
        translate([piX-piHoleOffset, piHoleOffset, -1]) pi_hole();
        translate([piHoleOffset, piShieldLength-piHoleOffset, -1]) pi_hole();
        translate([piX-piHoleOffset, piShieldLength-piHoleOffset, -1]) pi_hole();
    }
    color("Silver") {
        // USB
        translate([usbX, piY-usbLength+usbOverHang+edgeCut, piThick-0.5])
            cube([usbWidth, usbLength, usbHeight]);
        // HDMI
        translate([piX-hdmiWidth+hdmiOverHang+edgeCut, hdmiY-0.5, piThick-0.5])
            cube([hdmiWidth, hdmiLength, hdmiHeight]);
        // AV
        translate([piX-avLength+avOverHang+edgeCut, avY-0.5, piThick-0.5])
            cube([avLength, avWidth, avHeight]);
        // microUSB
        translate([piX-microWidth+microOverHang+edgeCut, microY-0.5, piThick-0.5])
            cube([microWidth, microLength, microHeight+1]);
        // microSD
        translate([cardX, -cardOverHang-edgeCut, -cardHeight])
            cube([cardWidth, cardLength,cardHeight]);
    }
    // GPIO Headers
    color("black") {
        translate([gpioX, gpioY, piThick])
            cube([gpioWidth, gpioLength, gpioHeight]);
    }
}

rpi();