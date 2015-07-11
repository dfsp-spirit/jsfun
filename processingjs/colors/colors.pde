size(400, 400);

smooth();

background(255, 255, 255);

strokeWeight(10);

float red = random(50, 200);
float green = random(50, 200);
float blue = random(50, 200);
float x = random(0, width);
float x2 = random(0, width);
float alpha = random(50, 80);
  
for(int i = 0; i < 400; i++) {

  float redshift = random(-20, 20);
  float greenshift = random(-20, 20);
  float blueshift = random(-20, 20);
  
  float newred = red + redshift;
  red = abs((newred > 255 ? 255 - (newred - 255) : newred));
 
  float newgreen = green + greenshift;
  green = abs((newgreen > 255 ? 255 - (newgreen - 255) : newgreen));

  float newblue = blue + blueshift;
  blue = abs((newblue > 255 ? 255 - (newblue - 255) : newblue));
  
  x = random(0, width);
  x2 = random(0, width);
  stroke(red, green, blue, alpha);

  line(x, 0, x2, height);

}