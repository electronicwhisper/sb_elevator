class PixelTracker {
  int x, y;
  PixelTracker (int nx, int ny) {
    x = nx;
    y = ny;
  }
  void draw(int i, Capture video) {
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
    text((int) brightness(c), dx+12, dy+24);
  }
}
