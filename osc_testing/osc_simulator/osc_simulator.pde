import oscP5.*;
import netP5.*;

OscP5 oscP5;
NetAddress myRemoteLocation;

void setup() {
  size(400,400);
  frameRate(25);
  
  oscP5 = new OscP5(this,10241); // I'm not receiving any messages, but have to specify a port here (I think)
  myRemoteLocation = new NetAddress("127.0.0.1", 10240);
}


void draw() {
  background(0);
}

void mousePressed() {
  OscMessage myMessage = new OscMessage("/floor");
  myMessage.add(3);
  myMessage.add(14);
  
  oscP5.send(myMessage, myRemoteLocation);
}

