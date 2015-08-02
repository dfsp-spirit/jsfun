/* 
 PROCESSINGJS.COM HEADER ANIMATION  
 MIT License - F1lT3R/Hyper-Metrix
 Native Processing Compatible 
 */

int OBJ_XPOS = 0;
int OBJ_YPOS = 1;
int OBJ_RADIUS = 2;
int OBJ_XSPEED = 3;
int OBJ_YSPEED = 4;

// Set number of circles
int count = 20;
// Set maximum and minimum circle size
int maxSize = 100;
int minSize = 20;
// Build float array to store circle properties
float [] p = new float[5];  // player
float[][] e = new float[count][5];
// Set size of dot in circle center
float ds=2;
// Set drag switch to false
boolean pressingmouse = false;
// integers showing which circle (the first index in e) that's locked, and its position in relation to the mouse
int lockedCircle; 
int lockedOffsetX;
int lockedOffsetY;
// If user presses mouse...
void mousePressed () {
  // increase player thrust
    pressingmouse = true;
    p[OBJ_YSPEED] += .01; 
}
// If user releases mouse...
void mouseReleased() {
  // ..user is no-longer dragging
  pressingmouse = false;
}

// Set up canvas
void setup() {
  // Frame rate
  frameRate(60);
  // Size of canvas (width,height)
  size(800, 600);
  // Stroke/line/border thickness
  strokeWeight(1);
  // Initiate array with random values for enemies
  for (int j=0;j< count;j++) {
    e[j][OBJ_XPOS]=random(width/2, width); // X 
    e[j][OBJ_YPOS]=random(height); // Y
    e[j][OBJ_RADIUS]=random(minSize, maxSize); // Radius        
    e[j][OBJ_XSPEED]=random(-0.2, -0.1); // X Speed
    e[j][OBJ_YSPEED]=0.; // Y Speed
  }
  // place player
  p[OBJ_XPOS] = 50;
  p[OBJ_YPOS] = height/2;
  p[OBJ_RADIUS] = 30;
  p[OBJ_XSPEED] = 0;
  p[OBJ_YSPEED] = 0;
}

// Begin main draw loop (called 25 times per second)
void draw() {
  // Fill background black
  background(0);
  
  // Draw player
  fill(187, 64, 64, 100);
    ellipse(p[OBJ_XPOS], p[OBJ_YPOS], p[OBJ_RADIUS], p[OBJ_RADIUS]);
    // Move player
    p[OBJ_XPOS]+=p[OBJ_XSPEED];
    p[OBJ_YPOS]+=p[OBJ_YSPEED];
  
  // Begin looping through enemy array
  for (int j=0;j< count;j++) {
    // Disable shape stroke/border
    noStroke();
    // Cache diameter and radius of current circle
    float radi=e[j][OBJ_RADIUS];
    float diam=radi/2;
    if (sq(e[j][0] - mouseX) + sq(e[j][1] - mouseY) < sq(e[j][2]/2))
      fill(64, 187, 128, 100); // green if mouseover
    else
      fill(64, 128, 187, 100); // regular
    //if ((lockedCircle == j && dragging)) {
      // // Move the particle's coordinates to the mouse's position, minus its original offset
      //e[j][0]=mouseX-lockedOffsetX;
      //e[j][1]=mouseY-lockedOffsetY;
    //}
    // Draw circle
    ellipse(e[j][OBJ_XPOS], e[j][OBJ_YPOS], radi, radi);
    // Move circle
    e[j][OBJ_XPOS]+=e[j][OBJ_XSPEED];
    e[j][OBJ_YPOS]+=e[j][OBJ_YSPEED];


    /* Wrap edges of canvas so circles leave the top
     and re-enter the bottom, etc... */
    if ( e[j][OBJ_XPOS] < -diam      ) { 
      e[j][OBJ_XPOS] = width+diam;
    } 
    if ( e[j][OBJ_XPOS] > width+diam ) { 
      e[j][OBJ_XPOS] = -diam;
    }
    if ( e[j][OBJ_YPOS] < 0-diam     ) { 
      e[j][OBJ_YPOS] = height+diam;
    }
    if ( e[j][OBJ_YPOS] > height+diam) { 
      e[j][OBJ_YPOS] = -diam;
    }

    // otherwise set center dot color to black.. 
    fill(0, 0, 0, 255);
    // and set line color to turquoise.
    stroke(64, 128, 128, 255);
    

    // Loop through all circles
    for (int k=0;k< count;k++) {
      // If the circles are close...
      if ( sq(e[j][OBJ_XPOS] - e[k][OBJ_XPOS]) + sq(e[j][OBJ_YPOS] - e[k][OBJ_YPOS]) < sq(diam) ) {
        // Stroke a line from current circle to adjacent circle
        line(e[j][OBJ_XPOS], e[j][OBJ_YPOS], e[k][OBJ_XPOS], e[k][OBJ_YPOS]);
      }
    }

    
    
    // Check distance to player: if we are close:
    if ( sq(e[j][OBJ_XPOS] - p[OBJ_XPOS]) + sq(e[j][OBJ_YPOS] - p[OBJ_YPOS]) < (sq(diam) * 2) ) {
        // check whether we are very close
        if ( sq(e[j][OBJ_XPOS] - p[OBJ_XPOS]) + sq(e[j][OBJ_YPOS] - p[OBJ_YPOS]) < (sq(diam)) ) {
            stroke(187, 0, 0, 255);
        }
        // Stroke a line from current enemy to player
        line(e[j][OBJ_XPOS], e[j][OBJ_YPOS], p[OBJ_XPOS], p[OBJ_YPOS]);
    }
    
    // Turn off stroke/border
    noStroke();      
    // Draw dot in center of circle
    rect(e[j][0]-ds, e[j][1]-ds, ds*2, ds*2);
  }
}
