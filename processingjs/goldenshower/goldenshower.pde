/* 
 GoldenShower -- a 2D mini action game implemented in processing.js
 Gameplay:
  Don't get pished on, man.
 MIT License  
 */

 // constants for object properties (index in player/enemies array)
int OBJ_XPOS = 0;
int OBJ_YPOS = 1;
int OBJ_HEIGHT = 2;
int OBJ_WIDTH = 3;
int OBJ_XSPEED = 4;
int OBJ_YSPEED = 5;

float MAX_SPEED = 6.0;
float MIN_SPEED = -6.0;



int fps = 25;  // frames per second
int numStreams = 10;

// load a font for usage later
PFont font;
font = loadFont("DINBold.ttf"); 
textFont(font, 12); 

// scores
int score = 0;
int maxScore = 0;

// frame counter
int frame = 0;
float deltaT;


float[] player = new float[6];
float[][] streams = new float[numStreams][6];

// handling of player death
boolean playerdead = false;
int waitFramesOnDeath = fps * 3;
int waitedFramesSinceDeath;
boolean playerInvuln = false;	// player is invulnerable for a short time after dying
int waitFramesInvuln = fps * 3;
int waitedFramesInvuln = 0;
int playerBorderYBottom;
boolean pressingmouse = false;

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


function resetPlayer() {
  player[OBJ_WIDTH] = 40;
  player[OBJ_HEIGHT] = 20;
  player[OBJ_XSPEED] = 0;
  player[OBJ_YSPEED] = 0;
  player[OBJ_XPOS] = width/2;
  player[OBJ_YPOS] = playerBorderYBottom - player[OBJ_HEIGHT];
}

function generateEnemies() {
    for(int j=0; j < numStreams; j++) {
        streams[j][OBJ_XPOS] = random(20,width-20);
        streams[j][OBJ_YPOS] = random(0,height/2);
        streams[j][OBJ_WIDTH] = 10;
        streams[j][OBJ_HEIGHT] = random(50,80);
        streams[j][OBJ_XSPEED] = 0;
        streams[j][OBJ_YSPEED] = random(5.5,8.0);
    }
}

// Set up canvas
void setup() {
  // Frame rate
  frameRate(fps);
  // Size of canvas (width,height)
  size(400, 600);
  playerBorderYBottom = height -20;
  
  // place player
  resetPlayer();
  
  // generate enemies
  generateEnemies();
}

boolean crashedThisFrame;

function playerKilled() {
    playerdead = true;
  waitedFramesSinceDeath = 0;
}

function rectsOverlap(float[] o1, float[] o2) {
    return false;
}

// Begin main draw loop
void draw() {
  // Fill background black
  scoreMultiplier = 1;
  background(0);
  crashedThisFrame = false;
  
  if(playerdead) {
    fill(255, 255, 255, 255);
    textFont(font, 16); 
    text("PISSED ON -- TRY AGAIN IN " + (floor((waitFramesOnDeath - waitedFramesSinceDeath) / fps)) + "...", 20, height/2);
	textFont(font, 12);	
	
	if(score == maxScore) {
	  fill(0, 255, 0, 255);
	  text("CONGRATULATIONS, NEW HIGHSCORE!", 20, height/2 + 25);
	}
	else {
	  text("Missed highscore by " + (maxScore - score) + ", please try again!", width/3, height/2 + 25);
	}		
	
	fill(255, 255, 255, 255);
	text("Score: " +  score + ", highscore: " + maxScore + ".", width/3, height/2 + 50);
	
    textFont(font, 12); 
    waitedFramesSinceDeath++;
    if(waitedFramesSinceDeath > waitFramesOnDeath) {	// player alive again
      waitedFramesSinceDeath = 0;
      player[OBJ_XPOS] = width/2;
      player[OBJ_YPOS] = height-20-player[OBJ_HEIGHT];
      player[OBJ_XSPEED] = 0;
      player[OBJ_YSPEED] = 0;
      score = 0;
      playerInvuln = true;
      playerdead = false;
      waitedFramesInvuln = 0;
      framesThisLife = 1;	// set 1 instead of 0 to prevent division by zero
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
  
  // lower borders / ground
  fill(80, 80, 80, 255);
  rect(0, playerBorderYBottom, width, 20);
  
  // compute player movement
  if(keyPressed) {

    if (key == 'a' || key == 'A') {
      player[OBJ_XSPEED] = MIN_SPEED;
    }
    if (key == 'd' || key == 'D') {
      player[OBJ_XSPEED] = MAX_SPEED;
    }
  } else {
      player[OBJ_XSPEED] = 0.0;
  }
  
  // Move player according to current speed
  if(! playerdead) {
    player[OBJ_XPOS] += player[OBJ_XSPEED];
    player[OBJ_YPOS] += player[OBJ_YSPEED];
  }
  
  // whether dead or not, restrict player to game area
  if(player[OBJ_XPOS] < 0+player[OBJ_WIDTH]/2) {
      player[OBJ_XPOS] = 0+player[OBJ_WIDTH]/2;
  }
  if(player[OBJ_XPOS] > width-player[OBJ_WIDTH]/2) {
      player[OBJ_XPOS] = width-player[OBJ_WIDTH]/2;
  }
  
  
  // Draw player
  fill(187, 64, 64, 255);	// default player color (when alive)
  if(playerdead) {
    fill(187, 128, 128, 220);	// make player very transparent and less red if currently dead
  }
  if(playerInvuln) {
    fill(255, 255, 255, 100 + (millis() % 150));	// draw white shield around player if currently invulnerable (animation: flicker shield)
	rect(player[OBJ_XPOS]-5, player[OBJ_YPOS]-5, player[OBJ_WIDTH]+10, player[OBJ_HEIGHT] + 10);
	fill(187, 64, 64, 255);  // set default player color
  }
  rect(player[OBJ_XPOS], player[OBJ_YPOS], player[OBJ_WIDTH], player[OBJ_HEIGHT]);	// actually draw the player
  
  
  
  noStroke();
  
  // Begin looping through enemy array
  for (int j=0;j< streams.length;j++) {
    // Disable shape stroke/border
    noStroke();
  
    // move enemy
    streams[j][OBJ_YPOS] += streams[j][OBJ_YSPEED];
    // make enemies re-enter at the top after leaving at the bottom
    if ( streams[j][OBJ_YPOS] > height+streams[j][OBJ_HEIGHT]) { 
        streams[j][OBJ_YPOS] = -streams[j][OBJ_HEIGHT];
    }
	

    // draw stream
    fill(255, 215, 0, 255);  // gold    
    noStroke();
    rect(streams[j][OBJ_XPOS], streams[j][OBJ_YPOS], streams[j][OBJ_WIDTH], streams[j][OBJ_HEIGHT]);
    
    
	  if ( rectsOverlap(player, streams[j]))  {
	      if(!playerdead) {
		        if(!playerInvuln) {
                  playerKilled();
                }				
	      }
	  }	  	  
   
    
    // Turn off stroke/border
    noStroke();      
   
  }
  
  // print app name and author
  fill(150, 150, 150, 255);  // gray
  textFont(font, 12); 
  text("GoldenShowerDeluxe", 15, 15);
  
  
  // print score in upper right corner
  fill(255, 255, 255, 255); // white
  if(score >= maxScore) {
    fill(255, 30, 30, 255);	// print red if currently setting new max score
  }
  text("Score: " + score + " Highscore: " + maxScore + "", width/2, 15);
  
  
  
  if(score > maxScore) { maxScore = score; }
}
