/* 
 Image Typewriter -- write with images in processing.js
 written :by Tim 'spirit' Schaefer, http://rcmd.org/spirit/
 */

/* @pjs preload="mappings/test/1.png, mappings/test/2.png, mappings/test/3.png, mappings/test/4.png, mappings/test/5.png, mappings/test/6.png, mappings/test/7.png, mappings/test/8.png"; */

size(800, 400);
PFont font;
font = loadFont("DINBold.ttf"); 
textFont(font, 12); 

// a global! omg!
logging = 1;
drawnFrames = 0;

function splitStringAtInterval (string, interval) {
  var result = [];
  for (var i=0; i<string.length; i+=interval) {
    result.push(string.substring (i, i+interval));
  }
  return result;
}

function getObjectSize(myObject) {
  var count=0;
  for (var key in myObject) {
    if(myObject.hasOwnProperty(key)) {
	  count++
	}
  }
  return count;
}

smooth();
background(240, 240, 240);
strokeWeight(10);

void doLog(string msg) {
  if(logging >= 1) {
    var el = document.getElementById('log');
    var elContent = el.innerHTML;
    el.innerHTML = elContent + msg + "<br />\n";
  }
}

var map;
var userText;
var mappingName;
int mappingCodeLength;
var mapping;
var numMappings;
var kmers;
var imagePos;
PImage[] images;
PImage img;

void setup() {
  doLog("Function setup called.");
  // Frame rate
  frameRate(1);
  init();
}

void init() {
  doLog("Function init called.");
  doLog("- loading mapping.");
  mappingName = 'test';
  mappingCodeLength = 1;
  map = {};
  
  mapping = { 
                 "A" : "mappings/test/0.png",
				 "B" : "mappings/test/1.png",
				 "C" : "mappings/test/2.png",
				 "D" : "mappings/test/3.png",
				 "E" : "mappings/test/4.png",
				 "F" : "mappings/test/5.png",
				 "G" : "mappings/test/6.png",
				 "H" : "mappings/test/7.png",
				 "I" : "mappings/test/8.png",
				 "J" : "mappings/test/9.png",
				 "K" : "mappings/test/10.png",
				 "L" : "mappings/test/11.png",
				 "M" : "mappings/test/12.png",
				 "N" : "mappings/test/13.png",
				 "O" : "mappings/test/14.png",
				 "P" : "mappings/test/15.png",
				 "Q" : "mappings/test/16.png",
				 "R" : "mappings/test/17.png",
				 "S" : "mappings/test/18.png",
				 "T" : "mappings/test/19.png",
				 "U" : "mappings/test/20.png",
				 "V" : "mappings/test/21.png",
				 "W" : "mappings/test/22.png",
				 "X" : "mappings/test/23.png",
				 "Y" : "mappings/test/24.png",
				 "Z" : "mappings/test/25.png",
				 "a" : "mappings/test/0.png",
				 "b" : "mappings/test/1.png",
				 "c" : "mappings/test/2.png",
				 "d" : "mappings/test/3.png",
				 "e" : "mappings/test/4.png",
				 "f" : "mappings/test/5.png",
				 "g" : "mappings/test/6.png",
				 "h" : "mappings/test/7.png",
				 "i" : "mappings/test/8.png",
				 "j" : "mappings/test/9.png",
				 "k" : "mappings/test/10.png",
				 "l" : "mappings/test/11.png",
				 "m" : "mappings/test/12.png",
				 "n" : "mappings/test/13.png",
				 "o" : "mappings/test/14.png",
				 "p" : "mappings/test/15.png",
				 "q" : "mappings/test/16.png",
				 "r" : "mappings/test/17.png",
				 "s" : "mappings/test/18.png",
				 "t" : "mappings/test/19.png",
				 "u" : "mappings/test/20.png",
				 "v" : "mappings/test/21.png",
				 "w" : "mappings/test/22.png",
				 "x" : "mappings/test/23.png",
				 "y" : "mappings/test/24.png",
				 "z" : "mappings/test/25.png",
				 " " : "mappings/test/26.png"
				 };
    
  map.mapping = mapping;
  map.name = mappingName;
  numMappings = getObjectSize(mapping);
  doLog("There are " + numMappings + " mappings defined in the mapping table.");

  // load all the images of the mapping now, so we can quickly use them many times later
  images = new PImage[numMappings];
  int i = 0;
  int useless;
  imagePos = {};
  for (var key in mapping) {
    img = requestImage(mapping[key]);  
  
    useless = 0;
    while(img.width == 0) {
      useless++;
      if(useless > 10000) {
        break;
      } 
    }

    img.loadPixels();
    images[i] = img;
    imagePos[key] = i;
    doLog(" - Loaded image '" + mapping[key] + "' for code '" + key + "' into array at position " + i + " (check: " + imagePos.key + "). Image width was " + img.width + ", height was " + img.height + " pixels.");
    i++;
  }
  
  
  

  


  String logMsg = "The imagePos object: ";
  for(var p in imagePos) {
    logMsg += " " + p + "=" + imagePos[p] + "";
  }
  doLog(logMsg);
  
  doLog("- loading usertext.");
  reloadUserText();
  doLog("There are " + kmers.length + " kmers of length " + mappingCodeLength + " in the text of total length " + userText.length + " chars.");
}

void reloadUserText() {
  userText = document.getElementById('usertext').value;
  kmers = splitStringAtInterval(userText, mappingCodeLength);
}

void keyReleased()
{
 if (key=='r') { init(); }
}



//var mapping = getMappingByName(mappingName);
//var mapping = { "A" : "mappings/test/A.png", "B" : "mappings/test/B.png" };
//var mapping = { "A" : "mappings/test/A.png", "B" : "mappings/test/B.png", "C" : "mappings/test/C.png" };
//var numMappings = getObjectSize(mapping);


void draw() {
  doLog("***** Function draw called. *****");
  reloadUserText();
  
  int posX = 50;
  int posY = 50;

  for (var x = 0; x < kmers.length; x++) {
    String key = kmers[x];
    int imgPos = imagePos[key];
    img = images[imgPos];
  
    if(img === undefined) {
	  if(logging >= 2) {
        doLog(" - At kmer number " + x + ", skipping it due to missing image for code '" + key + "'.");
	  }
    }
    else {
      doLog(" - At kmer number " + x + ", checking image mapped to code '" + key + "' from " + imgPos + " at canvas position " + posX + ", " + posY + ". Image width is " + img.width + " pixels.");
      if(img.width > 0) {
        image(img, posX, posY);
        posX += img.width;
        posY += 0;
        doLog(" -- Image drawn, moved canvas position to " + posX + ", " + posY + ". Image width is " + img.width + ", height is " + img.height + " pixels.");
      }
      else {
        doLog(" -- Image skipped, width was zero.");
      }
    }
  }

  // /* @pjs preload="mappings/test/A.png"; */
  //String url = "https://processing.org/img/processing-web.png";
  //img = loadImage(url);
  //img = loadImage("mappings/test/A.png");
  //img = requestImage("mappings/test/A.png");
  //img.loadPixels();
  //image(img, 100, 100);

  stroke(255, 0, 0, 255);
  line(20, 20, 100, 100);

  //save("itw_result.png");
  
  drawnFrames++;
  doLog(" DRAW finished. Drew " + drawnFrames + " frames total so far.");
  
  // stop further drawing, it has to be done manually
  noLoop();
}

// continue drawing if user presses mouse
void mousePressed() {
  loop();
}
