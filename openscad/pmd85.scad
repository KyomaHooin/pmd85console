//
// Retro PMD-85 console printable 3D case.
//

include <fc.scad>;
include <rpi.scad>;

drawCaseBottom=1;
drawCaseTop=0;
drawPi=0;
drawKeyboard=0;
drawAll=0;

//--------------------------------------

$fn=50;

bottomThick=2;
bottomX=65;
bottomY=56;
bottomMountHeight=2;
bottomMountDia=5.5;
bottomHeight=10;

topThick=bottomThick;
topX=65;
topY=56;
topBackHeight=15;
topFrontHeight=10;
topRom=20;

angle = atan(1/9);
function angle_coord(x,a,thick) = (245-x)/9 + thick * tan(a)/sin(a);

//--------------------------------------

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

module top_poly(x,y,h1,h2,rom) {
    minkowski(){
        polyhedron(
            points= [
                [0,0,0], //0
                [x,0,0], //1
                [x,y,0], //2
                [0,y,0], //3
                [0,0,h1], //4
                [x,0,h1], //5
                [x,rom,h1], //6
                [x,y,h2], //7
                [0,y,h2], //8
                [0,rom,h1] //9
            ],
            faces = [
                [0,1,2,3], //bottom
                [4,5,1,0], //back
                [5,6,7,2,1], // left
                [7,8,3,2], // front
                [8,9,4,0,3], // right
                [4,9,6,5], // top-A
                [9,8,7,6] // top-B
            ]
        );
        sphere(2);
    }
}
module top_base() {
   difference() {
   top_poly(topX,topY,topBackHeight,topFrontHeight,topRom);// BASE
   translate([2,2,0])top_poly(topX-4,topY-4,topBackHeight-2,topFrontHeight-2,topRom-2);// FILL
   translate([-2,-2,-3])cube([topX+4,topY+4,3]);// CUT
   }
}

module key_poly(x1,y1,x2,y2,h) {
        polyhedron(
            points= [
                [0,0,0], //0
                [x1,0,0], //1
                [x1,y1,0], //2
                [0,y1,0], //3
                [(x1-x2)/2,(y1-y2)/2,h], //4
                [x2+(x1-x2)/2,(y1-y2)/2,h], //5
                [x2+(x1-x2)/2,y2+(y1-y2)/2,h], //6
                [(x1-x2)/2,y2+(y1-y2)/2,h], //7
            ],
            faces = [
                [0,1,2,3], //bottom
                [4,5,1,0], //back
                [5,6,2,1], // left
                [6,7,3,2], // front
                [7,4,0,3], // right
                [7,6,5,4], // top
            ]
        );
}

//KBD
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

//KBD slab
module kbd_slab() {
    minkowski() {
    union() {
        cube([49,14,1]);//key base 51x21cm
        translate([30/2,14,0]) cube([19,5,1]);//spacebar base 21x6mm
    }
    cylinder(r=1);
    }
}

module vent_slab() {
    hull() {
        translate([0.5,0.5,0])cylinder(r=0.5);
        translate([49.5,0.5,0])cylinder(r=0.5);
    }
}

module vent_slab_short() {
    hull() {
        translate([0.5,0.5,0])cylinder(r=0.5);
        translate([14.5,0.5,0])cylinder(r=0.5);
    }
}

module vent_slab_big() {
    translate([0.5,0.5,0])
    minkowski() {
        cube([14,4,1]);
        cylinder(r=0.5);
    }
}

module clip_hole() {
    resize([1,4,3])
        rotate([90,0,180]) cylinder(d=1,h=4);
}

module case_top() {
//    color("grey")
    difference() {
    top_base();
    //KBD SLAB
    translate([(topX-50)/2+0.5,40+25+0.25,angle_coord(40+25+0.25,angle,1)])// calculate coord
        rotate([-angle,0,0])// angle
            translate([0,-30,0]) kbd_slab();// move to negative
    //VENT SLAB SLIDE
    translate([(topX-50)/2,27,angle_coord(27,angle,1)])// calculate coord
        rotate([-angle,0,0])// angle
            translate([0,-1,0]) vent_slab();
    translate([(topX-50)/2,30,angle_coord(30,angle,1)])// calculate coord
        rotate([-angle,0,0])// angle
            translate([0,-2,0]) vent_slab();
    translate([(topX-50)/2,32,angle_coord(32,angle,1)])// calculate coord
        rotate([-angle,0,0])// angle
            translate([0,-2,0]) vent_slab();
    // VENT SLAB TOP
    translate([(topX-50)/2,15,topBackHeight+1]) vent_slab_short();
    translate([(topX-50)/2,12,topBackHeight+1]) vent_slab_short();
    translate([(topX-50)/2,9,topBackHeight+1]) vent_slab_short();
    translate([(topX-50)/2,6,topBackHeight+1]) vent_slab_short();
    translate([(topX-50)/2,3,topBackHeight+1]) vent_slab_short();
    translate([(topX-50)/2+15+(50-30-15)/2,9,topBackHeight+1]) vent_slab_short();
    translate([(topX-50)/2+15+(50-30-15)/2,12,topBackHeight+1]) vent_slab_short();
    translate([(topX-50)/2+15+(50-30-15)/2,15,topBackHeight+1]) vent_slab_short();
    translate([(topX-50)/2 + 50-15,15,topBackHeight+1]) vent_slab_short();
    translate([(topX-50)/2 + 50-15,12,topBackHeight+1]) vent_slab_short();
    translate([(topX-50)/2 + 50-15,9,topBackHeight+1]) vent_slab_short();
    translate([(topX-50)/2 + 50-15,6,topBackHeight+1]) vent_slab_short();
    translate([(topX-50)/2 + 50-15,3,topBackHeight+1]) vent_slab_short();
    translate([(topX-50)/2 +15+(50-30-15)/2,2,topBackHeight+1]) vent_slab_big();
    //LED HOLE
    translate([13,60,20]) cylinder(d=3.5,h=4);
    translate([6,60,20]) cylinder(d=3.5,h=4);
    //CLIP HOLE
    translate([0,10,3]) clip_hole();
    translate([0,topY-10-4,3]) clip_hole();
    translate([topX,10,3]) clip_hole();
    translate([topX,topY-10-4,3]) clip_hole();
    //RPI
    translate([0,0,-6])rpi(edge=2);
    }
    //KBD
    //color("black")
    //translate([(topX-50)/2,40,angle_coord(40,angle,1)]) rotate([-angle,0,0])keyboard();
}

module clip() {
    translate([0,0,6.5])
        resize([0.8,3,3]) rotate([90,0,180]) cylinder(d=1,h=3);// 0.8 smaller clip
    translate([0,0,2])cube([2,3,6]);
    polyhedron(
        points = [
            [0,0,0],//0
            [0,3,0],//1
            [0,0,2],//2
            [2,0,2],//3
            [2,3,2],//4
            [0,3,2] //5
    ],
        faces = [
            [3,4,1,0],
            [5,1,4],
            [2,0,1,5],
            [2,3,0],
            [2,5,4,3]
    ]
    );
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
    %translate([0,0,bottomHeight]) case_top();
}
//