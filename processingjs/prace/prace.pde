/* 
 PRACE -- a 2D mini action game implemented in processing.js
 Gameplay:
   You are the red guy. Don't crash into the ground/ceiling, and don't get hit by the blue guys.
   You get points for surviving each second, and flying closer to enemies increases score gained per second!
 written :by Tim 'spirit' Schaefer, http://rcmd.org/spirit/
 The initial code was based on the Processingjs.com header animation
 MIT License  
 */

 // constants for object properties (index in player/enemies array)
int OBJ_XPOS = 0;
int OBJ_YPOS = 1;
int OBJ_RADIUS = 2;
int OBJ_XSPEED = 3;
int OBJ_YSPEED = 4;

float MAX_SPEED = 2.0;
float MIN_SPEED = -2.0;

float caveWallSpeed = 1.0;  // the speed at which the ceiling / floor moves (only relevant if GM_CAVE is on)

// game mode
int GM_ENEMIES = 0;	// whether enemies will spawn
int GM_CAVE = 1;	// whether the floor and ceiling has stalagmites / stalactites
boolean[] gameMode = new boolean[2];
gameMode[GM_ENEMIES] = true;
gameMode[GM_CAVE] = true;

int borderTopBottomHeight = 20;	// the height of the floor / ceiling (from bottom/top of screen)

// Set number of circles
int count = 20;  // enemy count
if( ! gameMode[GM_ENEMIES]) { count = 0; }

int[] ceilingPointsX;
int[] ceilingPointsY;
int[] floorPointsX;
int[] floorPointsY;

function Point2D(int x, int y) {
  this.x = x;
  this.y = y;
}

function leftMostPointXOf(Point2D[] poly) {
  int pointX = Number.MAX_VALUE;
  for(int i = 0; i < poly.length; i++) {
    if(poly[i].x < pointX) {
	  pointX = poly[i].x;
	}
  }
  if(pointX < Number.MAX_VALUE) {
    return pointX;
  }
  return null;
}

function rightMostPointXOf(Point2D[] poly) {
  int pointX = - Number.MAX_VALUE;
  for(int i = 0; i < poly.length; i++) {
    if(poly[i].x > pointX) {
	  pointX = poly[i].x;
	}
  }
  if(pointX > - Number.MAX_VALUE) {
    return pointX;
  }
  return null;
}

int fps = 60;  // frames per second
int backgroundStartrailCount = 10;
float[][] st = new float[backgroundStartrailCount][5];  // star trails, this is decoration only

// Set maximum and minimum circle size
int maxSize = 100;
int minSize = 20;
int specialSize = 35; // all enemies smaller than this are different color and give even more score when close to them
// Build float array to store circle properties
float [] p = new float[5];  // player
float[] lastPlayerPosY = new float[1]; // the n last y positions of player, to draw tail

float[][] e = new float[count][5];  // enemies (blue circles)
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

int maxMultiplierThisLife = 1;

long framesThisLife = 1;	// set 1 instead of 0 to prevent division by zero

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

Point2D[][] ceilingPolygons;

// Set up canvas
void setup() {
  // Frame rate
  frameRate(fps);
  // Size of canvas (width,height)
  size(800, 600);
  playerBorderYTop = borderTopBottomHeight;
  playerBorderYBottom = height - borderTopBottomHeight;
  
  // prepare cave stuff
  ceilingPointsX = new int[]{ 100, 200, 300, 500, 550, 650 };
  ceilingPointsY = new int[]{ playerBorderYTop, playerBorderYTop + 100, playerBorderYTop, playerBorderYTop, playerBorderYTop + 150, playerBorderYTop  };
  ceilingPolygons = new Point2D[][]{ [new Point2D(100, playerBorderYTop), new Point2D(200,playerBorderYTop+100), new Point2D(300,playerBorderYTop)], [new Point2D(500, playerBorderYTop), new Point2D(550,playerBorderYTop+150), new Point2D(650,playerBorderYTop)] };
  floorPointsX = new int[]{ 250, 300, 400, 550, 600, 650 };
  floorPointsY = new int[]{ playerBorderYBottom, playerBorderYBottom - 120, playerBorderYBottom, playerBorderYBottom, playerBorderYBottom - 80, playerBorderYBottom };

  if( ! gameMode[GM_CAVE]) {
    ceilingPointsX.length = 0;
    ceilingPointsY.length = 0;
  }


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
  p[OBJ_XPOS] = 100;
  p[OBJ_YPOS] = height/2;
  p[OBJ_RADIUS] = 30;
  p[OBJ_XSPEED] = 0;
  p[OBJ_YSPEED] = 0;
  
  lastPlayerPosY[0] = p[OBJ_YPOS];
}

