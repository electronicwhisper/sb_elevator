boolean debugMode = true;


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
  size(800, 600);
  
//  pixelTrackers = new PixelTracker[64];
//  for (int i = 0; i < pixelTrackers.length; i++) {
//    pixelTrackers[i] = (new PixelTracker(100, 100));
//  }
  loadPixelTrackers();
  
  loadNextSnapshot();
  
  PFont font = loadFont("Monaco-12.vlw"); 
  textFont(font); 
}



void draw() {
  if (debugMode) {
    
  } else {
    if (!paused) {
      video = getScreen();
    }
  }
  
  // draw the video image to the viewport
  copy(video, viewX, viewY, (int) (width/(float) viewScale), (int) (height/(float) viewScale), 0, 0, width, height);

  if (!paused) {
    // do computer vision
    updateElevators();
    trackMovement(video);
    
    if (!debugMode) autoupdate();
  }
    
  // draw the currently selected pixelTracker
  pixelTrackers[pixelTrackerFocus].draw(pixelTrackerFocus, video);
}


int brightnessThreshold = 200;
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
  else if (total == 0) convert = 0;
  else if (total == 0x06) convert = 1;
  else if (total == 0x5b) convert = 2;
  else if (total == 0x4f) convert = 3;
  else if (total == 0x66) convert = 4;
  else if (total == 0x6d) convert = 5;
  else if (total == 0x7d) convert = 6;
  else if (total == 0x07) convert = 7;
  else if (total == 0x7f) convert = 8;
  else if (total == 0x67) convert = 9; // note we use a 9 without a "stem" at the bottom, i.e. not 0x6F
  
  return convert;
}


int[] elevatorFloors = {-1, -1, -1, -1};
void updateElevator(int elevator, int d1, int d2) {
  int e1 = extractSevenSegment(d1);
  int e2 = extractSevenSegment(d2);
  if (e1 != -1 && e2 != -1) {
    int fl = e1 * 10 + e2;
    // check basement
    if (fl == 3 && pixelTrackers[d2 + 7].getBrightness() > brightnessThreshold) {
      fl = 0;
    }
    if (elevatorFloors[elevator] != fl) {
      logFloor(elevator+1, fl);
    }
    elevatorFloors[elevator] = fl;
    // draw the extracted floor to the viewport, for debugging
    int x = pixelTrackers[d1].x;
    int y = pixelTrackers[d1].y;
    int dx = (x - viewX) * viewScale;
    int dy = (y - viewY) * viewScale;
    fill(255,0,0);
    text(fl, dx, dy);
  }
}
void updateElevators() {
  updateElevator(0, 0, 8);
  updateElevator(1, 16, 24);
  updateElevator(2, 32, 40);
  updateElevator(3, 48, 56);
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
  else if (key == 'm') debugMode = !debugMode;
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
  else if (key == 'v') saveSnapshot();
  else if (key == 'n') loadNextSnapshot();
  
  
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










int snapshotNum = -1;
void loadNextSnapshot() {
  String snapshots[] = listFileNames(sketchPath+"/data/snapshots");
  println(snapshots);
  snapshotNum = (snapshotNum + 1) % snapshots.length;
  video = loadImage("data/snapshots/"+snapshots[snapshotNum]);
}




// This function returns all the files in a directory as an array of Strings  
String[] listFileNames(String dir) {
  File file = new File(dir);
  if (file.isDirectory()) {
    String names[] = file.list(new ImageFilenameFilter());
    return names;
  } else {
    // If it's not a directory
    return null;
  }
}

import java.io.*;

/**
 * A class that implements the Java FileFilter interface.
 */
public class ImageFilenameFilter implements FilenameFilter
{
  private final String[] okFileExtensions = 
    new String[] {"jpg", "png", "gif"};

  public boolean accept(File dir, String name)
  {
    for (String extension : okFileExtensions)
    {
      if (name.toLowerCase().endsWith(extension))
      {
        return true;
      }
    }
    return false;
  }
}
