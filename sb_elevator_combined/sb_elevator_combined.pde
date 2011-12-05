import processing.video.*;

// video settings
// video is brought in via screen capture (see getScreen)
PImage video;
int vWidth = screen.width;
int vHeight = screen.height;
boolean paused = false; // press p to play/pause

// view settings
// move around with w-a-s-d, zoom in/out with +/-
int viewX = 0;
int viewY = 0;
int viewScale = 1;

// pixel trackers
// switch focus with < >
// move the tracker around with i-j-k-l
PixelTracker[] pixelTrackers;
int pixelTrackerTotal = 64;
int pixelTrackerFocus = 0;

void setup() {
  size(320, 240);
  
//  pixelTrackers = new PixelTracker[pixelTrackerTotal];
//  for (int i = 0; i < pixelTrackers.length; i++) {
//    pixelTrackers[i] = (new PixelTracker(100, 100));
//  }
  loadPixelTrackers();
  
  PFont font = loadFont("Monaco-12.vlw"); 
  textFont(font); 
}

void draw() {
    if (!paused) video = getScreen();
    
    copy(video, viewX, viewY, (int) (width/(float) viewScale), (int) (height/(float) viewScale), 0, 0, width, height);
    
    pixelTrackers[pixelTrackerFocus].draw(pixelTrackerFocus, video);
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

