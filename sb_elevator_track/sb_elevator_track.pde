import processing.video.*;

Movie footage;
boolean playing = false;

int[] sevenSegments = {181031,181669,184229,186151,185513,182953,183591};

int thresh = 50;

PFont font;


void setup() {
  size(640, 480, P2D);
  footage = new Movie(this, "elevator.mov");
  
  footage.jump(2.2);
  footage.read();
  
  // Name system font and reqd size
  font = createFont("Arial",18);
  textFont(font);
}

void draw() {
  image(footage, 0, 0);
  
  fill(255, 0, 0);
  text(trackFloor(), 530, 290);
}

int trackFloor() {
  loadPixels();
  
  int total = 0;
  int multiplier = 1;
  for (int i = 0; i < 7; i++) {
    color sample = pixels[sevenSegments[i]];
    int b = (int) brightness(sample);
    if (b > thresh) {
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
  println(trackFloor());
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
