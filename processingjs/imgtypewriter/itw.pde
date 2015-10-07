/* 
 Image Typewriter -- write with images in processing.js
 written :by Tim 'spirit' Schaefer, http://rcmd.org/spirit/
 */

size(800, 400);
PFont font;
font = loadFont("DINBold.ttf"); 
textFont(font, 12); 

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
  var el = document.getElementById('log');
  var elContent = el.innerHTML;
  el.innerHTML = elContent + msg + "<br />\n";
}


var userText = document.getElementById('usertext').value;
var mappingName = 'test';
int mappingCodeLength = 1;
//var mapping = getMappingByName(mappingName);

//var mapping = { "A" : "mappings/test/A.png", "B" : "mappings/test/B.png" };
var mapping = { "A" : "mappings/test/A.png", "B" : "mappings/test/B.png", "C" : "mappings/test/C.png" };


var numMappings = getObjectSize(mapping);

doLog("There are " + numMappings + " mappings defined in the mapping table.");

// load all the images of the mapping now, so we can quickly use them many times later
PImage[] images = new PImage[numMappings];
PImage img;
int i = 0;
var imagePos = {};
for (var key in mapping) {
  img = requestImage(mapping[key]);  
  img.loadPixels();
  
  while(img.width == 0) {
  }
  images[i] = img;
  imagePos.key = i;
  doLog(" - Loaded image '" + mapping[key] + "' for code '" + key + "' into array at position " + i + ". Image width was " + img.width + " pixels.");
  i++;
}
  

var kmers = splitStringAtInterval(userText, mappingCodeLength);

doLog("There are " + kmers.length + " kmers of length " + mappingCodeLength + " in the text of total length " + userText.length + " chars.");

int posX = 50;
int posY = 50;

for (var x = 0; x < kmers.length; x++) {
  String key = kmers[x];
  int imgPos = imagePos.key;
  img = images[imgPos];
  doLog(" - Checking image mapped to '" + key + "' from " + imgPos + " at canvas position " + posX + ", " + posY + ". Image width is " + img.width + " pixels.");
  if(img.width > 0) {
    image(img, posX, posY);
    posX += 20;
    posY += 20;
	doLog(" -- Image drawn, moved canvas position to " + posX + ", " + posY + ". Image width is " + img.width + " pixels.");
  }
  else {
    doLog(" -- Image skipped, width was zero.");
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
