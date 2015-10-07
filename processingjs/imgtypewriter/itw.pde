/* 
 Image Typewriter -- write with images in processing.js
 written :by Tim 'spirit' Schaefer, http://rcmd.org/spirit/
 */

 // constants for object properties (index in player/enemies array)
size(800, 400);
smooth();
background(240, 240, 240);
strokeWeight(10);

void doLog(string msg) {
    var el = document.getElementById('log');
  var elContent = el.innerHTML;
  el.innerHTML = elContent + msg + "<br />\n";
}


stroke(255, 0, 0, 255);
line(20, 20, 100, 100);
