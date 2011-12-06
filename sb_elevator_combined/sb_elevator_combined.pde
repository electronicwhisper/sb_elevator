
// video settings
// video image is brought in via screen capture (see getScreen)
PImage video;
int vWidth = screen.width;
int vHeight = screen.height;
boolean paused = false; // toggle play/pause with p

// view settings
// move around with w-a-s-d, zoom in/out with +/-
int viewX = 0;
int viewY = 0;
int viewScale = 1;

// pixel trackers
// switch focus with < >
// move the tracker around with i-j-k-l
// move the tracker to the center of the viewport with c
// save all the trackers with z
PixelTracker[] pixelTrackers;
int pixelTrackerFocus = 0;



void setup() {
  size(320, 240);
  
//  pixelTrackers = new PixelTracker[64];
//  for (int i = 0; i < pixelTrackers.length; i++) {
//    pixelTrackers[i] = (new PixelTracker(100, 100));
//  }
  loadPixelTrackers();
  
  PFont font = loadFont("Monaco-12.vlw"); 
  textFont(font); 
}



void draw() {
    if (!paused) video = getScreen();
    
    // draw the video image to the viewport
    copy(video, viewX, viewY, (int) (width/(float) viewScale), (int) (height/(float) viewScale), 0, 0, width, height);
    
    // draw the currently selected pixelTracker
    pixelTrackers[pixelTrackerFocus].draw(pixelTrackerFocus, video);
}


int brightnessThreshold = 220;
int extractSevenSegment(int start) {
  // extracts a seven segment display looking at pixelTrackers starting at index start
  
  // go through the PixelTracker's, testing brightness, accumulating a binary representation of the seven-segment
  // http://en.wikipedia.org/wiki/Seven-segment_display#Numbers_to_7-segment-code
  int total = 0, multiplier = 1;
  for (int i = start; i < start+7; i++) {
    if (pixelTrackers[i].getBrightness() > brightnessThreshold) {
      total += multiplier;
    }
    multiplier *= 2;
  }
  
  int convert = -1;
  if (total == 0x3f) convert = 0;
  else if (total == 0x06) convert = 1;
  else if (total == 0x5b) convert = 2;
  else if (total == 0x4f) convert = 3;
  else if (total == 0x66) convert = 4;
  else if (total == 0x6d) convert = 5;
  else if (total == 0x7d) convert = 6;
  else if (total == 0x07) convert = 7;
  else if (total == 0x7f) convert = 8;
  else if (total == 0x6f) convert = 9;
  
  return convert;
}



void mousePressed() {
  // report the seven segments
  println("");
  println("elevator 1: " + extractSevenSegment(0) + " " + extractSevenSegment(8));
  println("elevator 2: " + extractSevenSegment(16) + " " + extractSevenSegment(24));
  println("elevator 3: " + extractSevenSegment(32) + " " + extractSevenSegment(40));
  println("elevator 4: " + extractSevenSegment(48) + " " + extractSevenSegment(56));
  
}



void keyTyped() {
  if (key == 'p') paused = !paused;
  else if (key == 'w') viewY-=4;
  else if (key == 's') viewY+=4;
  else if (key == 'a') viewX-=4;
  else if (key == 'd') viewX+=4;
  else if (key == '=') viewScale+=1;
  else if (key == '-') viewScale-=1;
  else if (key == ',') pixelTrackerFocus--;
  else if (key == '.') pixelTrackerFocus++;
  else if (key == 'i') pixelTrackers[pixelTrackerFocus].y--;
  else if (key == 'k') pixelTrackers[pixelTrackerFocus].y++;
  else if (key == 'j') pixelTrackers[pixelTrackerFocus].x--;
  else if (key == 'l') pixelTrackers[pixelTrackerFocus].x++;
  else if (key == 'c') {
    int x = viewX + (int) (width/(float) viewScale/2.0);
    int y = viewY + (int) (height/(float) viewScale/2.0);
    pixelTrackers[pixelTrackerFocus].x = x;
    pixelTrackers[pixelTrackerFocus].y = y;
  }
  else if (key == 'z') savePixelTrackers();
  
  
  // constrain view
  viewScale = constrain(viewScale, 1, 6);
  viewX = constrain(viewX, 0, vWidth - (int) (width/(float) viewScale));
  viewY = constrain(viewY, 0, vHeight - (int) (height/(float) viewScale));
  
  // constrain pixelTrackerFocus
  pixelTrackerFocus = (pixelTrackerFocus + pixelTrackers.length) % pixelTrackers.length;
}



void savePixelTrackers() {
  String[] output = new String[pixelTrackers.length];
  for (int i = 0; i < pixelTrackers.length; i++) {
    output[i] = pixelTrackers[i].x + "," + pixelTrackers[i].y;
  }
  saveStrings("data/pixelTrackers.txt", output);
}

void loadPixelTrackers() {
  String[] input = loadStrings("data/pixelTrackers.txt");
  pixelTrackers = new PixelTracker[input.length];
  for (int i = 0; i < input.length; i++) {
    int[] coords = int(split(input[i], ','));
    pixelTrackers[i] = new PixelTracker(coords[0], coords[1]);
  }
}

