
$fs = 0.5;
$fa = 2;


sd_cnt=5;
sd_height = 32;
sd_width  = 24+1;
sd_thickness  = 2.5+0.5;

msd_cnt = 6;
msd_height = 15;
msd_width = 11+1;
msd_thickness = 1.1+0.5;



card_rand1=msd_height/3;
card_rand2=sd_height/4;

lid_width = 3;
lid_factor = 1.02;


box_radius = 30;
box_height = sd_height + lid_width;

thread_height = box_height*0.8-card_rand1;
thread_width = 4;


nut_radius = box_radius+lid_width;
inner_radius = box_radius-1.5*thread_width;




module screw()
{
  r1 = box_radius-thread_width;
  r2 = box_radius;
  n = 7;
  t = 4;
  linear_extrude(height=200)
  polygon([
    [0,0,0],
    [0,nut_radius*2/sqrt(3),0],
    [nut_radius*2/sqrt(3),nut_radius*2/sqrt(3),0]
    ]);
  *cylinder(r=nut_radius*2/sqrt(3),h=box_height-thread_height,$fn=6);
  *translate([0,0,box_height-thread_height])
  {
    linear_extrude(height = thread_height, twist = 360*t/n, convexity = t)
    difference() {
      circle(r2);
      for (i = [0:n-1]) {
        
        rotate(i*360/n) polygon([
            [ 2*r2, 0 ],
            [ r2, 0 ],
            [ r1*cos(90/n), r1*sin(90/n) ],
            [ r1*cos(180/n), r1*sin(180/n) ],
            [ r2*cos(270/n), r2*sin(270/n) ],
            [ 2*r2*cos(270/n), 2*r2*sin(270/n) ],
        ]);
      }
    }
}  
}

module box()
{
difference(){   
    translate([0,0,box_height*-1])
        screw();

        
    intersection()
    {
        translate([-inner_radius,0,1-card_rand2])
            cube([2*inner_radius,inner_radius, card_rand2+1]);
        translate([0,0,1-card_rand2])
            cylinder(r = inner_radius, h = card_rand2+1);
    }
    
    //height available for sd cards
    sd_h=(sqrt(pow(inner_radius,2) - pow(sd_width/2,2)) -sd_cnt*sd_thickness)/(sd_cnt+1);
    
    for (i=[1:sd_cnt])
        translate([sd_width/-2,i*sd_h+(i-1)*sd_thickness,-sd_height+1])
            cube([sd_width,sd_thickness,sd_height]);
    
    //height available for micro sd cards
    msd_h=(sqrt(pow(inner_radius,2) - pow(msd_width/2+10,2)) -msd_cnt*msd_thickness)/(msd_cnt+1); 

    for (n=[-1,1])
        for (i=[1:msd_cnt])
            translate([10*n-msd_width/2,-i*(msd_h+msd_thickness),1-msd_height])
                cube([msd_width,msd_thickness,msd_height]);
}

}


module lid()
{
rotate([180,0,0])  
difference() {
    translate([0,0,box_height-thread_height])
        cylinder(r = box_radius+lid_width, h = thread_height+lid_width+card_rand1+1);
    scale([lid_factor,lid_factor,1]) 
        screw();
    translate([0,0,box_height+card_rand1+1-thread_height/2])
        cylinder(r = box_radius, h = thread_height/2);
    
  }
}


box();
//lid();