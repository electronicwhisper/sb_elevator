class PixelTracker {
  int x, y;
  PixelTracker (int nx, int ny) {
    x = nx;
    y = ny;
  }
  int getBrightness() {
    // sample the maximum value in a 3x3 area
    int maxBrightness = 0;
    for (int dx = -1; dx <= 1; dx++) {
      for (int dy = -1; dy <= 1; dy++) {
        int pixelColor = video.pixels[(y+dy)*video.width + (x+dx)];
        int bright = (int) green(pixelColor);
        maxBrightness = max(bright, maxBrightness);
      }
    }
    return maxBrightness;
    
    // int pixelColor = video.pixels[y*video.width+x];
    // //return (int) brightness(video.pixels[y*video.width+x]);
    // return (int) green(pixelColor);
  }
  void draw(int i, PImage video) {
    // figure out where the PixelTracker is in the viewport
    int dx = (x - viewX) * viewScale;
    int dy = (y - viewY) * viewScale;
    
    // draw a red rectangle centered on it
    stroke(255,0,0);
    noFill();
    rect(dx-2, dy-2, 5, 5);
    
    // annotate which one we're looking at
    fill(255,255,255);
    text(i, dx+5, dy);
    
    // show the current color
    color c = video.pixels[y*video.width+x];
    stroke(255,255,255);
    fill(c);
    rect(dx-8, dy+8, 16, 16);
    
    // annotate its brightness
    fill(255,255,255);
    text(getBrightness(), dx+12, dy+24);
  }
}
