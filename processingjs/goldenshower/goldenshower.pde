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
float MAX_SPEED_DRUNK = 8.0;
float MIN_SPEED_DRUNK = -8.0;


int fps = 25;  // frames per second
int numStreams = 15;
int numBeers = 2;

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

function Point2D(int x, int y) {
  this.x = x;
  this.y = y;
}

void doLog(string msg) {
    var el = document.getElementById('log');
  var elContent = el.innerHTML;
  el.innerHTML = elContent + msg + "<br />\n";
}

float[] player = new float[6];
float[][] streams = new float[numStreams][6];
float[][] beers = new float[numBeers][6];

// handling of player death
boolean playerdead = false;
int waitFramesOnDeath = fps * 3;
int waitedFramesSinceDeath;

boolean playerInvuln = false;	// player is invulnerable for a short time after dying
int waitFramesInvuln = fps * 3;
int waitedFramesInvuln = 0;

boolean playerDrunk = false;	// player is drunk when picking up beer. gives speed and score boost for limited time.
int waitFramesDrunk = fps * 3;
int waitedFramesDrunk = 0;

int playerBorderYBottom;
boolean pressingmouse = false;

// If user presses mouse...
void mousePressed () {
    pressingmouse = true;
}

// If user releases mouse...
void mouseReleased() {
  pressingmouse = false;
}


function resetPlayer() {
  player[OBJ_WIDTH] = 30;
  player[OBJ_HEIGHT] = 20;
  player[OBJ_XSPEED] = 0;
  player[OBJ_YSPEED] = 0;
  player[OBJ_XPOS] = width/2;
  player[OBJ_YPOS] = playerBorderYBottom - player[OBJ_HEIGHT];
  playerDrunk = false;
}

function generateEnemies() {
    for(int j=0; j < numStreams; j++) {
        streams[j][OBJ_XPOS] = random(0,width-10);
        streams[j][OBJ_YPOS] = random(0,height) - height/2;
        streams[j][OBJ_WIDTH] = 10;
        streams[j][OBJ_HEIGHT] = random(50,80);
        streams[j][OBJ_XSPEED] = 0;
        streams[j][OBJ_YSPEED] = random(5.5,8.0);
    }
}

function generateBeer() {
    for(int j=0; j < numBeers; j++) {
        beers[j][OBJ_WIDTH] = 20;
        beers[j][OBJ_XPOS] = random(0,width - beers[j][OBJ_WIDTH]/2);
        beers[j][OBJ_YPOS] = random(0,height) - height/2;
        beers[j][OBJ_HEIGHT] = 35;
        beers[j][OBJ_XSPEED] = 0;
        beers[j][OBJ_YSPEED] = random(3.5,7.0);
    }
}

// Set up canvas
void setup() {
  // Frame rate
  frameRate(fps);
  // Size of canvas (width,height)
  size(400, 500);
  playerBorderYBottom = height -20;
  
  // place player
  resetPlayer();
  
  // generate enemies
  generateEnemies();
  
  // generate beer
  generateBeer();
}

boolean crashedThisFrame = false;

function playerKilled() {
  playerdead = true;
  waitedFramesSinceDeath = 0;
}

// checks whether the 2 rectangular objects overlap (collision detection)
function rectsOverlap(float[] rect1, float[] rect2) {
    if (rect1[OBJ_XPOS] < rect2[OBJ_XPOS] + rect2[OBJ_WIDTH] &&
        rect1[OBJ_XPOS] + rect1[OBJ_WIDTH] > rect2[OBJ_XPOS] &&
        rect1[OBJ_YPOS] < rect2[OBJ_YPOS] + rect2[OBJ_HEIGHT] &&
        rect1[OBJ_HEIGHT] + rect1[OBJ_YPOS] > rect2[OBJ_YPOS]) {
          return true;
    }
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
  
  // check whether we need to disable invulnerability again (some time after death)
  if(playerDrunk) {
    waitedFramesDrunk++;
	if(waitedFramesDrunk > waitFramesDrunk) {
	  playerDrunk = false;
	  waitedFramesDrunk = 0;
	  player[OBJ_WIDTH] = 30;
	}
  }
  
  // draw lower borders / ground
  //fill(80, 80, 80, 255);
  //rect(0, playerBorderYBottom, width, 20);
  
  // compute player movement
  if(keyPressed) {

    if (key == 'a' || key == 'A') {
      player[OBJ_XSPEED] = (playerDrunk ? MIN_SPEED_DRUNK : MIN_SPEED);
    }
    if (key == 'd' || key == 'D') {
      player[OBJ_XSPEED] = (playerDrunk ? MAX_SPEED_DRUNK : MAX_SPEED);
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
  if(playerDrunk) {
    fill(100, 100, 256, 255);	// make player more blue if drunk
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
  
  // Begin looping through beer array
  for (int j=0;j< beers.length;j++) {
    // Disable shape stroke/border
    noStroke();
  
    // move beer
    beers[j][OBJ_YPOS] += beers[j][OBJ_YSPEED];
    // make beer re-enter at the top after leaving at the bottom
    if ( beers[j][OBJ_YPOS] > height+beers[j][OBJ_HEIGHT]) { 
        beers[j][OBJ_YPOS] = -(beers[j][OBJ_HEIGHT] + random(0,40));
        beers[j][OBJ_XPOS] = random(0,width - beers[j][OBJ_WIDTH]);
    }
	

    // draw beer
    fill(100, 255, 100, 255);  // green    
    noStroke();
    rect(beers[j][OBJ_XPOS], beers[j][OBJ_YPOS], beers[j][OBJ_WIDTH], beers[j][OBJ_HEIGHT]);
    fill(50, 200, 50, 255);  // green for label sticker
    rect(beers[j][OBJ_XPOS], beers[j][OBJ_YPOS]+5, beers[j][OBJ_WIDTH], 20);
    fill(220, 220, 220, 255);  // gray for top/bottom of tin
    rect(beers[j][OBJ_XPOS], beers[j][OBJ_YPOS], beers[j][OBJ_WIDTH], 2); // top
    rect(beers[j][OBJ_XPOS], beers[j][OBJ_YPOS]+beers[j][OBJ_HEIGHT]-2, beers[j][OBJ_WIDTH], 2); // bottom
    
    
    if ( rectsOverlap(player, beers[j]))  {
        score += 500;
		playerDrunk = true;
		player[OBJ_WIDTH] = 10;	// player gets thinner and faster while drunk
		waitedFramesDrunk = 0;
        beers[j][OBJ_YPOS] = -(beers[j][OBJ_HEIGHT] + random(20,50));
        beers[j][OBJ_XPOS] = random(0,width - beers[j][OBJ_WIDTH]);
    }	  	  
    // Turn off stroke/border
    noStroke();      
  }
  
  // print app name and author
  fill(150, 150, 150, 255);  // gray
  textFont(font, 12); 
  text("GoldenShowerDeluxe", 15, 15);
  text("Use the 'a' and 'd' keys to evade piss and catch beers.", 15, 30);
  
  score++;
  if(playerDrunk) {
	score++;	// double score per frame when drunk
  }
  
  // print score in upper right corner
  fill(255, 255, 255, 255); // white
  if(score >= maxScore) {
    fill(255, 30, 30, 255);	// print red if currently setting new max score
  }
  text("Score: " + score + " Highscore: " + maxScore + "", width/2, 15);
  
  
  
  if(score > maxScore) { maxScore = score; }
}
