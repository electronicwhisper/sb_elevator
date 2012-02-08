import oscP5.*;
import netP5.*;

// if not on same machine, change this to the IP of the receiver
String sendAddress = "192.168.2.138";

OscP5 oscP5;
NetAddress myRemoteLocation;


// this could be more general, but all messages happen to be of the form sending 2 ints.
void oscSend(String address, int p1, int p2) {
  if (oscP5 == null) oscP5 = new OscP5(this, 10241); // I'm not receiving any messages, but have to specify a port here (I think)
  if (myRemoteLocation == null) myRemoteLocation = new NetAddress(sendAddress, 10240);
  
  OscMessage myMessage = new OscMessage(address);
  myMessage.add(p1);
  myMessage.add(p2);
  oscP5.send(myMessage, myRemoteLocation);
}
