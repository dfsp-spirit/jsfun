/* 
 Image Typewriter -- write with images in processing.js
 written :by Tim 'spirit' Schaefer, http://rcmd.org/spirit/
 */

/* @pjs preload="mappings/test/A.png,mappings/test/B.png"; */

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
  mapping = { "A" : "mappings/test/A.png", "B" : "mappings/test/B.png", "C" : "mappings/test/C.png" };
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
  doLog(" DRAW finshed. Drew " + drawnFrames + " frames total so far.");
  
  // stop further drawing, it has to be done manually
  noLoop();
}

// continue drawing if user presses mouse
void mousePressed() {
  loop();
}
