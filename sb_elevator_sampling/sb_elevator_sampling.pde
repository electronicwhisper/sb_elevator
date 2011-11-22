import processing.video.*;

Movie footage;
boolean playing = false;

void setup() {
  size(720, 480, P2D);
  footage = new Movie(this, "elevator.mov");
  
  footage.jump(2.2);
  footage.read();
}

void draw() {
  image(footage, 0, 0);
  loadPixels();
  
  int x = mouseX - 20;
  int y = mouseY - 20;
  
  if (x >=0 && y >= 0) {
    color currentPixel = pixels[y * width + x];
    
    noStroke();
    fill(currentPixel);
    rect(660, 20, 20, 20);
    
    stroke(255,0,0);
    line(x-5, y, x+5, y);
    line(x, y-5, x, y+5);
  }
}

void mousePressed() {
  int x = mouseX - 20;
  int y = mouseY - 20;
  
  println(y*640 + x);
}

void keyPressed() {
  if (key == ' ') {
    if (playing) {
      footage.pause();
    } else {
      footage.play();
    }
    playing = !playing;
  }
}



void movieEvent(Movie m) {
  m.read();
}
