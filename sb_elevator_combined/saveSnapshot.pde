void saveSnapshot() {
  PImage snap = createImage(video.width, video.height, RGB);
  snap.copy(video, 0, 0, video.width, video.height, 0, 0, video.width, video.height);
  snap.save("data/snapshots/"+minute()+".png");
}

int autoSnapshotTime = 4; // how often to take a snapshot, in minutes
int lastSnapshotTime = -1;
void autoSnapshot() {
  int m = minute();
  if (m % autoSnapshotTime == 0) {
    if (m != lastSnapshotTime) {
      saveSnapshot();
      lastSnapshotTime = m;
    }
  }
}
