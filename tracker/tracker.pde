//Import libraries
// import processing.serial.*;
import controlP5.*;
import websockets.*;


void settings() {
  //Set size of window
  size(1440, 780);
}

void setup() {
  cp5 = new ControlP5(this);

  //Initalise font
  PFont font = createFont("arial", 25);

  /* UNCOMMENT TO USE SERIAL PORT METHOD INSTEAD OF AWS
   portName = Serial.list()[0];
   printArray(Serial.list());
   myPort = new Serial(this, portName, 115200);
   */

  ball[0] = loadImage(FIG_PATH + "/Soccer.png");
  ball[1] = loadImage(FIG_PATH + "/AFLBall.png");
  ball[2] = loadImage(FIG_PATH + "/CricketBall.png");

  //Add Ireland and Australia to stadiums array
  stadiums[0] = "Dalymount Park";
  stadiums[1] = "Marvel Stadium";
  stadiums[2] = "Melbourne Cricket Ground";

  //Add a cp5 button to start the program
  cp5.addButton("start")
    .setPosition(670, 650)
    .setSize(100, 50)
    .setLabel("Start")
    .setFont(font);

  //Load dropdown list
  cp5.addScrollableList("Stadium Selector:")
    .setPosition(220, 340)
    .setSize(1000, 1000)
    .setBarHeight(75)
    .setItemHeight(65)
    .setFont(font)
    .addItems(stadiums);

  // load images in setup
  images[0] = loadImage(FIG_PATH + "/Ireland.png"); // note: arrays start at zero!
  images[1] = loadImage(FIG_PATH + "/Australia.png");
  images[2] = loadImage(FIG_PATH + "/Cricket.png");

  time = millis();
  possession = 66;
  pass = 0;
  receive = 0;
  home = 0;
  away = 0;
  out = 0;
  submit = false;
  timestamp = 0;
  int time = millis();
  bg = loadImage(FIG_PATH + "/Background.png");

  frameRate(60);
  textFont(font);
}

