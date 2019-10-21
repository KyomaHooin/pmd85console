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

//--------------------------------------

bottomThick=2;
bottomX=piX+1;
bottomY=piY+1;
bottomMountHeight=1.75;
bottomMountDia=4.4;
bottomHeight=bottomThick+bottomMountHeight+piThick+microHeight-0.5;

//--------------------------------------

topThick=bottomThick;
topX=piX+1;
topY=piY+1;
topBackHeight=25-bottomHeight;
topFrontHeight=20-bottomHeight;;
topRom=20;

angle = atan(5/37);
function angle_coord(x,a,thick) = -(5*x)/37 + 1025/37 + thick * tan(a)/sin(a);

//------------------------------
//
//KBD
//

module keyboard() {//55x15x2
    minkowski() {
      union() {
        cube([53,13,0.5]);//key base 55x15cm
        translate([30/2,14,0]) cube([23,4,0.5]);//spacebar base 25x5mm
      }
    cylinder(r=1);
    }
    for (fx=[0:10])
        for (fy=[0:2])
            translate([-0.5+fx*5,-0.5+fy*5,1]) key_poly(4,4,3,3,2); // key 4x4mm
    translate([30/2-0.5,0.5+14,1])key_poly(24,4,23,3,2); // spacebar 24x4mm
}

//------------------------------
//
// TOP
//

module case_top() {
//    color("grey")
    union() {
    difference() {
    top_base();
    //RPI
    translate([0.5,0.5,-piThick-microHeight+0.5])rpi(edge=2);
    //KBD SLAB
    translate([(topX-55)/2+0.5,34.5,angle_coord(34.5,angle,-7.25)])
        rotate([-angle,0,0]) kbd_slab();
    //VENT SLAB SLIDE
    translate([(topX-55)/2,30,angle_coord(30,angle,-7.1)]) rotate([-angle,0,0]) vent_slab();
    translate([(topX-55)/2,27,angle_coord(27,angle,-7.1)]) rotate([-angle,0,0]) vent_slab();
    translate([(topX-55)/2,24,angle_coord(24,angle,-7.1)]) rotate([-angle,0,0]) vent_slab();
    //VENT SLAB TOP
    translate([(topX-56)/2,15.5,topBackHeight+1.25]) vent_slab_short();
    translate([(topX-56)/2,12.5,topBackHeight+1.25]) vent_slab_short();
    translate([(topX-56)/2,9.5,topBackHeight+1.25]) vent_slab_short();
    translate([(topX-56)/2,6.5,topBackHeight+1.25]) vent_slab_short();
    translate([(topX-56)/2,3.5,topBackHeight+1.25]) vent_slab_short();
    translate([(topX-56)/2+15+(54-30-15.5)/2,9.5,topBackHeight+1.25]) vent_slab_short();
    translate([(topX-56)/2+15+(54-30-15.5)/2,12.5,topBackHeight+1.25]) vent_slab_short();
    translate([(topX-56)/2+15+(54-30-15.5)/2,15.5,topBackHeight+1.25]) vent_slab_short();
    translate([(topX-56)/2 + 54-15.5,15.5,topBackHeight+1.25]) vent_slab_short();
    translate([(topX-56)/2 + 54-15.5,12.5,topBackHeight+1.25]) vent_slab_short();
    translate([(topX-56)/2 + 54-15.5,9.5,topBackHeight+1.25]) vent_slab_short();
    translate([(topX-56)/2 + 54-15.5,6.5,topBackHeight+1.25]) vent_slab_short();
    translate([(topX-56)/2 + 54-15.5,3.5,topBackHeight+1.25]) vent_slab_short();
    translate([(topX-56)/2 +15+(54-30-15.5)/2,3.5,topBackHeight+1.25]) vent_slab_big();
    //LED HOLE
    translate([15,53,10]) cylinder(d=3.5,h=10);
    translate([8.5,53,10]) cylinder(d=3.5,h=10);
    // USB LIP
    translate([topX+1.25,piY-usbY-usbWidth+1,-microHeight+0.5+0.5]) usb_lip();
    //LIP LOCK
    top_lip_lock();
    }
    // CLIP
    translate([0-0.1,topY/4-5,-2.5])clip_front();
    translate([0-0.1,topY-topY/4,-2.5])clip_front();
    translate([topX-2+0.1,topY/4-5,-2.5])clip_back();
    translate([topX-2+0.1,topY-topY/4,-2.5])clip_back();
    }
    //KBD
    //color("grey")
    //translate([(topX-53)/2,35,angle_coord(35,angle,-8)]) rotate([-angle,0,0]) keyboard();
}

//------------------------------
//
// BOTTOM
//

module case_bottom() {
    difference() {
        //BASE
        bottom_base();
        //VENT
        for (vspace=[1:4])
            translate([piX/4,vspace*piY/6+5,-1]) bottom_vent();
        //SD LIP
        translate([-bottomThick-1,(bottomY-cardWidth)/2,0]) sd_lip();
        //RPI
        translate([0.5,0.5,bottomThick+bottomMountHeight]) rpi(edge=2);
        //CLIP HOLE
        translate([-1+0.5,bottomY/4-5.5,bottomHeight-2.5])clip_hole_front();
        translate([-1+0.5,bottomY-bottomY/4-0.5,bottomHeight-2.5])clip_hole_front();
        translate([bottomX,bottomY/4-5.5,bottomHeight-2.5])clip_hole_back();
        translate([bottomX,bottomY-bottomY/4-0.5,bottomHeight-2.5])clip_hole_back();
        // USB LIP
        translate([bottomX+0.75,piY-usbY-usbWidth+1,bottomThick+bottomMountHeight+piThick+0.5]) usb_lip();
        //LIP LOCK
        translate([0,0,bottomHeight]) bottom_lip_lock();
        translate([0.5,-microWidth/2,bottomHeight-microHeight/2])// MiroUSB fix
            translate([microX, -microOverHang, piThick-0.5])
                cube([microLength, microWidth, microHeight+1]);
    }
    // BOTTOM MOUNT
    bottom_mount(piHoleOffset+0.5, piHoleOffset+0.5, bottomThick);
    bottom_mount(bottomX-piHoleOffset-0.5,piHoleOffset+0.5, bottomThick);
    bottom_mount(piHoleOffset+0.5, bottomY-piHoleOffset-0.5, bottomThick);
    bottom_mount(bottomX-piHoleOffset-0.5, bottomY-piHoleOffset-0.5, bottomThick);
}

//------------------------------
//
// DISPLAY
//

if (drawCaseTop) { case_top(); }
if (drawCaseBottom) { case_bottom(); }
if (drawPi) { rpi(); }

if (drawKeyboard) {
    difference() {
        translate([0,0,-1])keyboard();
        translate([-2,-2,-2]) cube([58,22,2]);
    }
}

if (drawAll) {
    case_bottom();
    translate([0.5,0.5,bottomThick+bottomMountHeight]) rpi();
    translate([0,0,bottomHeight]) case_top();
}
