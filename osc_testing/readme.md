# OSC Documentation

I'm using the [oscP5 Processing library](http://www.sojamo.de/libraries/oscP5/).

OSC messages will be sent/received on Port 10240.

OSC messages will have the following format:

For floor change messages,

* Address: /elevator/floor
* First parameter (int): Elevator number (range: 1 to 4)
* Second parameter (int): Floor number (range: 0 to 26, floor 0 is the basement)

For people change messages (i.e. elevator empty/occupied),

* Address: /elevator/people
* First parameter (int): Elevator number (range: 1 to 4)
* Second parameter (int): Occupied (1) or empty (0)

## OSC Simulator/Receiver

To test this protocol, run osc_simulator. This will output a random OSC message every second.

Run osc_receiver. This will receive OSC messages and print them to the console. Your output should look something like,

    OscP5 0.9.6 infos, comments, questions at http://www.sojamo.de/oscP5


    ### [2012/2/8 13:3:31] PROCESS @ OscP5 stopped.
    ### [2012/2/8 13:3:31] PROCESS @ UdpClient.openSocket udp socket initialized.
    ### [2012/2/8 13:3:32] PROCESS @ UdpServer.start() new Unicast DatagramSocket created @ port 10240
    ### [2012/2/8 13:3:32] INFO @ OscP5 is running. you (192.168.2.138) are listening @ port 10240
    ### [2012/2/8 13:3:32] PROCESS @ UdpServer.run() UdpServer is running @ 10240
    Elevator 2 is now on floor 22
    Elevator 2 is empty
    Elevator 4 is occupied
    Elevator 2 is occupied
    Elevator 1 is occupied
    Elevator 3 is now on floor 15
    Elevator 1 is empty
    Elevator 1 is now on floor 3
    Elevator 3 is occupied
    Elevator 3 is occupied
    Elevator 2 is now on floor 12
    ### [2012/2/8 13:3:43] PROCESS @ UdpServer.run()  socket closed.
    ### [2012/2/8 13:3:43] PROCESS @ OscP5 stopped.

To test separate machines, change the `sendAddress` variable in osc_simulator to the IP Address of the receiving machine.