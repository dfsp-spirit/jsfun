/* 
 Image Typewriter -- write with images in processing.js
 written :by Tim 'spirit' Schaefer, http://rcmd.org/spirit/
 */

/* @pjs preload="mappings/test/1.png, mappings/test/2.png, mappings/test/3.png, mappings/test/4.png, mappings/test/5.png, mappings/test/6.png, mappings/test/7.png, mappings/test/8.png"; */




//int width = 1600;
//int height = 1600;
//size(width, height);
var act_width; var act_height;
var act_page_size = "custom";

function updateCanvasWidthFromUserSettings() {
  var user_width = document.getElementById('user_canvas_width').value;
  var user_height = document.getElementById('user_canvas_height').value;
  
  if(document.canvas_size_radio_buttons.canvas_radio[0].checked) {
    act_page_size = "a4h";
    act_width = 1188;
    act_height = 840;
  }
  else if(document.canvas_size_radio_buttons.canvas_radio[1].checked) {
    act_page_size = "a4v";
    act_width = 840;
    act_height = 1188;
  }
  else {
    act_page_size = "custom";
    act_width = user_width;
    act_height = user_height;
  }
  
  size(act_width, act_height);
}

updateCanvasWidthFromUserSettings();


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
background(255, 255, 255);
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
var mapping_server_base_url;
PImage[] images;
PImage img;
var userImageWidth = 0;
var userImageHeight = 0;
var drawWritingLinesInBetweenOtherLines = "";


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
  mapping_server_base_url = "http://rcmd.org/webapps/imgtypewriter/";
  
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
				 "x" : "mappings/anlaute/Xylofon.jpg",
				 "X" : "mappings/anlaute/Xylofon.jpg",
				 "y" : "mappings/anlaute/Yak.jpg",
				 "Y" : "mappings/anlaute/Yak.jpg",
				 "z" : "mappings/anlaute/Zaun.jpg",
				 "Z" : "mappings/anlaute/Zaun.jpg",
				 " " : "mappings/anlaute/Leeres_Bild.jpg"
				 };
				 
   mapping_anlaute2 = { 
                 "a" : "mappings/anlaute2/Apfel.jpg",
				 "A" : "mappings/anlaute2/Apfel.jpg",
				 "ä" : "mappings/anlaute2/Aepfel.jpg",
				 "Ä" : "mappings/anlaute2/Aepfel.jpg",
				 "1" : "mappings/anlaute2/Auto.jpg",
				 "B" : "mappings/anlaute2/Baum.jpg",
				 "b" : "mappings/anlaute2/Baum.jpg",
				 "D" : "mappings/anlaute2/Dino.jpg",
				 "d" : "mappings/anlaute2/Dino.jpg",
				 "2" : "mappings/anlaute2/Eis.jpg",
				 "e" : "mappings/anlaute2/Esel.jpg",
				 "E" : "mappings/anlaute2/Eule.jpg",
				 "F" : "mappings/anlaute2/Fisch.jpg",
				 "f" : "mappings/anlaute2/Fisch.jpg",
				 "G" : "mappings/anlaute2/Gabel.jpg",
				 "g" : "mappings/anlaute2/Gong.jpg",
				 "H" : "mappings/anlaute2/Hut.jpg",
				 "h" : "mappings/anlaute2/Hut.jpg",
				 "I" : "mappings/anlaute2/Ich.jpg",
				 "i" : "mappings/anlaute2/Insel.jpg",
				 "j" : "mappings/anlaute2/Jo-Jo.jpg",
				 "J" : "mappings/anlaute2/Jo-Jo.jpg",
				 "k" : "mappings/anlaute2/Koch.jpg",
				 "K" : "mappings/anlaute2/Koch.jpg",
				 "l" : "mappings/anlaute2/Lampe.jpg",
				 "L" : "mappings/anlaute2/Lampe.jpg",
				 "m" : "mappings/anlaute2/Maus.jpg",
				 "M" : "mappings/anlaute2/Maus.jpg",
				 "n" : "mappings/anlaute2/Nase.jpg",
				 "N" : "mappings/anlaute2/Nase.jpg",
				 "O" : "mappings/anlaute2/Ofen.jpg",
				 "o" : "mappings/anlaute2/Ofen.jpg",
				 "Ö" : "mappings/anlaute2/Oellampe.jpg",
				 "ö" : "mappings/anlaute2/Oellampe.jpg",
				 "p" : "mappings/anlaute2/Paket.jpg",
				 "P" : "mappings/anlaute2/Paket.jpg",
				 "q" : "mappings/anlaute2/Qualle.jpg",
				 "Q" : "mappings/anlaute2/Qualle.jpg",
				 "r" : "mappings/anlaute2/Rakete.jpg",
				 "R" : "mappings/anlaute2/Rakete.jpg",
				 "s" : "mappings/anlaute2/Schaaf.jpg",
				 "S" : "mappings/anlaute2/Sofa.jpg",
				 "3" : "mappings/anlaute2/Spinne.jpg",
				 "4" : "mappings/anlaute2/Stern.jpg",
				 "t" : "mappings/anlaute2/Tisch.jpg",
				 "T" : "mappings/anlaute2/Tisch.jpg",
				 "U" : "mappings/anlaute2/Ufo.jpg",
				 "u" : "mappings/anlaute2/Ufo.jpg",
				 "ü" : "mappings/anlaute2/Ueberholverbot.jpg",
				 "Ü" : "mappings/anlaute2/Ueberholverbot.jpg",
				 "v" : "mappings/anlaute2/VX.jpg",
				 "V" : "mappings/anlaute2/VX.jpg",
				 "w" : "mappings/anlaute2/Wolke.jpg",
				 "W" : "mappings/anlaute2/Wolke.jpg",
				 "y" : "mappings/anlaute2/YC.jpg",
				 "Y" : "mappings/anlaute2/YC.jpg",
				 "Z" : "mappings/anlaute2/Zirkus.jpg",
				 "z" : "mappings/anlaute2/Zirkus.jpg",
				 " " : "mappings/anlaute2/Leeres_Bild.jpg"
				 };
  

  // Use the mapping selected in the box. Note that we need to reload this when the selection in the box changes.
  var selMapU = document.getElementById("mapping_preset_select");
  var selectedMapping = selMapU.options[selMapU.selectedIndex].value;
  
  mapping = mapping_test; // default mapping
  if(selectedMapping == "anlaute") { mapping = mapping_anlaute; }
  else if(selectedMapping == "anlaute2") { mapping = mapping_anlaute2; }
  
  
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
  
    //useless = 0;
    //while(img.width == 0) {
    //  useless++;
    //  if(useless > 10000) {
    //    break;
    //  } 
    //}

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
  reloadAdvancedSettings();
  doLog("There are " + kmers.length + " kmers of length " + mappingCodeLength + " in the text of total length " + userText.length + " chars.");
}



