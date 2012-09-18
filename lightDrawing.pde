/**
 * Light Drawing
 * by Owen Herterich 
 * 
 * A drawing tool that uses the brightest pixel as a brush.
 *
 * Credit to Golan Levin for his Brightest Pixel tracking example, to which 
 * parts of this code are indebted.
 */

//Import video library
import processing.video.*;

//Load titles and brushes
PImage title1;
PImage title2;
PImage title3;
PImage chalk;
PImage spatter;

boolean start; //Variable used to start/stop drawing
int brushSelect; //Variable used to change between brushes

Capture video; //Needed for webcam video capture

void setup() {
  background(180);
  size(640, 480);

  video = new Capture(this, 160, 120, 30); //Capture video at size 160x120

    noStroke();
  smooth();

  //Load brushes
  chalk = loadImage("chalk.png");
  spatter = loadImage("spatter.png");

  //Load titles
  title1 = loadImage("title1.png");
  title2 = loadImage("title2.png");
  title3 = loadImage("title3.png");

  start = false; //Drawing tool is off at start-up
  brushSelect = 1; //set initial brush
}

void draw() {
  highlightBrush(); //function that determines which brush is selected

  if (video.available()) {
    video.read();
    image(video, width-160, height-120, 160, 120); // Draw the webcam video onto the screen
    float brightestX = 0; // X-coordinate of the brightest video pixel
    float brightestY = 0; // Y-coordinate of the brightest video pixel
    float brightestValue = 0; // Brightness of the brightest video pixel

    video.loadPixels(); //load all pixels in video
    int index = 0;

    if (start == true) { //if drawing tool has been started by user...
      for (int y = 0; y < video.height; y++) { //loop through all pixel values of y
        for (int x = 0; x < video.width; x++) { //loop through all pixel values of x
          // Get the color stored in the pixel
          int pixelValue = video.pixels[index];
          // Determine the brightness of the pixel
          float pixelBrightness = brightness(pixelValue);
          // If that value is brighter than 254, store its x and y values to the brightestX & Y variables
          if (pixelBrightness > brightestValue && pixelBrightness > 254) {
            brightestValue = pixelBrightness;
            float _brightestY = y;
            float _brightestX = 160-x; //subtraction is done in order to correct for camera orientation
            ////to draw on the whole scrreen, the pixel values must be remapped.
            brightestY = map(_brightestY, 0, 120, 0, height); 
            brightestX = map(_brightestX, 0, 160, 0, width);
          }
          index++;
        }
      }

      drawBrushes(brightestX, brightestY); //draw at the location of the brightest pixel
    }
  }
}

//this function determines which brush is selected, and draws it
void drawBrushes(float _brightestX, float _brightestY) {
  fill(0, 128);
  switch(brushSelect) {
  case 1:
    ellipse(_brightestX, _brightestY, 10, 10);
    break;

  case 2:
    tint(255, 128);
    image(chalk, _brightestX, _brightestY);
    break;

  case 3:
    tint(255, 128);
    image(spatter, _brightestX, _brightestY);
    break;
  }
}

//this function determines which brush to highlight at the top
void highlightBrush() {
  switch(brushSelect) {
  case 1:
    image(title1, 0, 0);
    break;
  case 2:
    image(title2, 0, 0);
    break;
  case 3:
    image(title3, 0, 0);
    break;
  }
}

//key presses for starting/stopping the tool, reseting the canvas, and switching between brushes.
void keyPressed() {
  if (keyPressed) {
    if (key == 's') {
      start = !start;
      println(start);
    } 
    if (key == 'r' || key == 'R') {
      fill(180);
      rect(0, 0, width, height);
      println("reset");
    }

    if (key == '1') {
      brushSelect = 1;
      println(brushSelect);
    }

    if (key == '2') {
      brushSelect = 2;
      println(brushSelect);
    }

    if (key == '3') {
      brushSelect = 3;
      println(brushSelect);
    }
  }
}

