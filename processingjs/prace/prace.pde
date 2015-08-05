/* 
 PRACE -- a 2D mini action game implemented in processing.js
 Gameplay:
   You are the red guy. Don't crash into the ground/ceiling, and don't get hit by the blue guys.
   You get points for surviving each second, and flying closer to enemies increases score gained per second!
 written :by Tim 'spirit' Schaefer, http://rcmd.org/spirit/
 Idea and initial code based on the Processingjs.com header animation  
 MIT License  
 */

int OBJ_XPOS = 0;
int OBJ_YPOS = 1;
int OBJ_RADIUS = 2;
int OBJ_XSPEED = 3;
int OBJ_YSPEED = 4;

float MAX_SPEED = 2.0;
float MIN_SPEED = -2.0;

// Set number of circles
int count = 25;  // enemy count
int fps = 60;  // frames per second
int backgroundStartrailCount = 10;
float[][] st = new float[backgroundStartrailCount][5];  // star trails, this is decoration only

// Set maximum and minimum circle size
int maxSize = 100;
int minSize = 20;
// Build float array to store circle properties
float [] p = new float[5];  // player
float[][] e = new float[count][5];
// Set size of dot in center of players and enemies
float ds=2;
// Set drag switch to false
boolean pressingmouse = false;
// integers showing which circle (the first index in e) that's locked, and its position in relation to the mouse
int lockedCircle; 
int lockedOffsetX;
int lockedOffsetY;

// load a font for usage later
PFont font;
font = loadFont("DINBold.ttf"); 
textFont(font, 12); 

// scores
int score = 0;
int maxScore = 0;

// frame counter
int frame = 0;

// score multiplier
int scoreMultiplier = 1;
int maxScoreMultiplier = 10;

// handling of player death
boolean playerdead = false;
int waitFramesOnDeath = fps * 3;
int waitedFramesSinceDeath;
boolean playerInvuln = false;	// player is invulnerable for a short time after dying
int waitFramesInvuln = fps * 3;
int waitedFramesInvuln = 0;

void playerkilled() {
  playerdead = true;
  waitedFramesSinceDeath = 0;
}

// If user presses mouse...
void mousePressed () {
  // increase player thrust
    pressingmouse = true;
    
        
}
// If user releases mouse...
void mouseReleased() {
  // ..user is no-longer dragging
  pressingmouse = false;
}

// lower and upper borders at player position
int playerBorderYTop;
int playerBorderYBottom;


