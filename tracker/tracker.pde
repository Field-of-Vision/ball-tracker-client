//Import libraries
import controlP5.*;

enum State {
  START, PAUSED, ONGOING;
}

private class Game {
  int time;
  double timestamp;
  int pass, receive, home, away, out, possession;
  String action, stadium, url;
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
  
  void setStadium(String url, String stadium, int selectedImage) {
    this.url = url;
    this.stadium = stadium;
    this.selectedImage = selectedImage;
    
    switch(url) {
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

  String toTautJson() {
    return "{\n\"Timestamp\":" +
      String.format("%.03f", timestamp) + ",\n\"X\":" +
      mouseX/15 + ",\n\"Y\":" +
      mouseY/15 + ",\n\"Possession\":" +
      possession + ",\n\"Pass\":" +
      pass + ",\n\"Receive\":" +
      receive + ",\n\"home goal\":" +
      home + ",\n\"away goal\":" +
      away + ",\n\"Out\":" +
      out + "\n}";
  }

  String toJsonRequest() {
    if (action == null) {
      println("Can't send message to the server before setting the stadium");
    }

    return "{\"action\": \"" + action + "\", \"message\": {\"Timestamp\":" +
      String.format("%.03f", timestamp) + ",\"X\":" +
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
        saveEnd();
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
  ListBox list;
  PFont font;
  PImage bg;
  
  boolean visible = false;

  String[] stadiums = {
    "Dalymount Park",
    "Marvel Stadium",
    "Melbourne Cricket Ground",
    "Estádio do Dragão",
    "Estádio da Luz",
    "Estádio José Alvalade"
  };

  MainMenu() {
    //Add Ireland and Australia to stadiums array

    font = createFont("arial", 25);
    bg = loadImage(dataPath(FIG_PATH) + File.separator + "Background.png");

    start = cp5.addButton("state")
      .setPosition(670, 650)
      .setSize(100, 50)
      .setColorBackground(color(20, 20, 20))
      .setColorBackground(color(33, 33, 33))
      .setColorForeground(color(48, 48, 48))
      .setColorActive(color(79, 79, 79))
      .setLabel("Start")
      .setFont(font);

    //Load dropdown list
    list = cp5.addListBox("Stadium Selector:")
      .setPosition(220, 340)
      .setSize(1000, 280)
      .setBarVisible(false)
      .setColorBackground(color(33, 33, 33))
      .setColorForeground(color(48, 48, 48))
      .setColorActive(color(79, 79, 79))
      .setItemHeight(70)
      .setFont(font)
      .addItems(stadiums);
  }
  
  void show() {
    if (visible) {
      return;
    }
    visible = true;

    textSize(30);
    background(bg);
    cp5.show();
  }
  
  void hide() {
    if (!visible) {
      return;
    }
    visible = false;

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

  ball[0] = loadImage(dataPath(FIG_PATH) + File.separator + "Soccer.png");
  ball[1] = loadImage(dataPath(FIG_PATH) + File.separator + "AFLBall.png");
  ball[2] = loadImage(dataPath(FIG_PATH) + File.separator + "CricketBall.png");

  menu = new MainMenu();

  // load images in setup
  images[0] = loadImage(dataPath(FIG_PATH) + File.separator + "Ireland.png");
  images[1] = loadImage(dataPath(FIG_PATH) + File.separator + "Australia.png");
  images[2] = loadImage(dataPath(FIG_PATH) + File.separator + "Cricket.png");

  frameRate(60);
  textFont(font);
  
  webSetup();
}

void draw() {
  
  // menu for stadium choice
  if (game.state == State.START) {
    menu.show();
  
    int selectedStadium = (int) cp5.getController("Stadium Selector:").getValue();
    String stadiumName = menu.stadiums[selectedStadium];
    switch (selectedStadium) {
    case 0:
      game.setStadium(DALYMOUNT_PARK, stadiumName, selectedStadium);
      break;
    case 1:
      game.setStadium(MARVEL_STADIUM, stadiumName, selectedStadium);
      break;
    case 2:
      game.setStadium(MELBOURNE_CRICKET_GROUND, stadiumName, selectedStadium);
      break;
    default:
      println("Stadium not handled <" + stadiumName + ">");
      exit();
    }

    return;
  }

  textSize(20);
  imageMode(CORNER);
  image(images[game.selectedImage], 0, 0, width, height);
  imageMode(CENTER);
  image(ball[game.selectedImage], mouseX, mouseY);

  //Everything within this if statement occurs every 0.125 seconds and sends the information to the AWS server.
  int clock = millis();
  if (game.state == State.ONGOING && clock > game.time + 125) {

    // Iterate timestamp by 0.125 seconds.
    float elapsed = clock - game.time;
    println("Elapsed time since last request: " + elapsed);
    game.time = clock;

    game.timestamp = (float)game.time / 1000.0;

    webSendJson(game.toJsonRequest());
    saveAppend(game.toTautJson());

    //Ensure that the vibrations only last one frame.
    game.reset();
  }

  int leftPad = 10;
  //Instructions on screen
  text("Hold Left Click - Possession", leftPad, 30);
  text("Press 'A' - Pass", leftPad, 55);
  text("Press 'D' - Receive", leftPad, 80);
  text("Press '1' - Ball Out", leftPad, 105);
  text("Press '2' - Home Goal", leftPad, 130);
  text("Press '3' - Away Goal", leftPad, 155);
  text("Press 'Space' - Pause/Resume Game", leftPad, 180);
  // write output as text on screen for testing purposes.
  text("Timestamp: " + game.timestamp, leftPad, 220);
  text("X: " + mouseX/15, leftPad, 245);
  text("Y: " + mouseY/15, leftPad, 270);
  text("Possession: " + game.possession, leftPad, 295);
  text("Pass: " + game.pass, leftPad, 320);
  text("Receive: " + game.receive, leftPad, 345);
  text("Home Goal: " + game.home, leftPad, 370);
  text("Away Goal: " + game.away, leftPad, 395);
  text("Out: " + game.out, leftPad, 420);

  //Controller variables.
  game.handleKeyPress(keyPressed, key);

  //Possession variables
  game.handleMousePress(mousePressed, mouseButton);
}

//Print what the websocket server is sending to the console.
void webSocketEvent(String msg) {
  println(msg);
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
  webConnect(game.url);
  saveStart(game.stadium);
  menu.hide();
}
