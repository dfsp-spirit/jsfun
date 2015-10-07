/* 
 Image Typewriter -- write with images in processing.js
 written :by Tim 'spirit' Schaefer, http://rcmd.org/spirit/
 */

size(800, 400);
PFont font;
font = loadFont("DINBold.ttf"); 
textFont(font, 12); 


smooth();
background(240, 240, 240);
strokeWeight(10);

void doLog(string msg) {
    var el = document.getElementById('log');
  var elContent = el.innerHTML;
  el.innerHTML = elContent + msg + "<br />\n";
}


var userText = document.getElementById('usertext').value;
//var mapping = getMapping();

int posX = 0;
int posY = 0;

for (var x = 0; x < userText.length; x++) {
  var c = userText.charAt(x);
  posX += 5;
  posY += 5;
}

stroke(255, 0, 0, 255);
line(20, 20, 100, 100);

//save("itw_result.png");