void draw() {
  //font size 30
  textSize(30);
  background(bg);

  //Add cp5 dropdown menu to select stadium of AWS server.
  if (submit == false) {
    if (cp5.getController("Stadium Selector:").getValue() == 0) {
      selectedImage = 0;
      stadium = DALYMOUNT_PARK;
      wsc = new WebsocketClient(this, stadium);
    } else if (cp5.getController("Stadium Selector:").getValue() == 1) {
      selectedImage = 1;
      stadium = MARVEL_STADIUM;
      wsc = new WebsocketClient(this, stadium);
    } else if (cp5.getController("Stadium Selector:").getValue() == 2) {
      selectedImage = 2;
      stadium = MELBOURNE_CRICKET_GROUND;
      wsc = new WebsocketClient(this, stadium);
    }
  }

  if (submit == true) {
    imageMode(CORNER);
    image(images[selectedImage], 0, 0, width, height);
    imageMode(CENTER);
    image(ball[selectedImage], mouseX, mouseY);
  }
  textSize(20);

  //Instructions on screen
  if (submit) {
    text("Hold Left Click - Possession", 50, 30);
    text("Press 'A' - Pass", 50, 55);
    text("Press 'D' - Receive", 50, 80);
    text("Press '1' - Ball Out", 50, 105);
    text("Press '2' - Home Goal", 50, 130);
    text("Press '3' - Away Goal", 50, 155);
  }

  //Everything within this if statement occurs every 0.125 seconds and sends the information to the AWS server.
  if (millis() > time + 125 && submit == true) {

    //Put all information into one string
    //if stadium is ireland
    if (stadium == DALYMOUNT_PARK) {
      json = ("{\"action\": \"irelandSendMessage\", \"message\": {\"Timestamp\":" + timestamp + "," + "\"X\":" + mouseX/15 + "," + "\"Y\":" + mouseY/15 + "," + "\"Possession\":" + possession + "," + "\"Pass\":" + pass + "," + "\"Receive\":" + receive + "," + "\"home goal\":" + home + "," + "\"away goal\":" + away + "," + "\"Out\":" + out + "}}");
    }
    //if stadium is australia
    else if (stadium == MARVEL_STADIUM) {
      json = ("{\"action\": \"marvel_AUS_sendMessage\", \"message\": {\"Timestamp\":" + timestamp + "," + "\"X\":" + mouseX/15 + "," + "\"Y\":" + mouseY/15 + "," + "\"Possession\":" + possession + "," + "\"Pass\":" + pass + "," + "\"Receive\":" + receive + "," + "\"home goal\":" + home + "," + "\"away goal\":" + away + "," + "\"Out\":" + out + "}}");    
    }
    //if stadium is cricket
    else if (stadium == MELBOURNE_CRICKET_GROUND) {
      json = ("{\"action\": \"mcg_AUS_sendMessage\", \"message\": {\"Timestamp\":" + timestamp + "," + "\"X\":" + mouseX/15 + "," + "\"Y\":" + mouseY/15 + "," + "\"Possession\":" + possession + "," + "\"Pass\":" + pass + "," + "\"Receive\":" + receive + "," + "\"home goal\":" + home + "," + "\"away goal\":" + away + "," + "\"Out\":" + out + "}}");
    }

    //UNCOMMENT TO USE SERIAL PORT METHOD INSTEAD OF AWS OR TO TEST IN PRINTLN
    //serialWrite(json);
    println ("{");
    println ("\"Timestamp\":" + timestamp + ",");
    println ("\"X\":" + mouseX/15 + ",");
    println ("\"Y\":" + mouseY/15 + ",");
    println ("\"Possession\":" + possession + ",");
    println ("\"Pass\":" + pass + ",");
    println ("\"Receive\":" + receive + ",");
    println ("\"home goal\":" + home + ",");
    println ("\"away goal\":" + away + ",");
    println ("\"Out\":" + out);
    println("}," );
    println();


    //Send the information to server in one message
    wsc.sendMessage(json); 

    //Read input from serial port. Only uncomment if needed for serial port method.
    //if (myPort.available() > 0) {
    //  String input = myPort.readString();
    //  println(input);
    //}

    //Ensure that the vibrations only last one frame.
    if (receive == 1) {
      receive = 0;
    }
    if (pass == 1) {
      pass = 0;
    }
    if (home == 1) {
      home = 0;
    }
    if (away == 1) {
      away = 0;
    }
    if (out == 1) {
      out = 0;
    }

    //Iterate timestamp by 0.125 seconds.
    time = millis();
    timestamp += 0.125;
  }

  //write output as text on screen for testing purposes.
  if (submit) {
    text("Timestamp: " + timestamp, 50, 200);
    text("X: " + mouseX/15, 50, 225);
    text("Y: " + mouseY/15, 50, 250);
    text("Possession: " + possession, 50, 275);
    text("Pass: " + pass, 50, 300);
    text("Receive: " + receive, 50, 325);
    text("Home Goal: " + home, 50, 350);
    text("Away Goal: " + away, 50, 375);
    text("Out: " + out, 50, 400);
  }

  //Controller variables.
  if (keyPressed) {
    if (key == '2') {
      if (home == 0) {
        home = 1;
      }
    } else if (key == '3') {
      if (away == 0) {
        away = 1;
      }
    } else if (key == '1') {
      if (out == 0) {
        out = 1;
      }
    } else if (key == 'a' || key == 'A') {
      if (pass == 0) {
        pass = 1;
      }
    } else if (key == 'd' || key == 'D') {
      if (receive == 0) {
        receive = 1;
      }
    } else if (key == 'e' || key == 'E') {
      exit(); // Stops the program
    }
  }

  //Possession variables
  if (mousePressed && (mouseButton == LEFT) && (submit == true)) {
    if (possession == 0 || possession == 66) {
      possession = 1;
    }
  } else if (mousePressed && (mouseButton == RIGHT) && (submit == true)) {
    if (possession == 1 || possession == 66) {
      possession = 0;
    }
  } else {
    possession = 66;
  }
}

//Print what the websocket server is sending to the console.
void webSocketEvent(String msg) {
  println(msg);
}

void dropdown(int n) {

  CColor c = new CColor();
  c.setBackground(color(255, 255, 0));
  cp5.get(ScrollableList.class, "dropdown").getItem(n).put("color", c);
}

void controlEvent(ControlEvent theEvent) {
  /* events triggered by controllers are automatically forwarded to 
   the controlEvent method. by checking the name of a controller one can 
   distinguish which of the controllers has been changed.
   */
  if (theEvent.isController()) { 

    print("control event from : "+theEvent.getController().getName());
    println(", value : "+theEvent.getController().getValue());

    if (theEvent.getController().getName()=="start") {
      cp5.hide();
      submit = true;
    }
  }
}