// Set up canvas
void setup() {
  // Frame rate
  frameRate(fps);
  // Size of canvas (width,height)
  size(800, 600);
  playerBorderYTop = 20;
  playerBorderYBottom = height - 20;

  // Stroke/line/border thickness
  strokeWeight(1);
  // Initiate array with more or less random values for enemies
  for (int j=0;j< count;j++) {
    e[j][OBJ_XPOS]=random(width/3, width); // X 
    e[j][OBJ_RADIUS]=random(minSize, maxSize); // Radius        
    e[j][OBJ_YPOS]=random(playerBorderYTop + e[j][OBJ_RADIUS], playerBorderYBottom - e[j][OBJ_RADIUS]); // Y    
    e[j][OBJ_XSPEED]=random(-2.0, -1.0); // X Speed
    e[j][OBJ_YSPEED]=0.; // Y Speed
  }
  
  // generate star trails in background
  for(int j=0;j< backgroundStartrailCount;j++) {
    st[j][OBJ_XPOS]=random(0, width); // X 
    st[j][OBJ_RADIUS]=random(10,15); // the length of the trail in this case        
    st[j][OBJ_YPOS]=random(playerBorderYTop + e[j][OBJ_RADIUS], playerBorderYBottom - e[j][OBJ_RADIUS]); // Y    
    st[j][OBJ_XSPEED]=random(-0.9, -0.6); // X Speed
    st[j][OBJ_YSPEED]=0.; // Y Speed
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
  scoreMultiplier = 1;
  background(0);
  
  if(playerdead) {
    fill(255, 255, 255, 255);
    textFont(font, 20); 
    text("YOU ARE DEAD -- TRY AGAIN IN " + (floor((waitFramesOnDeath - waitedFramesSinceDeath) / fps)) + "...", width/4, height/2);
	textFont(font, 12); 
	text("Current score reset, keeping highscore.", width/3, height/2 + 25);
    textFont(font, 12); 
    waitedFramesSinceDeath++;
    if(waitedFramesSinceDeath > waitFramesOnDeath) {	// player alive again
      waitedFramesSinceDeath = 0;
      p[OBJ_XPOS] = 50;
      p[OBJ_YPOS] = height/2;
      p[OBJ_XSPEED] = 0;
      p[OBJ_YSPEED] = 0;
      score = 0;
	  playerInvuln = true;
      playerdead = false;
	  waitedFramesInvuln = 0;
    }
  }
  
  // check whether we need to disable invulnerability again (some time after death)
  if(playerInvuln) {
    waitedFramesInvuln++;
	if(waitedFramesInvuln > waitFramesInvuln) {
	  playerInvuln = false;
	  waitedFramesInvuln = 0;
	}
  }
  
  // draw upper and lower borders
  fill(80, 80, 80, 255);
  if(p[OBJ_YPOS] < playerBorderYTop + p[OBJ_RADIUS]/2 || p[OBJ_YPOS] > playerBorderYBottom - p[OBJ_RADIUS]/2) {
    fill(120, 40, 40, 255); // flash borders red if player gets very close
  }
  rect(0, 0, width, playerBorderYTop);
  rect(0, playerBorderYBottom, width, 20);
  
  
  // compute player movement
  if(pressingmouse) {
    p[OBJ_YSPEED] -= 0.2;
    if(p[OBJ_YSPEED] < MIN_SPEED) {
        p[OBJ_YSPEED] = MIN_SPEED;
    }
  }
  else {
      p[OBJ_YSPEED] += 0.1;
  if(p[OBJ_YSPEED] > MAX_SPEED) {
        p[OBJ_YSPEED] = MAX_SPEED;
    }
  }
  
  
  // Move player according to current speed
  if(! playerdead) {
    p[OBJ_XPOS] += p[OBJ_XSPEED];
    p[OBJ_YPOS] += p[OBJ_YSPEED];
  }
  
  //textFont(font, 12); 
  //text("Player at: (" + p[OBJ_XPOS] + " / " + p[OBJ_YPOS] + "), borders at " + playerBorderYTop + " and " + playerBorderYBottom + ".", width/2, 40);
  
  // check whether player has crashed into the upper or lower border
  if(p[OBJ_YPOS] < playerBorderYTop || p[OBJ_YPOS] > playerBorderYBottom) {
    // player crashed, reset him and reset current score to 0
    if(!playerdead) {
	  if(playerInvuln) {
	    // player is invulnerable. do not kill him, but do not let him move further.
		if(p[OBJ_YPOS] < playerBorderYTop) {
		  p[OBJ_YPOS] = playerBorderYTop;
		}
		if(p[OBJ_YPOS] > playerBorderYBottom) {
		  p[OBJ_YPOS] = playerBorderYBottom;
		}
	  }
	  else {
        playerkilled();  
	  }
    }
  }
  
  // Draw player
  fill(187, 64, 64, 100);	// default player color (when alive)
  if(playerdead) {
    fill(187, 128, 128, 220);	// make player very transparent and less red if currently dead
  }
  if(playerInvuln) {
    fill(255, 255, 255, 220);	// draw white shield around player if currently invulnerable
	ellipse(p[OBJ_XPOS], p[OBJ_YPOS], p[OBJ_RADIUS] + 5, p[OBJ_RADIUS] + 5);
	fill(187, 64, 64, 100);
  }
  ellipse(p[OBJ_XPOS], p[OBJ_YPOS], p[OBJ_RADIUS], p[OBJ_RADIUS]);
  noStroke();
  // Draw dot in center of player
  rect(p[OBJ_XPOS]-ds, p[OBJ_YPOS]-ds, ds*2, ds*2);
  
  
  // move and draw startrails in background
  for (int j=0;j< backgroundStartrailCount;j++) {
    st[j][OBJ_XPOS] += st[j][OBJ_XSPEED];
	int colorShift = floor(abs(st[j][OBJ_XSPEED]*st[j][OBJ_XSPEED]*st[j][OBJ_XSPEED]) * 100.0);   // change color of startrail based on its speed
	stroke(30 + colorShift,30 + colorShift,60 + colorShift,255);	// dark blue-ish
	line(st[j][OBJ_XPOS], st[j][OBJ_YPOS], st[j][OBJ_XPOS] + st[j][OBJ_RADIUS], st[j][OBJ_YPOS]);
	
	// make them re-enter at the right if they left the screen on the left, but with randomized y position
	float stdiam = st[j][OBJ_RADIUS] / 2;
	if ( st[j][OBJ_XPOS] < -stdiam      ) { 
      st[j][OBJ_XPOS] = width+stdiam;
	  st[j][OBJ_YPOS] = random(playerBorderYTop + e[j][OBJ_RADIUS], playerBorderYBottom - e[j][OBJ_RADIUS]);
    } 
  }
  
  noStroke();
  
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
    
    stroke(64, 128, 128, 255);		// set line color to turquoise.
    

    // Loop through all circles
    for (int k=0;k< count;k++) {
      // If the circles are close...
      if ( sq(e[j][OBJ_XPOS] - e[k][OBJ_XPOS]) + sq(e[j][OBJ_YPOS] - e[k][OBJ_YPOS]) < sq(diam) ) {
        // Stroke a line from current circle to adjacent circle
        line(e[j][OBJ_XPOS], e[j][OBJ_YPOS], e[k][OBJ_XPOS], e[k][OBJ_YPOS]);
      }
    }

    
    
    // Check distance to player: if we are getting close:
    if ( sq(e[j][OBJ_XPOS] - p[OBJ_XPOS]) + sq(e[j][OBJ_YPOS] - p[OBJ_YPOS]) < (sq(diam) * 6) ) {
      stroke(255, 255, 255, 255);		// set line color to white.
      // Stroke a line from current enemy to player
      line(e[j][OBJ_XPOS], e[j][OBJ_YPOS], p[OBJ_XPOS], p[OBJ_YPOS]);
      scoreMultiplier++; // player gets 1 bonus point per frame if he is close to enemy
      
      // check whether we are getting closer
      if ( sq(e[j][OBJ_XPOS] - p[OBJ_XPOS]) + sq(e[j][OBJ_YPOS] - p[OBJ_YPOS]) < (sq(diam) * 2) ) {
	stroke(64, 128, 128, 255);		// set line color to turquoise.
	line(e[j][OBJ_XPOS], e[j][OBJ_YPOS], p[OBJ_XPOS], p[OBJ_YPOS]);  // Stroke a line from current enemy to player
	scoreMultiplier++; // player gets another bonus point per frame if he is *very* close to enemy
	
	  // check whether we are too close and the enemy can kill the player
	  if ( sq(e[j][OBJ_XPOS] - p[OBJ_XPOS]) + sq(e[j][OBJ_YPOS] - p[OBJ_YPOS]) < (sq(diam)) ) {
	      // set color to red (shooting laser)
	      stroke(187, 0, 0, 255);
	      line(e[j][OBJ_XPOS], e[j][OBJ_YPOS], p[OBJ_XPOS], p[OBJ_YPOS]);	// Stroke a line from current enemy to player
	      // player killed by enemy, reset him and reset current score to 0
	      if(!playerdead) {
		        if(!playerInvuln) {
                  playerkilled();
                }				
	      }
	  }	  	  
      }
    }
    
    // Turn off stroke/border
    noStroke();      
    // Draw dot in center of this enemy
    rect(e[j][0]-ds, e[j][1]-ds, ds*2, ds*2);
  }
  
  // print score in upper right corner
  fill(255, 255, 255, 255);
  if(score >= maxScore) {
    fill(255, 30, 30, 255);	// print red if currently setting new max score
  }
  textFont(font, 12); 
  text("Score: " + score + " Best: " + maxScore + "", width/2, 20);
    
  // limit score muliplier to 10x
  if(scoreMultiplier > maxScoreMultiplier) {
    scoreMultiplier = maxScoreMultiplier;
  }
  
  fill(255, 255, 255, 255);	// white for font
  if((! playerdead) && (!playerInvuln)) {	// player only gets score if he is not dead, and not invulnerable   
    textFont(font, (40 + scoreMultiplier * 5));
    fill(255, 200 - scoreMultiplier * 20, 200 - scoreMultiplier * 20, 255);	// make score multiplier more red if it is higher
    text(scoreMultiplier + "x", width - 70, height - 70);    
    score += scoreMultiplier;	// player gets 1 point for every frame he survived
  }
  else {
    // different score multiplier shown when dead
    textFont(font, 40);
    text("--", width - 60, height - 60);
  }
  
  if(score > maxScore) { maxScore = score; }
}
