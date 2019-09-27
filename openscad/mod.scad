//
// PMD-85 retro console mods
//

module rounded_rect(x, y, z, radius) {
    linear_extrude(height=z)
        minkowski() {
            square([x,y]);
            circle(r = radius);
        }
}

module bottom_mount(offsetX,offsetY,Thick) {
    difference() {
        translate([offsetX, offsetY, Thick]) cylinder(h=bottomMountHeight, d=bottomMountDia);
        translate([offsetX, offsetY, Thick-1]) cylinder(h=bottomMountHeight+2, d=2);
    }
}

//module usb_lip() {
//    translate([1, bottomThick/2, 1])
//        rotate([90,0,0])
//            rounded_rect(usbWidth, usbHeight, bottomThick/2, 1);
//}

//module micro_lip() {
//    translate([bottomThick/2, 1, 1])
//        rotate([0,270,0])
//            rounded_rect(microHeight+1, microLength, bottomThick/2, 1);
//}

module sd_lip() {
    rotate([90,0,90])
        rounded_rect(cardWidth, bottomThick+bottomMountHeight, bottomThick+1, 1);
}

module lip_lock_bottom() {
    difference() {
        rounded_rect(bottomX, bottomY, 1, bottomThick);
        rounded_rect(bottomX, bottomY, 1, bottomThick/2-0.125);
    }
}

module lip_lock_top() {
    rounded_rect(bottomX+1, bottomY+1, 1, bottomThick/2+0.125);// bug
}

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

//KBD slab
module kbd_slab() { //56x26
    minkowski() {
    union() {
        cube([54,14,1]);//key base 56x16cm
        translate([30/2,14,0]) cube([24,5,1]);//spacebar base 26x6mm
    }
    cylinder(r=1);
    }
}

module vent_slab() {// 55x1
    hull() {
        translate([0,0,0])cylinder(r=0.5);
        translate([55,0,0])cylinder(r=0.5);
    }
}

module vent_slab_short() {
    hull() {
        translate([0.5,0.5,0])cylinder(r=0.5);
        translate([17,0.5,0])cylinder(r=0.5);
    }
}

module vent_slab_big() {
    translate([0.5,0.5,0])
    minkowski() {
        cube([16,4,1]);
        cylinder(r=0.5);
    }
}

module clip_hole() {
    resize([1,4,3])
        rotate([90,0,180]) cylinder(d=1,h=4);
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
