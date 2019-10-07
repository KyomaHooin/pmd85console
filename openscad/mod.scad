//
// PMD-85 retro console mods
//

module bottom_hull(x,y,z) {
    hull() {
        cylinder(r=2,h=z);
        translate([x,0,0]) cylinder(r=2,h=z);
        translate([x,y,0]) cylinder(r=2,h=z);
        translate([0,y,0]) cylinder(r=2,h=z);
    }
}

module bottom_base() {
    difference() {
            bottom_hull(bottomX,bottomY,bottomHeight+1);// +1 = lip lock cut
            translate([bottomThick,bottomThick,bottomThick]) bottom_hull(bottomX-4,bottomY-4,bottomHeight+1);// +1 = lip lock cut
        }
    }

module bottom_lip_lock() {
    difference() {
        bottom_hull(bottomX,bottomY,1);
        translate([1.25,1.25,-1]) bottom_hull(bottomX-2.25,bottomY-2.25,3);
    }
}

module top_lip_lock() {
        translate([0.75,0.75,0]) bottom_hull(bottomX-1.5,bottomY-1.5,1);
}

module bottom_vent() {
    hull() {
        cylinder(r=1,h=2*bottomThick);
        translate([bottomX/2,0,0]) cylinder(r=1,h=2*bottomThick);
    }
}

module bottom_mount(offsetX,offsetY,Thick) {
    difference() {
        translate([offsetX, offsetY, Thick]) cylinder(h=bottomMountHeight, d=bottomMountDia);
        translate([offsetX, offsetY, Thick-1]) cylinder(h=bottomMountHeight+2, d=2);
    }
}

module sd_lip() {
    translate([0,0,cardHeight+bottomThick])
    rotate([0,90,0])
    hull() {
      cylinder(r=1,h=3);
      translate([0,cardWidth,0]) cylinder(r=1,h=3);
      translate([0,-1,0])cube([cardHeight+bottomThick,cardWidth+2,3]);
    }
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
        cube([16,3,1]);
        cylinder(r=0.5);
    }
}

module clip_hole() {// 1x5x4
    polyhedron(
        points = [
            [1,0,0],//0
            [1,7,0],//1
            [0+0.5,0,3],//2
            [0+0.5,7,3],//3
            [1,0,4],//4
            [1,7,4] //5
    ],
        faces = [
            [3,2,0,1],
            [3,1,5],
            [4,5,1,0],
            [2,4,0],
            [4,2,3,5]
    ]
    );
}

module clip() {
    union() {
    translate([0,0,3])cube([2,5,8]);
    polyhedron(
        points = [
            [0,0,0],//0
            [0,5,0],//1
            [0,0,3],//2
            [2,0,3],//3
            [2,5,3],//4
            [0,5,3] //5
    ],
        faces = [
            [2,3,0],
            [3,4,1,0],
            [5,1,4],
            [2,0,1,5],
            [2,5,4,3]
    ]
    );
    translate([-1,0,7])
    polyhedron(
        points = [
            [1,0,0],//0
            [1,5,0],//1
            [0+0.5,0,1],//2
            [0+0.5,5,1],//3
            [1,0,4],//4
            [1,5,4] //5
    ],
        faces = [
            [4,0,2],
            [4,5,1,0],
            [3,1,5],
            [4,2,3,5],
            [2,0,1,3]
    ]
    );
    }
}

module clip_back() {
    translate([2,0,10])
    rotate([0,180,0]) clip();
}

module clip_front() {
    translate([0,5,10])
        rotate([0,180,180]) clip();
}

module clip_hole_front() {
   translate([0-0.5,0,0])clip_hole();
}

module clip_hole_back() {
    translate([1,5,0])
        rotate([0,0,180]) clip_hole();
}
