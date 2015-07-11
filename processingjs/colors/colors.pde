size(800, 400);

smooth();

background(255, 255, 255);

strokeWeight(10);

int red = random(50, 200);
int green = random(50, 200);
int blue = random(50, 200);
int alpha = random(50, 80);

int TOP = 0;
int RIGHT = width;
int LEFT = 0;
int BOTTOM = height;

int startx = random(0, width);
int starty = TOP;
int endx = random(0, width);
int endy = BOTTOM;

int numLines = 400;

int redshift, greenshift, blueshift;
  
for(int i = 0; i < numLines; i++) {

  // set colors and draw line
  stroke(red, green, blue, alpha);
  line(startx, starty, endx, endy);
  
  // slighlty mutate the colors
  redshift = random(-20, 20);
  greenshift = random(-20, 20);
  blueshift = random(-20, 20);
  
  int newred = red + redshift;
  red = abs((newred > 255 ? 255 - (newred - 255) : newred));
 
  int newgreen = green + greenshift;
  green = abs((newgreen > 255 ? 255 - (newgreen - 255) : newgreen));

  int newblue = blue + blueshift;
  blue = abs((newblue > 255 ? 255 - (newblue - 255) : newblue));
  
  // make the next line start at the end of the last line, and draw a random end point
  startx = endx;
  starty = endy;
  endx = random(0, width);
  endy = random(0, height);
  

}