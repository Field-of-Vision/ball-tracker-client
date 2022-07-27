//Import libraries
import controlP5.*;

enum State {
  START, PAUSED, ONGOING;
}

private class Game {
  int time;
  double timestamp;
  int pass, receive, home, away, out, possession;
  String action, stadium;
  int selectedImage;
  State state;
  
  Game() {
    state = State.START;
    time = millis();
    pass = 0;
    receive = 0;
    home = 0;
    away = 0;
    out = 0;
    possession = POSSESSION_NEUTRAL;
    timestamp = 0;
    selectedImage = -1;
  }
  
  void setStadium(String stadium, int selectedImage) {
    this.stadium = stadium;
    this.selectedImage = selectedImage;
    
    switch(stadium) {
      case DALYMOUNT_PARK:
        this.action = "irelandSendMessage";
        break;
      case MARVEL_STADIUM:
        this.action = "marvel_AUS_sendMessage";
        break;
      case MELBOURNE_CRICKET_GROUND:
        this.action = "mcg_AUS_sendMessage";
        break;
    }
  }

  String toJsonRequest() {
    if (action == null) {
      println("Can't send message to the server before setting the stadium");
    }

    return "{\"action\": \"" + action + "\", \"message\": {\"Timestamp\":" +
      timestamp + ",\"X\":" +
      mouseX/15 + ",\"Y\":" +
      mouseY/15 + ",\"Possession\":" +
      possession + ",\"Pass\":" +
      pass + ",\"Receive\":" +
      receive + ",\"home goal\":" +
      home + ",\"away goal\":" +
      away + ",\"Out\":" +
      out + "}}";
  }

  void handleKeyPress(boolean keyPressed, char key) {
    if (!keyPressed) {
      lastKeyPressed = '\\';
      return;
    }
    
    char k = Character.toUpperCase(key);
    if (lastKeyPressed == k) {
      return;
    }
    lastKeyPressed = k;
    
    if (k == ' ') {
        if (state == State.PAUSED) {
          state = State.ONGOING;
          return;
        }

        state = State.PAUSED;
        return;
    }
    
    if (state != State.ONGOING) {
      return;
    }
    
    switch (k) {
      case '1':
        if (game.out == 0) {
          game.out = 1;
        }
        break;

      case '2':
        if (game.home == 0) {
          game.home = 1;
        }
        break;
      
      case '3':
        if (game.away == 0) {
          game.away = 1;
        }
        break;
        
      case 'A':
        if (game.pass == 0) {
          game.pass = 1;
        }
        break;
        
      case 'D':
        if (game.receive == 0) {
          game.receive = 1;
        }
        break;
        
      case 'E':
        state = State.START;
        webDisconnect();
        break;
    }
  }
  
  void handleMousePress(boolean mousePressed, int mouseButton) {
    if (!mousePressed) {
      game.possession = POSSESSION_NEUTRAL;
      return;
    }

    if (mouseButton == LEFT) {
        game.possession = 1;
        return;
    }

    if (mouseButton == RIGHT) {
        game.possession = 0;
    }
  }
  
  void reset() {
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
  }
}

private class MainMenu {
  Button start;
  ScrollableList list;
  PFont font;
  PImage bg;
  String[] stadiums = new String[3];

  MainMenu() {
    //Add Ireland and Australia to stadiums array
    stadiums[0] = "Dalymount Park";
    stadiums[1] = "Marvel Stadium";
    stadiums[2] = "Melbourne Cricket Ground";

    font = createFont("arial", 25);
    bg = loadImage(FIG_PATH + "/Background.png");

    start = cp5.addButton("state")
      .setPosition(670, 650)
      .setSize(100, 50)
      .setLabel("Start")
      .setFont(font);

    //Load dropdown list
    list = cp5.addScrollableList("Stadium Selector:")
      .setPosition(220, 340)
      .setSize(1000, 1000)
      .setBarHeight(75)
      .setItemHeight(65)
      .setFont(font)
      .addItems(stadiums);
  }
  
