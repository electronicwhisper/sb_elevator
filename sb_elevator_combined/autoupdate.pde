int autoupdateTime = 4; // how often to do the autoupdate, in minutes
int lastAutoupdateTime = -1;
void autoupdate() {
  int m = minute();
  if (m % autoupdateTime == 0) {
    if (m != lastAutoupdateTime) {
      // do an auto update
      saveSnapshot();
      loadPixelTrackers();
      
      lastAutoupdateTime = m;
    }
  }
}