void reloadAdvancedSettings() {
  userImageWidth = document.getElementById('user_image_width').value;
  userImageHeight = document.getElementById('user_image_height').value;
  drawWritingLinesInBetweenOtherLines = document.getElementById('checkbox_draw_lines').checked;
}

void reloadUserText() {
  userText = document.getElementById('usertext').value;
  // special handling for newline characters: they have to be treated as a kmer, i.e., extended to the current value of keep
  int numSpacesToAdd = (mappingCodeLength > 1 ? mappingCodeLength - 1 : 0);
  var spacesText = "";
  if(numSpacesToAdd > 0) {
    spacesText = Array(numSpacesToAdd + 1).join(" ");
  }
  userText = userText.replace(/(?:\r\n|\r|\n)/g, "\n" + spacesText);

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
  background(255, 255, 255);
  reloadUserText();
  reloadAdvancedSettings();
  
  int lineStartX = 50;
  int lineHeight = 0; // line height of the image lines. will be adjusted based on height of largest image later.
  int lineHeightWritingLine = 0;
  int minimumLineHeight = 50;  // the minimal line height (also applies to height of empty lines). set to zero to ignore if the user presses RETURN in the input field.
  int lastImageWidth = 0;   // y position of base writing line in the LAST line
  drawWritingLinesInBetweenOtherLines = document.getElementById('checkbox_draw_lines').checked;
  var nl = 0; var ld;
  
  // check writing lines and suggest a height for them (only possible for known output size of images, e.g., DIN A4 horizontal)
  if(document.writing_lines_radio_buttons.lines_radio[0].checked) { // auto
    nl = 4;
    var totalLineHeight;	// try to suggest a line height that fits for A4 vertical or horizontal format, if one of these is selected
    if(act_page_size == "a4v") { // line height was measured and should be 1.8 cm, this is roughly 9 % of vertical A4 page
      totalLineHeight = act_height * 0.09;
      doLog("Auto line height selected for A4 vertical. Page height = " + act_height + " px, line height = " + totalLineHeight + " px.");
    } else if(act_page_size == "a4h") {  // line height was measured and should be 1.8 cm, this is roughly 6 % of horizontal A4 page
      totalLineHeight = act_height * 0.06;
      doLog("Auto line height selected for A4 horizontal. Page height = " + act_height + " px, line height = " + totalLineHeight + " px.");
    } else {
      totalLineHeight = act_height * 0.10; // suggest 10 % for custom page. most likely it will be smaller than A4. wild guessing only ofc, user needs to change this.
      doLog("Auto line height selected for custom format. Page height = " + act_height + " px, line height = " + totalLineHeight + " px.");
    }
    
    // now compute the distance between the 4 lines based on the total line height
    ld = totalLineHeight / 3;
  }
  else if(document.writing_lines_radio_buttons.lines_radio[1].checked) { // user custom settings
    nl = document.getElementById('user_num_writing_lines').value;          // number of lines
    ld = document.getElementById('user_writing_lines_dist').value;         // line distance
  }
  
  lineHeight = minimumLineHeight;
  
  int posX = lineStartX;
  int posY = 50;
  
  int lettersOnThisLine = 0;
  int numLinesDrawn = 0;  // during this call to draw


  for (var x = 0; x < kmers.length; x++) {
    String key = kmers[x];
	
	// special handling of newline characters: add a new line, ignore the rest of the kmer (note that newlines have been extended to the length of k before, by adding spaces if k > 1)
	if(key[0] == "\n") {
	
	  // yes, but we may need to close the drawing lines on this one first! Note though that the actual lines are the lines from the LAST image. They were already drawn in the last iteration
		  // (but then we didn't know yet that it was the last image on the line -- because this depends on the width of the current image). So we have to add the
		  // closing of the last lines now.
		  if(drawWritingLinesInBetweenOtherLines) {
		    doLog(" * #########Manual line break: Checking whether we need to close lines on the RIGHT...############");
		    if(document.getElementById('checkbox_close_draw_lines_right').checked && nl > 1) {  // only close of asked to, and there are more than 1 lines
			  if(lettersOnThisLine > 0) {      // no need to close lines if there aren't chars, and thus no lines
			    //if(lastImageWidth > 0) {
				  doLog(" * Manual line break: Close lines on the RIGHT...YES");
				  int firstLineYPos =  posY + lineHeight + (lineHeight / 2);
				  line(posX, firstLineYPos, posX, firstLineYPos - ((nl - 1) * ld)); // draw a line upwards from the start of the first line, on the very left
				//}
				//else {
				//  doLog(" * Manual line break: Close lines on the RIGHT...NO (lastImageWidth = " + lastImageWidth + ".)");
				//}
			  }
			}	        
		  }
	  
	  posX = lineStartX;
	  posY = posY + lineHeight;
	  if(drawWritingLinesInBetweenOtherLines) {
		    posY = posY + lineHeight;
		  }
      lettersOnThisLine = 0;
	}
	
    int imgPos = imagePos[key];
    img = images[imgPos];
  
    if(img === undefined) {
	  lastImageWidth = 0;
	  if(logging >= 2) {
        doLog(" - At kmer number " + x + ", skipping it due to missing image for code '" + key + "'.");
	  }
    }
    else {
      doLog(" - At kmer number " + x + ", checking image mapped to code '" + key + "' from " + imgPos + " at canvas position " + posX + ", " + posY + ". Image width is " + img.width + " pixels.");
      if(img.width > 0) {
	   
	    // rescale image if requested by user
		if(userImageWidth > 0 || userImageHeight > 0) {
		  
		  // we need to take special precautions if one of the values is zero
		  if(userImageWidth == 0 || userImageHeight == 0) {
		    var scaling;
		    if(userImageHeight == 0) {
			  scaling = userImageWidth / img.width;
			  userImageHeight = img.height * scaling;
			  if(logging >= 1) {
                doLog(" * Adjusted user image height of zero to " + userImageHeight + ".");
	          }
			}
			
			if(userImageWidth == 0) {
			  scaling = userImageHeight / img.height;
			  userImageWidth = img.width * scaling;
			  if(logging >= 1) {
                doLog(" * Adjusted user image width of zero to " + userImageWidth + ".");
	          }
			}
		  }
		  
		  if(logging >= 1) {
            doLog(" * Resizing image to " + userImageWidth + "x" + userImageHeight + " by user request in advanced settings.");
	      }
		  img.resize(userImageWidth, userImageHeight);
		}
		
	   
	    
		strokeWeight(1); stroke(0);
	   
	    // do we have to start a new line?
		if(posX + img.width > width) {
		
		  // yes, but we may need to close the drawing lines on this one first! Note though that the actual lines are the lines from the LAST image. They were already drawn in the last iteration
		  // (but then we didn't know yet that it was the last image on the line -- because this depends on the width of the current image). So we have to add the
		  // closing of the last lines now.
		  if(drawWritingLinesInBetweenOtherLines) {
		    doLog(" * Checking whether we need to close lines on the RIGHT...");
		    if(document.getElementById('checkbox_close_draw_lines_right').checked && nl > 1) {  // only close of asked to, and there are more than 1 lines
			  if(lettersOnThisLine > 0) {      // no need to close lines if there aren't chars, and thus no lines
			    if(lastImageWidth > 0) {
				  doLog(" * Close lines on the RIGHT...YES");
				  int firstLineYPos =  posY + lineHeight + (lineHeight / 2);
				  line(posX, firstLineYPos, posX, firstLineYPos - ((nl - 1) * ld)); // draw a line upwards from the start of the first line, on the very left
				}
			  }
			}	        
		  }
		  
		  posX = lineStartX;
		  posY = posY + lineHeight;
		  if(drawWritingLinesInBetweenOtherLines) {
		    posY = posY + lineHeight;
		  }
		  
		  
          lettersOnThisLine = 0;		  
		}
	    
		// keep track of the highest image, use it as the line height.
		if(img.height > lineHeight) {
		  lineHeight = img.height;
		}			
		
        image(img, posX, posY);
	if(drawWritingLinesInBetweenOtherLines) {
	  doLog(" * Drawing the writing line below image.");
	  if(nl > 0) {
	    int firstLineYPos =  posY + lineHeight + (lineHeight / 2);
	    for(int l = 0; l < nl; l++) {
	      int yLinePos = firstLineYPos - (l * ld);
	      line(posX, yLinePos, posX + img.width, yLinePos);
	    }
		
		// we may need to close lines
		if(document.getElementById('checkbox_close_draw_lines_left').checked && nl > 1) {
		  // close the first line element in a line ON THE LEFT
		  if(lettersOnThisLine == 0) {
		    line(posX, firstLineYPos, posX, firstLineYPos - ((nl - 1) * ld)); // draw a line upwards from the start of the first line, on the very left
		  }
		  // close the one on the last line -- if any -- on the right
		}
	  }
	}
        posX += img.width;
		lastImageWidth = img.width;
        posY += 0;	// no need to change y pos here, new lines have already been handled
		lettersOnThisLine++;
        doLog(" -- Image drawn, moved canvas position to " + posX + ", " + posY + ". Image width is " + img.width + ", height is " + img.height + " pixels. Line has " + lettersOnThisLine + " images so far.");		
      }
      else {
        doLog(" -- Image skipped, width was zero.");
		lastImageWidth = 0;
      }	  
    }
	// keep track of the width for closing lines next iteration (if needed)	
	doLog(" * Saved image width of " + lastImageWidth + " for next iteration.");
	numLinesDrawn++;
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
