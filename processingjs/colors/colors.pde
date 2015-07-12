// processing.js script 'Reflection' by Tim Schaefer
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

int BORDER_TOP = 0;
int BORDER_RIGHT = 1;
int BORDER_BOTTOM = 2;
int BORDER_LEFT = 3;

int numLines = 400;

string bname(int c) {
   if(c == BORDER_TOP) {
       return "TOP";
   }
   else if(c == BORDER_LEFT) {
       return "LEFT";
   }
   else if(c == BORDER_BOTTOM) {
       return "BOTTOM";
   }
   else if(c == BORDER_RIGHT) {
       return "RIGHT";
   }
}

int redshift, greenshift, blueshift;
int canvasCenterX = (int) width / 2;
int canvasCenterY = (int) height / 2;

// maybe we should do this is HSV and only mutate H for better looks?
int mutate_color_channel(int channelValue, int maxShift) {
    int shift = (random(-maxShift, maxShift));
	int val = channelValue;
	int newVal = val + shift;
    return abs((newVal > 255 ? 255 - (newVal - 255) : newVal));
}

// uses Manhattan distance
int get_border_clostest_to(int x, int y) {
    if(x < canvasCenterX) {
	    // left half
	    if(y < canvasCenterY) {
		    // upper left quarter
			int distToTop = y;
			int distToLeft = x;
			return (distToTop < distToLeft ? BORDER_TOP : BORDER_LEFT);
		}
		else {
		    // lower left quarter
			int distToBottom = height - y;
			int distToLeft = x;
			return (distToBottom < distToLeft ? BORDER_BOTTOM : BORDER_LEFT);
		}	    
	}    
	else {
	    // right half
	    if(y < canvasCenterY) {
		    // upper right quarter
			int distToTop = y;
			int distToRight = width - x;
			return (distToTop < distToRight ? BORDER_TOP : BORDER_RIGHT);
		}
		else {
		    // lower right quarter
			int distToBottom = height - y;
			int distToRight = width - x;
			return (distToBottom < distToRight ? BORDER_BOTTOM : BORDER_RIGHT);
		}	
	}
}

int draw_border_but(int current) {
   int newBorder = current;
   while(newBorder == current) {
       newBorder = floor(rand(0, 4));
   }
   return newBorder;
}

void doLog(string msg) {
    var el = document.getElementById('log');
  var elContent = el.innerHTML;
  el.innerHTML = elContent + msg + "<br />\n";
}

int current_border, next_border;

for(int i = 0; i < numLines; i++) {

  // set colors and draw line
  stroke(red, green, blue, alpha);
  line(startx, starty, endx, endy);
  
  // slightly mutate the colors
  red = mutate_color_channel(red, 20);
  green = mutate_color_channel(green, 20);
  blue = mutate_color_channel(blue, 20);
  
  // make the next line start at the end of the last line
  startx = endx;
  starty = endy;
  
  // get border closest to new start point
  current_border = get_border_clostest_to(startx, starty);
  doLog('At iteration ' + i + ', current_border is ' + current_border + ".");
  //next_border = draw_border_but(current_border);
  
  // ... and draw a new random end point
  endx = random(0, width);
  endy = random(0, height);
  

}