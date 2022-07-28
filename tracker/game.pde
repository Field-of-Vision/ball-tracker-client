enum State {
  PAUSED, ONGOING, FINISHED;
}

public class GamePage extends Page {
  int time;
  double timestamp;
  int pass, receive, home, away, out, possession;
  String action, stadium, url;
  int selectedImage;
  State state;
  
  GamePage() {
    state = State.PAUSED;
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
  
  @Override
  void show() {
    super.show();
    
    textSize(20);
    imageMode(CORNER);
    image(images[selectedImage], 0, 0, width, height);
    imageMode(CENTER);
    image(ball[selectedImage], mouseX, mouseY);

    //Everything within this if statement occurs every 0.125 seconds and sends the information to the AWS server.
    int clock = millis();
    if (state == State.ONGOING && clock > time + 125) {

      // Iterate timestamp by 0.125 seconds.
      float elapsed = clock - time;
      println("Elapsed time since last request: " + elapsed);

      time = clock;
      timestamp = (float)time / 1000.0;

      webSendJson(toJsonRequest());
      saveAppend(toTautJson());

      //Ensure that the vibrations only last one frame.
      this.reset();
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
    text("Timestamp: " + timestamp, leftPad, 220);
    text("X: " + mouseX/15, leftPad, 245);
    text("Y: " + mouseY/15, leftPad, 270);
    text("Possession: " + possession, leftPad, 295);
    text("Pass: " + pass, leftPad, 320);
    text("Receive: " + receive, leftPad, 345);
    text("Home Goal: " + home, leftPad, 370);
    text("Away Goal: " + away, leftPad, 395);
    text("Out: " + out, leftPad, 420);

    //Controller variables.
    onKeyPressed(keyPressed, key);

    //Possession variables
    onMousePressed(mousePressed, mouseButton);
  }

  void onKeyPressed(boolean keyPressed, char key) {
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
        if (out == 0) {
          out = 1;
        }
        break;

      case '2':
        if (home == 0) {
          home = 1;
        }
        break;
      
      case '3':
        if (away == 0) {
          away = 1;
        }
        break;
        
      case 'A':
        if (pass == 0) {
          pass = 1;
        }
        break;
        
      case 'D':
        if (receive == 0) {
          receive = 1;
        }
        break;
        
      case 'E':
        state = State.FINISHED;
        visible = menu;
        webDisconnect();
        saveEnd();
        break;
    }
  }

  public void start() {
    state = State.PAUSED;
    webConnect(url);
    saveStart(stadium);
  }
  
  void onMousePressed(boolean mousePressed, int mouseButton) {
    if (!mousePressed) {
      possession = POSSESSION_NEUTRAL;
      return;
    }

    if (mouseButton == LEFT) {
        possession = 1;
        return;
    }

    if (mouseButton == RIGHT) {
        possession = 0;
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
