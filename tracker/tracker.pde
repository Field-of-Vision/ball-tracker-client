import controlP5.*;

ControlP5 controlP5;
ControlP5 cp5;
PImage[] images = new PImage[3];
PImage[] ball = new PImage[3];

GamePage game;
MainPage menu;
LoginPage login;
Page visible;

char lastKeyPressed = '\\';

void settings() {
  size(1440, 780);
}

void setup() {
  cp5 = new ControlP5(this);

  game = new GamePage();
  menu = new MainPage();
  login = new LoginPage();

  addPages(game, menu, login);
  visible = menu;

  ball[0] = loadImage(dataPath(FIG_PATH) + File.separator + "Soccer.png");
  ball[1] = loadImage(dataPath(FIG_PATH) + File.separator + "AFLBall.png");
  ball[2] = loadImage(dataPath(FIG_PATH) + File.separator + "CricketBall.png");

  images[0] = loadImage(dataPath(FIG_PATH) + File.separator + "Ireland.png");
  images[1] = loadImage(dataPath(FIG_PATH) + File.separator + "Australia.png");
  images[2] = loadImage(dataPath(FIG_PATH) + File.separator + "Cricket.png");

  frameRate(60);
  webSetup();
}

void draw() {
  visible.show();
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
  
  switch(theEvent.getController().getName()) {
    case MainPage.LOGIN_LABEL:
      if (visible != menu) {
        return;
      }
      
      visible = login;
      return;
      
    case MainPage.LIST_LABEL:
      if (visible != menu) {
        return;
      }

      int selectedStadium = (int) cp5.getController(MainPage.LIST_LABEL).getValue();
      menu.onClickList(selectedStadium);
      return;

    case MainPage.START_LABEL:
      if (visible != menu) {
        return;
      }

      menu.onClickStart();
      visible = game;
      return;
  }
}
