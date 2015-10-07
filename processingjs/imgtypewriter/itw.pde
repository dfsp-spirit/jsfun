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

var mapping = { "A" : "A.png", "B" : "B.png" };

int posX = 0;
int posY = 0;
var numMappings = getObjectSize(mapping);

// load all the images of the mapping now, so we can quickly use them many times later
PImage[] images = new PImage[numMappings];
PImage img;
int i = 0;
var imagePos = {};
for (var key in mapping) {
  img = loadImage(mapping[key]);
  images[i] = img;
  imagePos.key = i;
}
  

var kmers = splitStringAtInterval(userText, mappingCodeLength);


for (var x = 0; x < kmers.length; x++) {
  String key = kmers[x];
  image(images[imagePos.key], 50, 50);
  posX += 5;
  posY += 5;
}

stroke(255, 0, 0, 255);
line(20, 20, 100, 100);

//save("itw_result.png");
