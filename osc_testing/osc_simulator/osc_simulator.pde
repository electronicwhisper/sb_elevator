import oscP5.*;
import netP5.*;

// if not on same machine, change this to the IP of the receiver
String sendAddress = "127.0.0.1";

OscP5 oscP5;
NetAddress myRemoteLocation;

void setup() {
  size(100,100);
  frameRate(25);
  
  oscP5 = new OscP5(this, 10241); // I'm not receiving any messages, but have to specify a port here (I think)
  myRemoteLocation = new NetAddress(sendAddress, 10240);
}

void draw() {
  if (frameCount % 25 == 0) {
    sendRandomMessage();
  }
}

void sendRandomMessage() {
  OscMessage myMessage;
  if (random(2) < 1) {
    myMessage = new OscMessage("/elevator/floor");
    myMessage.add(int(random(1, 5))); // random elevator
    myMessage.add(int(random(0, 27))); // random floor
  } else {
    myMessage = new OscMessage("/elevator/people");
    myMessage.add(int(random(1, 5))); // random elevator
    myMessage.add(int(random(2))); // random people occupied
  }
  oscP5.send(myMessage, myRemoteLocation);
}
