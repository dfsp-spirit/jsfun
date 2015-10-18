/* 
 Image Typewriter -- write with images in processing.js
 written :by Tim 'spirit' Schaefer, http://rcmd.org/spirit/
 */

/* @pjs preload="mappings/test/1.png, mappings/test/2.png, mappings/test/3.png, mappings/test/4.png, mappings/test/5.png, mappings/test/6.png, mappings/test/7.png, mappings/test/8.png"; */




int width = 2400;
int height = 2400;

function updateCanvasWidthFromUserSettings() {
  var user_width = document.getElementById('user_canvas_width').value;
  var user_height = document.getElementById('user_canvas_height').value;
  size(user_width, user_height);
}

size(width, height);
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
var mapping_test;
var mapping_anlaute;
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
  
  mapping_test = { 
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
				 "a" : "mappings/test/26.png",
				 "b" : "mappings/test/27.png",
				 "c" : "mappings/test/28.png",
				 "d" : "mappings/test/29.png",
				 "e" : "mappings/test/30.png",
				 "f" : "mappings/test/31.png",
				 "g" : "mappings/test/32.png",
				 "h" : "mappings/test/33.png",
				 "i" : "mappings/test/34.png",
				 "j" : "mappings/test/35.png",
				 "k" : "mappings/test/36.png",
				 "l" : "mappings/test/37.png",
				 "m" : "mappings/test/38.png",
				 "n" : "mappings/test/39.png",
				 "o" : "mappings/test/40.png",
				 "p" : "mappings/test/41.png",
				 "q" : "mappings/test/42.png",
				 "r" : "mappings/test/43.png",
				 "s" : "mappings/test/44.png",
				 "t" : "mappings/test/45.png",
				 "u" : "mappings/test/46.png",
				 "v" : "mappings/test/47.png",
				 "w" : "mappings/test/48.png",
				 "x" : "mappings/test/49.png",
				 "y" : "mappings/test/50.png",
				 "z" : "mappings/test/51.png",
				 "0" : "mappings/test/52.png",
				 "1" : "mappings/test/53.png",
				 "2" : "mappings/test/54.png",
				 "3" : "mappings/test/55.png",
				 "4" : "mappings/test/56.png",
				 "5" : "mappings/test/57.png",
				 "6" : "mappings/test/58.png",
				 "7" : "mappings/test/59.png",
				 "8" : "mappings/test/60.png",
				 "9" : "mappings/test/61.png",
				 "(" : "mappings/test/62.png",
				 "!" : "mappings/test/63.png",
				 "@" : "mappings/test/64.png",
				 "#" : "mappings/test/65.png",
				 "$" : "mappings/test/66.png",
				 "%" : "mappings/test/67.png",
				 "&" : "mappings/test/68.png",
				 "." : "mappings/test/69.png",
				 "," : "mappings/test/70.png",
				 "?" : "mappings/test/71.png",
				 ":" : "mappings/test/72.png",
				 ";" : "mappings/test/73.png",
				 ")" : "mappings/test/74.png",
				 " " : "mappings/test/75.png"
				 };
				 
  mapping_anlaute = { 
                 "A" : "mappings/anlaute/Ameise.jpg",
				 "a" : "mappings/anlaute/Apfel.jpg",
				 "ä" : "mappings/anlaute/Aepfel.jpg",
				 "Ä" : "mappings/anlaute/Auto.jpg",
				 "B" : "mappings/anlaute/Banane.jpg",
				 "b" : "mappings/anlaute/Banane.jpg",
				 "c" : "mappings/anlaute/Cent.jpg",
				 "C" : "mappings/anlaute/Chamaelion.jpg",
				 "1" : "mappings/anlaute/Chinese.jpg",
				 "2" : "mappings/anlaute/Computer.jpg",
				 "3" : "mappings/anlaute/Computer_Cent.jpg",
				 "D" : "mappings/anlaute/Dino.jpg",
				 "d" : "mappings/anlaute/Dino.jpg",
				 "E" : "mappings/anlaute/Eis.jpg",
				 "e" : "mappings/anlaute/Ente.jpg",
				 "4" : "mappings/anlaute/Esel_Ente.jpg",
				 "5" : "mappings/anlaute/Esel.jpg",
				 "6" : "mappings/anlaute/Eule.jpg",
				 "F" : "mappings/anlaute/Fisch.jpg",
				 "f" : "mappings/anlaute/Fisch.jpg",
				 "G" : "mappings/anlaute/Gabel.jpg",
				 "g" : "mappings/anlaute/Gabel.jpg",
				 "H" : "mappings/anlaute/Hut.jpg",
				 "h" : "mappings/anlaute/Hut.jpg",
				 "I" : "mappings/anlaute/Ich_Dach.jpg",
				 "i" : "mappings/anlaute/Igel.jpg",
				 "7" : "mappings/anlaute/Insel.jpg",
				 "J" : "mappings/anlaute/Jo-Jo.jpg",
				 "j" : "mappings/anlaute/Jo-Jo.jpg",
				 "K" : "mappings/anlaute/Kiwi.jpg",
				 "k" : "mappings/anlaute/Kiwi.jpg",
				 "L" : "mappings/anlaute/Loewe.jpg",
				 "l" : "mappings/anlaute/Loewe.jpg",
				 "M" : "mappings/anlaute/Maus.jpg",
				 "m" : "mappings/anlaute/Maus.jpg",
				 "N" : "mappings/anlaute/Nest.jpg",
				 "n" : "mappings/anlaute/Nest.jpg",
				 "O" : "mappings/anlaute/Ofen.jpg",
				 "o" : "mappings/anlaute/Ordner.jpg",
				 "Ö" : "mappings/anlaute/Oellampe.jpg",
				 "ö" : "mappings/anlaute/Oellampe.jpg",
				 "p" : "mappings/anlaute/Palme.jpg",
				 "P" : "mappings/anlaute/Pfeil.jpg",
				 "Q" : "mappings/anlaute/Qualle.jpg",
				 "q" : "mappings/anlaute/Qualle.jpg",
				 "R" : "mappings/anlaute/Rakete.jpg",
				 "r" : "mappings/anlaute/Rakete.jpg",
				 "s" : "mappings/anlaute/Schere.jpg",
				 "8" : "mappings/anlaute/Sofa.jpg",
				 "9" : "mappings/anlaute/Spinne.jpg",
				 "0" : "mappings/anlaute/Stern.jpg",
				 "t" : "mappings/anlaute/Tisch.jpg",
				 "T" : "mappings/anlaute/Tisch.jpg",
				 "u" : "mappings/anlaute/Ufo.jpg",
				 "U" : "mappings/anlaute/Unterhemd.jpg",
				 "Ü" : "mappings/anlaute/Ueberholverbot.jpg",
				 "ü" : "mappings/anlaute/Ueberholverbot.jpg",
				 "v" : "mappings/anlaute/Vase.jpg",
				 "V" : "mappings/anlaute/Vogel.jpg",
				 "(" : "mappings/anlaute/Vogel_Vase.jpg",
				 "w" : "mappings/anlaute/Wolke.jpg",
				 "W" : "mappings/anlaute/Wolke.jpg",
				 "x" : "mappings/anlaute/Xylophon.jpg",
				 "X" : "mappings/anlaute/Xylophon.jpg",
				 "y" : "mappings/anlaute/Yak.jpg",
				 "Y" : "mappings/anlaute/Yak.jpg",
				 "z" : "mappings/anlaute/Zaun.jpg",
				 "Z" : "mappings/anlaute/Zaun.jpg",
				 " " : "mappings/anlaute/Leeres_Bild.jpg"
				 };
  
  mapping = mapping_anlaute;
  
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
  background(240, 240, 240);
  reloadUserText();
  
  int lineStartX = 50;
  int lineHeight = 0; // will be adjusted based on height of largest image later
  int posX = lineStartX;
  int posY = 50;
  
  int lettersOnThisLine = 0;

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
	   
	    // do we have to start a new line?
		if(posX + img.width > width) {
		  posX = lineStartX;
		  posY = posY + lineHeight; 
		}
	    
		// keep track of the highest image, use it as the line height.
		if(img.height > lineHeight) {
		  lineHeight = img.height;
		}
		
        image(img, posX, posY);
        posX += img.width;
        posY += 0;
		lettersOnThisLine++;
        doLog(" -- Image drawn, moved canvas position to " + posX + ", " + posY + ". Image width is " + img.width + ", height is " + img.height + " pixels. Line has " + lettersOnThisLine + " images so far.");
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

  //stroke(255, 0, 0, 255);
  //line(20, 20, 100, 100);

  //save("itw_result.png");
  
  drawnFrames++;
  doLog(" DRAW finished. Drew " + drawnFrames + " frames total so far.");
  
  // stop further drawing, it has to be done manually
  noLoop();
}

// continue drawing if user presses mouse
void mousePressed() {
  //size(800, 600);
  updateCanvasWidthFromUserSettings();
  loop();
}
