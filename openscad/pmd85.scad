//
// Retro PMD-85 console printable 3D case.
//

//include <fc.scad>;
include <rpi1Aplus.scad>;

drawCaseBottom=1;
drawCaseTop=0;
drawPi=0;
drawAll=0;

$fn=50;

//------------------------------

//CASE BOTTOM

bottomThick=2;
bottomX=56;
bottomY=85;
bottomMountHeight=2.26;
bottomMountDia=5.5;
bottomHeight=bottomThick+bottomMountHeight+piThick+microHeight/2;

module case_bottom() {
    difference() {
        translate([-0.5,-0.5,0]) rounded_rect(bottomX+1, bottomY+1, bottomHeight+1, bottomThick);// BASE
        translate([-0.5,-0.5,bottomThick]) cube([bottomX+1, bottomY+1, bottomHeight]); // FILLER
        translate([0,0,bottomThick+bottomMountHeight]) rpi(edgeCut=3);// RPI
        bottom_hole();// BOTTOM HOLE
        for (vspace=[1:7])// VENT
            translate([piX/4, 10*vspace+2.5, -1]) rounded_rect(bottomX/2, 1, bottomThick+2, 1);
        translate([cardX, -bottomThick-0.5, bottomThick+bottomMountHeight]) sd_lip();// SD LIP
        translate([usb2X-1,bottomY+bottomThick/2+0.5,bottomThick+bottomMountHeight+piThick-0.5]) usb_lip();// USB LIP
        translate([usb1X-1,bottomY+bottomThick/2+0.5,bottomThick+bottomMountHeight+piThick-0.5]) usb_lip();
        translate([bottomX+bottomThick/2+0.5,microY-1-0.5,bottomThick+bottomMountHeight+piThick-0.5])// MICRO LIP
            micro_lip();
        translate([-0.5,-0.5,bottomHeight]) lip_lock_bottom();// LIPLOCK
    }
    bottom_mount(piHoleOffset, piHoleOffset, bottomThick);// BOTTOM MOUNT
    bottom_mount(piX-piHoleOffset,piHoleOffset, bottomThick);
    bottom_mount(piHoleOffset, shieldY-piHoleOffset, bottomThick);
    bottom_mount(piX-piHoleOffset, shieldY-piHoleOffset, bottomThick);
}

//------------------------------

//if (drawCaseTop) {
//    translate([topX+topThick+0.5, topThick+0.5, topHeight])
//        rotate([0,180,0]) case_top();
//}

if (drawPi) {
    translate([bottomThick + 0.5, bottomThick + 0.5, bottomHeight]) rpi();
}

if (drawCaseBottom) {
    translate([topThick+0.5, topThick+0.5, 0]) case_bottom();
}

if (drawAll) {
    translate([0,0,0]) case_bottom();
    translate([0,0,bottomThick+bottomMountHeight]) rpi();
    translate([0,0,bottomHeight+1]) case_top();
}
