//
// Retro PMD-85 console printable 3D case.
//

include <mod.scad>;
include <rpi.scad>;

drawCaseBottom=0;
drawCaseTop=0;
drawPi=0;
drawKeyboard=0;
drawAll=1;

//--------------------------------------

$fn=50;

bottomThick=2;
bottomX=65;
bottomY=56;
bottomMountHeight=1.75;
bottomMountDia=4.4;
bottomHeight=bottomThick+bottomMountHeight+piThick+microHeight/2;

topThick=bottomThick;
topX=65;
topY=56;
topBackHeight=25-bottomHeight;
topFrontHeight=20-bottomHeight;
topRom=20;

angle = atan(5/36);
function angle_coord(x,a,thick) = -(5*x)/36 + 250/9 + thick * tan(a)/sin(a);

//------------------------------
//
//KBD
//

module keyboard() {
    translate([0,0,-1])
    difference() {
    union(){
    minkowski() {
    union() {
        translate([1,1,0])cube([48,13,0.5]);//key base 50x15cm
        translate([30/2+1,14,0]) cube([18,5,0.5]);//spacebar base 20x5mm
    }
    cylinder(r=1);
    }
    for (fx=[0:9])
        for (fy=[0:2])
            translate([0.5+fx*5,0.5+fy*5,0.5]) key_poly(4,4,3,3,2); // key 4x4mm
    translate([30/2+0.5,15+0.5,0.5])key_poly(19,4,18,3,2); // spacebar 19x4mm
    }
    translate([-1,-1,0]) cube([55,25,1]);
    }
}

//------------------------------
//
// TOP
//

module case_top() {
//    color("grey")
    difference() {
    top_base();
    //KBD SLAB
    translate([(topX-50)/2+0.5,40+24+0.25,angle_coord(40+24+0.25,angle,-9)])// calculate coord
        rotate([-angle,0,0])// angle
            translate([0,-30,0]) kbd_slab();// move to negative
    //VENT SLAB SLIDE
    translate([(topX-50)/2,26,angle_coord(26,angle,-8.9)])// calculate coord
        rotate([-angle,0,0])// angle
            translate([0,-1,0]) vent_slab();
    translate([(topX-50)/2,29,angle_coord(29,angle,-8.9)])// calculate coord
        rotate([-angle,0,0])// angle
            translate([0,-2,0]) vent_slab();
    translate([(topX-50)/2,31,angle_coord(31,angle,-8.9)])// calculate coord
        rotate([-angle,0,0])// angle
            translate([0,-2,0]) vent_slab();
    // VENT SLAB TOP
    translate([(topX-50)/2,15.5,topBackHeight+1]) vent_slab_short();
    translate([(topX-50)/2,12.5,topBackHeight+1]) vent_slab_short();
    translate([(topX-50)/2,9.5,topBackHeight+1]) vent_slab_short();
    translate([(topX-50)/2,6.5,topBackHeight+1]) vent_slab_short();
    translate([(topX-50)/2,3.5,topBackHeight+1]) vent_slab_short();
    translate([(topX-50)/2+15+(50-30-15)/2,9.5,topBackHeight+1]) vent_slab_short();
    translate([(topX-50)/2+15+(50-30-15)/2,12.5,topBackHeight+1]) vent_slab_short();
    translate([(topX-50)/2+15+(50-30-15)/2,15.5,topBackHeight+1]) vent_slab_short();
    translate([(topX-50)/2 + 50-15,15.5,topBackHeight+1]) vent_slab_short();
    translate([(topX-50)/2 + 50-15,12.5,topBackHeight+1]) vent_slab_short();
    translate([(topX-50)/2 + 50-15,9.5,topBackHeight+1]) vent_slab_short();
    translate([(topX-50)/2 + 50-15,6.5,topBackHeight+1]) vent_slab_short();
    translate([(topX-50)/2 + 50-15,3.5,topBackHeight+1]) vent_slab_short();
    translate([(topX-50)/2 +15+(50-30-15)/2,2.5,topBackHeight+1]) vent_slab_big();
    //LED HOLE
    translate([16,52.5,10]) cylinder(d=3.5,h=4);
    translate([9    ,52.5,10]) cylinder(d=3.5,h=4);
    //CLIP HOLE
    translate([0,10,3]) clip_hole();
    translate([0,topY-10-4,3]) clip_hole();
    translate([topX,10,3]) clip_hole();
    translate([topX,topY-10-4,3]) clip_hole();
    //RPI
    translate([0,0,-piThick-microHeight/2])rpi(edge=2);
    }
    //KBD
    //color("black")
    //translate([(topX-50)/2,40,angle_coord(40,angle,1)]) rotate([-angle,0,0])keyboard();
}

//------------------------------
//
// BOTTOM
//

module case_bottom() {
    difference() {
        translate([0,0,0]) rounded_rect(bottomX, bottomY, bottomHeight, bottomThick);// BASE
        translate([0,0,bottomThick]) cube([bottomX, bottomY, bottomHeight]); // FILLER
        translate([0,0,bottomThick+bottomMountHeight]) rpi(edge=2);// RPI
        //bottom_hole();// BOTTOM HOLE
        for (vspace=[1:4])// VENT
            translate([piX/4-2, 10*vspace+2.5, -1]) rounded_rect(bottomX/2+4, 1, bottomThick+2, 1);
        //translate([cardX, -bottomThick, bottomThick+bottomMountHeight]) sd_lip();// SD LIP
        //translate([usbX-1,bottomY+bottomThick/2,bottomThick+bottomMountHeight+piThick-1]) usb_lip();// USB LIP
        //translate([bottomX+bottomThick/2,microY-1,bottomThick+bottomMountHeight+piThick-1])// MICRO LIP
        //    micro_lip();
        //translate([0,0,bottomHeight-1]) lip_lock_bottom();// LIPLOCK
    }
    bottom_mount(piHoleOffset, piHoleOffset, bottomThick);// BOTTOM MOUNT
    bottom_mount(bottomX-piHoleOffset,piHoleOffset, bottomThick);
    bottom_mount(piHoleOffset, bottomY-piHoleOffset, bottomThick);
    bottom_mount(bottomX-piHoleOffset, bottomY-piHoleOffset, bottomThick);
}

//------------------------------

if (drawCaseTop) {
     translate([topThick,topThick,0]) case_top();
}

if (drawCaseBottom) {
    translate([bottomThick, bottomThick, 0]) case_bottom();
}

if (drawPi) {
    rpi();
}

if (drawKeyboard) {
    keyboard();
}

if (drawAll) {
    translate([0,0,0]) case_bottom();
    translate([0,0,bottomThick+bottomMountHeight]) rpi();
    //%translate([0,0,bottomHeight]) case_top();
}
//