boolean crashedThisFrame;
int maxMultiScore = 0;
int maxMultiScoreMultiplier = 1;  // the multiplier that lead to the highest multi-score
int multiScore = 0;

// Begin main draw loop
void draw() {
  // Fill background black
  scoreMultiplier = 1;
  background(0);
  crashedThisFrame = false;
  
  if(playerdead) {
    fill(255, 255, 255, 255);
    textFont(font, 20); 
    text("CORE DESTROYED -- TRY AGAIN IN " + (floor((waitFramesOnDeath - waitedFramesSinceDeath) / fps)) + "...", width/4, height/2);
	textFont(font, 12);	
	
	if(score == maxScore) {
	  fill(0, 255, 0, 255);
	  text("CONGRATULATIONS, NEW HIGHSCORE!", width/3, height/2 + 25);
	}
	else {
	  text("Missed highscore by " + (maxScore - score) + ", please try again!", width/3, height/2 + 25);
	}		
	
	fill(255, 255, 255, 255);
	text("Your score was " +  score + ", highscore is " + maxScore + ".", width/3, height/2 + 50);
	text("Your maximum score multiplier was " +  maxMultiplierThisLife + "x.", width/3, height/2 + 75);
	
	multiScore = score * maxMultiplierThisLife;
	if(multiScore >= maxMultiScore) {
	  fill(0, 255, 0, 255);
	  text("CONGRATULATIONS, NEW MULTI-HIGHSCORE!", width/3, height/2 + 100); 
	  fill(255, 255, 255, 255);
	  text("New multi-highscore is " +  multiScore + " (" + score +"x" + maxMultiplierThisLife + ")!", width/3, height/2 + 125);
	  maxMultiScore = multiScore;
	  maxMultiScoreMultiplier = maxMultiplierThisLife;
	}
	else {
	  text("Reached a multi-score of " + multiScore + ", missed multi-highscore by " + (maxMultiScore - multiScore) + ".", width/3, height/2 + 100);
	}
	
	//text("Your score per second was " + nfc((framesThisLife / fps / score), 3)  +  ".", width/3, height/2 + 100);
    textFont(font, 12); 
    waitedFramesSinceDeath++;
    if(waitedFramesSinceDeath > waitFramesOnDeath) {	// player alive again
      waitedFramesSinceDeath = 0;
      p[OBJ_XPOS] = 100;
      p[OBJ_YPOS] = height/2;
      p[OBJ_XSPEED] = 0;
      p[OBJ_YSPEED] = 0;
      score = 0;
      playerInvuln = true;
      playerdead = false;
      waitedFramesInvuln = 0;
      maxMultiplierThisLife = 1;
      framesThisLife = 1;	// set 1 instead of 0 to prevent division by zero
          
	  lastPlayerPosY.length = 0;  // empty array of last player positions
    }
  }

  // record last positions of player for drawing tail
  if( ! playerdead) {
    if(frameCount % 3 == 0) { // log only every nth frame, otherwise there is too little difference in the positions
	  lastPlayerPosY = splice(lastPlayerPosY, p[OBJ_YPOS], 0);
	  if(lastPlayerPosY.length > 5) { 
	    lastPlayerPosY = lastPlayerPosY.slice(0,5);   // truncate array, keep only n previous positions
      }
	}
  }
  //text("Recorded last " + lastPlayerPosY.length + " positions.", width - 100, height - 100);
  
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
  
  // draw cave if appropriate
  if(gameMode[GM_CAVE]) {
    // move cave ceiling
	//for(int j = 0; j < ceilingPointsX.length; j++) {
    //  ceilingPointsX[j] -= caveWallSpeed;
	//}
	for(int j = 0; j < ceilingPolygons.length; j++) {
	  Point2D[] poly = ceilingPolygons[j];
	  for(int k = 0; k < poly.length; k++) {
	    Point2D vert = poly[k];
		vert.x -= caveWallSpeed;
	  }	  	  
	}
	
	// make ceiling obstacles re-enter if completely out of the screen
	for(int j = 0; j < ceilingPolygons.length; j++) {
	  Point2D[] poly = ceilingPolygons[j];
	  int rmx = rightMostPointXOf(poly);
	  int polyWidth = rmx - leftMostPointXOf(poly);
	  int polyShift = random(0, 30);
	  //text("rmx = " + rmx + ".", 100, 100);
	  if(rmx <= 0) {
	    for(int k = 0; k < poly.length; k++) {
	      Point2D vert = poly[k];
		  vert.x += (width + polyWidth + polyShift);
	    }
	  }
	}
	
	
	
	// move cave floors
	for(int j = 0; j < floorPointsX.length; j++) {
      floorPointsX[j] -= caveWallSpeed;
	}
    
    // draw ceiling stuff as a single polygon
    //beginShape();
	//for(int j = 0; j < ceilingPointsX.length; j++) {
    //  vertex(ceilingPointsX[j], ceilingPointsY[j]);
	//}
    //endShape();
	
	// draw ceiling as separate polygons
	for(int j = 0; j < ceilingPolygons.length; j++) {
	  Point2D[] poly = ceilingPolygons[j];
	  beginShape();
	  for(int k = 0; k < poly.length; k++) {
	    Point2D vert = poly[k];
	    vertex(vert.x, vert.y);
	  }	        
	  endShape();
	}
    
	
	// draw floor stuff as another single polygon
    beginShape();
	for(int j = 0; j < floorPointsX.length; j++) {
      vertex(floorPointsX[j], floorPointsY[j]);
	}
    endShape();
  }
  
  
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
  
  // Move player according to current speed
  if(! playerdead) {
    p[OBJ_XPOS] += p[OBJ_XSPEED];
    p[OBJ_YPOS] += p[OBJ_YSPEED];
  }
  
  //textFont(font, 12); 
  //text("Player at: (" + p[OBJ_XPOS] + " / " + p[OBJ_YPOS] + "), borders at " + playerBorderYTop + " and " + playerBorderYBottom + ".", width/2, 40);
  
  // check whether player has crashed into the upper or lower border
  if(p[OBJ_YPOS] < playerBorderYTop || p[OBJ_YPOS] > playerBorderYBottom) {
    crashedThisFrame = true;
  }
  
  
  // in GM_CAVE, check whether player crashed into spikes from ceil/floor
  if(gameMode[GM_CAVE]) {
    // check line by line:
	
	// find the relevant line (the one at player x pos, if any)
	fill(255, 0, 0, 255);
	stroke(255, 0, 0, 255);
	
	/*
	if(ceilingPointsX.length > 1) {
	  for(int j = 1; j < ceilingPointsX.length; j++) {
        lineStartX = ceilingPointsX[j-1];
		lineStartY = ceilingPointsY[j-1];
		lineEndX = ceilingPointsX[j];
		lineEndY = ceilingPointsY[j];
		stroke(0, 0, 255, 255);
		line(lineStartX, lineStartY, lineEndX, lineEndY);
		if(lineStartX <= p[OBJ_XPOS] && lineEndX >= p[OBJ_XPOS]) {  // if the line started left of the player and ends right of him, it is relevant for us
		  stroke(255, 0, 0, 255);
		  line(lineStartX, lineStartY, lineEndX, lineEndY);
		  float lineAscend = float(lineEndY - lineStartY)  / float(lineEndX - lineStartX);
		  int relPlayerPos = p[OBJ_XPOS] - lineStartX;	// the X position of the line at which the player is 
		  int lineLengthX = lineEndX - lineStartX;
		  int pointAtPlayerX = p[OBJ_XPOS];
		  int pointAtPlayerY = lineStartY + float(lineAscend * float(relPlayerPos));
		  //text("pointAtPlayerY = " + pointAtPlayerY +" = " + lineStartY + " + (" + lineAscend + "*" + lineLengthX, 200, 150);
		  //text("lineAscend = " + lineAscend + " (" + float(lineEndY - lineStartY) + ", " + float(lineEndX - lineStartX) + "). lineLengthX=" + lineLengthX + ".", 200, 200);
		  fill(255, 0, 0, 255);
		  rect(pointAtPlayerX, pointAtPlayerY, 5, 5);  // draw debug marker for point
		}
	  }
	}
	*/
	
	// check collisions with poly
	for(int j = 0; j < ceilingPolygons.length; j++) {
	  Point2D[] poly = ceilingPolygons[j];
	  if(poly.length >= 3) {
	      //text("Ceiling polys = " + ceilingPolygons.length + ", current has " + poly.length + " points.", 200, 200); 
		  for(int k = 1; k < poly.length; k++) {
		    if(k == poly.length) {	// close the shape by drawing a line from first point to the last one (left to right)
			  Point2D startPoint = poly[0];
			  Point2D endPoint = poly[k-1];
			}
			else {
			  Point2D startPoint = poly[k-1];
			  Point2D endPoint = poly[k];
			}
			lineStartX = startPoint.x;
		    lineStartY = startPoint.y;
			lineEndX = endPoint.x;
			lineEndY = endPoint.y;
			//stroke(0, 0, 255, 255);
			//line(lineStartX, lineStartY, lineEndX, lineEndY);
			//text("Line from (" + lineStartX + "/" + lineStartY + " to (" + lineEndX + "/" + lineEndY +").", 200, 100);
			if(lineStartX <= p[OBJ_XPOS] && lineEndX >= p[OBJ_XPOS]) {  // if the line started left of the player and ends right of him, it is relevant for us
			  //stroke(255, 0, 0, 255);
			  //line(lineStartX, lineStartY, lineEndX, lineEndY);
			  float lineAscend = float(lineEndY - lineStartY)  / float(lineEndX - lineStartX);
			  int relPlayerPos = p[OBJ_XPOS] - lineStartX;	// the X position of the line at which the player is 
			  int lineLengthX = lineEndX - lineStartX;
			  int pointAtPlayerX = p[OBJ_XPOS];
			  int pointAtPlayerY = lineStartY + float(lineAscend * float(relPlayerPos));
			  if(p[OBJ_YPOS] < pointAtPlayerY) {
			    crashedThisFrame = true;
			  }
			  //text("pointAtPlayerY = " + pointAtPlayerY +" = " + lineStartY + " + (" + lineAscend + "*" + lineLengthX, 200, 150);
			  //text("lineAscend = " + lineAscend + " (" + float(lineEndY - lineStartY) + ", " + float(lineEndX - lineStartX) + "). lineLengthX=" + lineLengthX + ".", 200, 200);
			  //fill(255, 0, 0, 255);
			  //rect(pointAtPlayerX, pointAtPlayerY, 5, 5);  // draw debug marker for point
			}
			
		  }	        
	  }
	  
	}	
	
  }
  noStroke();
  
  if(crashedThisFrame) {
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
  fill(187, 64, 64, 255);	// default player color (when alive)
  if(playerdead) {
    fill(187, 128, 128, 220);	// make player very transparent and less red if currently dead
  }
  if(playerInvuln) {
    fill(255, 255, 255, 100 + (millis() % 150));	// draw white shield around player if currently invulnerable (animation: flicker shield)
	ellipse(p[OBJ_XPOS], p[OBJ_YPOS], p[OBJ_RADIUS] + 5, p[OBJ_RADIUS] + 5);
	fill(187, 64, 64, 200);  // set default player color
  }
  ellipse(p[OBJ_XPOS], p[OBJ_YPOS], p[OBJ_RADIUS], p[OBJ_RADIUS]);	// actually draw the player
  
  // draw tail of player
  if(! playerdead) {
    int sumShiftLeft = 0;
	int thisShadeRadius;
    for(int j = 0; j < lastPlayerPosY.length; j++) {  // draw the last n positions
	    fill(187, 64, 64, 150 - ((j+1) * 25));  // make them more and more transparent the older (farther to the left) they are
		thisShadeRadius = p[OBJ_RADIUS] - ((j+1)*5); // also make them smaller
		sumShiftLeft += thisShadeRadius;  // keep track of where to place them
	    ellipse(p[OBJ_XPOS] - sumShiftLeft, lastPlayerPosY[j], thisShadeRadius, thisShadeRadius);	// draw the player's ghost (part of trail)
	}
  }
  
  noStroke();  
  fill(80, 50, 50, 255);
  rect(p[OBJ_XPOS]-ds, p[OBJ_YPOS]-ds, ds*2, ds*2);	// draw dot in center of player, the player core
  
  
  
  
  noStroke();
  
  // Begin looping through enemy array
  for (int j=0;j< count;j++) {
    // Disable shape stroke/border
    noStroke();
    
    boolean specialEnemy = false;
    if(e[j][OBJ_RADIUS] < specialSize) {
      specialEnemy = true;
    }
    
    // Cache diameter and radius of current circle
    float radi=e[j][OBJ_RADIUS];
    float diam=radi/2;	// half the enemy radius (bad naming, not exactly the diam, hehe)
    if (sq(e[j][0] - mouseX) + sq(e[j][1] - mouseY) < sq(e[j][2]/2)) {
      fill(64, 187, 128, 180); // green if mouseover
    }
    else {
      fill(64, 128, 187, 180); // blue
      if(specialEnemy) {
	    fill(64, 187, 187, 180); // blue-green
      }
    }
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
    float pdist = sq(e[j][OBJ_XPOS] - p[OBJ_XPOS]) + sq(e[j][OBJ_YPOS] - p[OBJ_YPOS]);
    float sqdiam = sq(diam);
	if(specialEnemy) { strokeWeight(2); } else { strokeWeight(1); }   // draw lines thicker for special enemies
    if ( (pdist < sqdiam * 6) || (pdist < p[OBJ_RADIUS] * 3))  {
      stroke(255, 255, 255, 255);		// set line color to white.
      // Stroke a line from current enemy to player
      line(e[j][OBJ_XPOS], e[j][OBJ_YPOS], p[OBJ_XPOS], p[OBJ_YPOS]);
      scoreMultiplier++; // player gets 1 bonus point per frame if he is close to enemy
      if(specialEnemy) { scoreMultiplier += 2; }  // even more bonus for special enemies
      
      // check whether we are getting closer
      if ( pdist < sqdiam * 2)  {
	stroke(64, 128, 128, 255);		// set line color to turquoise.
	line(e[j][OBJ_XPOS], e[j][OBJ_YPOS], p[OBJ_XPOS], p[OBJ_YPOS]);  // Stroke a line from current enemy to player
	scoreMultiplier++; // player gets another bonus point per frame if he is *very* close to enemy
	if(specialEnemy) { scoreMultiplier += 2; }  // even more bonus for special enemies
	
	  // check whether we are too close and the enemy can kill the player
	  if ( pdist < sqdiam)  {
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
  
  // print app name and author
  fill(150, 150, 150, 255);  // gray
  textFont(font, 12); 
  text("PRace by spirit", 15, 15);
  
  
  // print score in upper right corner
  fill(255, 255, 255, 255); // white
  if(score >= maxScore) {
    fill(255, 30, 30, 255);	// print red if currently setting new max score
  }
  text("Score: " + score + " Highscore: " + maxScore + "", width/4, 15);
  
  // print multiScore
  fill(255, 255, 255, 255); // white
  if(score * maxMultiplierThisLife >= maxMultiScore) {
    fill(255, 30, 30, 255);	// print red if currently setting new max score
  }
  text("Multi-Score: " + (score * maxMultiplierThisLife) + " @" + maxMultiplierThisLife + "x, Best: " + maxMultiScore + " @" + maxMultiScoreMultiplier + "x", width/2, 15);
    
  // limit score muliplier to 10x
  if(scoreMultiplier > maxScoreMultiplier) {
    scoreMultiplier = maxScoreMultiplier;
  }
  
  fill(255, 255, 255, 255);	// white for font
  if((! playerdead) && (!playerInvuln)) {	// player only gets score if he is not dead, and not invulnerable   
    framesThisLife++;
    textFont(font, (40 + scoreMultiplier * 8));
    fill(255, 200 - scoreMultiplier * 20, 200 - scoreMultiplier * 20, 255);	// make score multiplier more red if it is higher
    text(scoreMultiplier + "x", width - (70 + scoreMultiplier * 5), height - (70 + scoreMultiplier * 5) );    
    
    // keep track of the maximum score multiplier reached in a single life (gets reset to 1 on death)
    if(scoreMultiplier > maxMultiplierThisLife) {
      maxMultiplierThisLife = scoreMultiplier;
    }
    
    score += scoreMultiplier;	// player gets 1 point for every frame he survived
  }
  else {
    // different score multiplier shown when dead
    textFont(font, 40);
    text("--", width - 60, height - 60);
  }
  
  if(score > maxScore) { maxScore = score; }
}
