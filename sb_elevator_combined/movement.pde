int changeThreshold = 60;
int changedPixelsThreshold = 50;

int skip = 10; // this is an optimization: don't look at all the pixels, just look at every (skip) pixels

int [] oldFrame;
void trackMovement(PImage frame) {
  if (oldFrame == null) oldFrame = new int[frame.width*frame.height];
  
  int[] quadrants = {0,0,0,0};
  
  for (int x = 0; x < frame.width; x+=skip) {
    for (int y = 0; y < frame.height; y+=skip) {
      int i = y*frame.width + x;
      
      int diff = (int) abs(brightness(oldFrame[i]) - brightness(frame.pixels[i]));
      if (diff > changeThreshold) {
        // determine the quadrant
        int quadrant = 0;
        if (x > frame.width / 2) quadrant+=1;
        if (y > frame.height / 2) quadrant+=2;
        // log that the pixel changed
        quadrants[quadrant]++;
      }
            
      // update oldFrame
      oldFrame[i] = frame.pixels[i];
    }
  }
  
  for (int i = 0; i < 4; i++) {
    if (quadrants[i] > changedPixelsThreshold) {
      println("Quadrant changed "+i+" "+quadrants[i]+" : "+millis());
    }
  }

}
