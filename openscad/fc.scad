//
// RPi Shield - functions
//

module rounded_rect(x, y, z, radius) {
    linear_extrude(height=z)
        minkowski() {
            square([x,y]);
            circle(r = radius);
        }
}

module bottom_hole() {
    translate([piHoleOffset, piHoleOffset,-1]) cylinder(h=bottomThick+2, d=3);
    translate([piX-piHoleOffset, piHoleOffset,-1]) cylinder(h=bottomThick+2, d=3);
    translate([piHoleOffset, piY-piHoleOffset,-1]) cylinder(h=bottomThick+2, d=3);
    translate([piX-piHoleOffset, piY-piHoleOffset,-1]) cylinder(h=bottomThick+2, d=3);
}

module bottom_mount(offsetX,offsetY,Thick) {
    difference() {
        translate([offsetX, offsetY, Thick]) cylinder(h=bottomMountHeight, d=bottomMountDia);
        translate([offsetX, offsetY, Thick-1]) cylinder(h=bottomMountHeight+2, d=3);
    }
}

module top_mount(offsetX,offsetY,Thick) {
    difference() {
        translate([offsetX, offsetY, Thick]) cylinder(h=topHeight-topThick, d=topMountDia);
        translate([offsetX, offsetY, Thick-1]) cylinder(h=topHeight-topThick+2, d=3);
    }
}

//module sink() { cylinder(h=1.5, r1=1.25, r2=2.35); }

module usb_lip() {
    translate([1, bottomThick/2, 1])
        rotate([90,0,0])
            rounded_rect(usbWidth, usbHeight, bottomThick/2, 1);
}

module micro_lip() {
    translate([bottomThick/2, 1, 1])
        rotate([0,270,0])
            rounded_rect(microHeight+1, microLength, bottomThick/2, 1);
}

module sd_lip() {
    rotate([270,0,0])
        rounded_rect(cardWidth, bottomThick+bottomMountHeight, bottomThick, 1);
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