  void show() {
    textSize(30);
    background(bg);
    cp5.show();
  }
  
  void hide() {
    cp5.hide();
    list.open();
  }
}

// global
ControlP5 controlP5;
ControlP5 cp5;
PImage[] images = new PImage[3];
PImage[] ball = new PImage[3];
Game game;
char lastKeyPressed = '\\';
MainMenu menu;

void settings() {
  //Set size of window
  size(1440, 780);
}

void setup() {
  cp5 = new ControlP5(this);
  game = new Game();

  //Initalise font
  PFont font = createFont("arial", 25);

  ball[0] = loadImage(FIG_PATH + "/Soccer.png");
  ball[1] = loadImage(FIG_PATH + "/AFLBall.png");
  ball[2] = loadImage(FIG_PATH + "/CricketBall.png");

  menu = new MainMenu();

  // load images in setup
  images[0] = loadImage(FIG_PATH + "/Ireland.png"); // note: arrays state at zero!
  images[1] = loadImage(FIG_PATH + "/Australia.png");
  images[2] = loadImage(FIG_PATH + "/Cricket.png");

  frameRate(60);
  textFont(font);
  
  webSetup();
}

void draw() {
  
  // menu for stadium choice
  if (game.state == State.START) {
    menu.show();
  
    int selectedStadium = (int) cp5.getController("Stadium Selector:").getValue();
    switch (selectedStadium) {
    case 0:
      game.setStadium(DALYMOUNT_PARK, selectedStadium);
      break;
    case 1:
      game.setStadium(MARVEL_STADIUM, selectedStadium);
      break;
    case 2:
      game.setStadium(MELBOURNE_CRICKET_GROUND, selectedStadium);
      break;
    default:
      println("Stadium not handled <" + selectedStadium + ">");
    }

    return;
  }

  textSize(20);
  imageMode(CORNER);
  image(images[game.selectedImage], 0, 0, width, height);
  imageMode(CENTER);
  image(ball[game.selectedImage], mouseX, mouseY);

  //Instructions on screen
  text("Hold Left Click - Possession", 50, 30);
  text("Press 'A' - Pass", 50, 55);
  text("Press 'D' - Receive", 50, 80);
  text("Press '1' - Ball Out", 50, 105);
  text("Press '2' - Home Goal", 50, 130);
  text("Press '3' - Away Goal", 50, 155);
  text("Press 'Space' - Pause/Resume Game", 50, 180);

  //Everything within this if statement occurs every 0.125 seconds and sends the information to the AWS server.
  int clock = millis();
  if (game.state == State.ONGOING && clock > game.time + 125) {

    // Iterate timestamp by 0.125 seconds.
    float elapsed = clock - game.time;
    println("Elapsed time since last request: " + elapsed);
    game.time = clock;

    game.timestamp = (float)game.time / 1000.0;

    //Send the information to server in one message
    String json = game.toJsonRequest();

    webSendJson(json);

    //Ensure that the vibrations only last one frame.
    game.reset();
  }

  // write output as text on screen for testing purposes.
  text("Timestamp: " + game.timestamp, 50, 200);
  text("X: " + mouseX/15, 50, 225);
  text("Y: " + mouseY/15, 50, 250);
  text("Possession: " + game.possession, 50, 275);
  text("Pass: " + game.pass, 50, 300);
  text("Receive: " + game.receive, 50, 325);
  text("Home Goal: " + game.home, 50, 350);
  text("Away Goal: " + game.away, 50, 375);
  text("Out: " + game.out, 50, 400);

  //Controller variables.
  game.handleKeyPress(keyPressed, key);

  //Possession variables
  game.handleMousePress(mousePressed, mouseButton);
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
  if (!theEvent.isController()) { 
    return;
  }

  print("control event from : "+theEvent.getController().getName());
  println(", value : "+theEvent.getController().getValue());

  if (theEvent.getController().getName() != "state") {
    return;
  }

  cp5.hide();
  game.state = State.PAUSED;
  webConnect(game.stadium);
  menu.hide();
}
