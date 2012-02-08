import oscP5.*;
import netP5.*;

OscP5 oscP5;

void setup() {
  size(100,100);
  frameRate(25);
  
  /* start oscP5, listening for incoming messages at port 10240 */
  oscP5 = new OscP5(this, 10240);
}

void draw() {
}

/* incoming osc message are forwarded to the oscEvent method. */
void oscEvent(OscMessage msg) {
  if (msg.addrPattern().equals("/elevator/floor")) {
    int elevator = msg.get(0).intValue();
    int floorNumber = msg.get(1).intValue();
    println("Elevator "+elevator+" is now on floor "+floorNumber);
  } else if (msg.addrPattern().equals("/elevator/people")) {
    int elevator = msg.get(0).intValue();
    int people = msg.get(1).intValue();
    if (people == 0) {
      println("Elevator "+elevator+" is empty");
    } else {
      println("Elevator "+elevator+" is occupied");
    }
  }
}
