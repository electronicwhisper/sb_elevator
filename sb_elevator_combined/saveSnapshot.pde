void saveSnapshot() {
  PImage snap = createImage(video.width, video.height, RGB);
  snap.copy(video, 0, 0, video.width, video.height, 0, 0, video.width, video.height);
  snap.save("data/snapshots/"+minute()+".png");
}
