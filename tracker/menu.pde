public class MainPage extends Page {
  Button start;
  Button login;
  ListBox list;
  
  static final String START_LABEL = "Start";
  static final String LOGIN_LABEL = "Logon";
  static final String LIST_LABEL = "Stadium Selector:";
  
  String[] stadiums = {
    "Dalymount Park",
    "Marvel Stadium",
    "Melbourne Cricket Ground",
    "Estádio do Dragão",
    "Estádio da Luz",
    "Estádio José Alvalade"
  };

  MainPage() {
    font = createFont("arial", 25);
    background = loadImage(dataPath(FIG_PATH) + File.separator + "Background.png");

    start = cp5.addButton(START_LABEL)
      .setPosition(670, 650)
      .setSize(100, 50)
      .setColorBackground(color(20, 20, 20))
      .setColorBackground(color(33, 33, 33))
      .setColorForeground(color(48, 48, 48))
      .setColorActive(color(79, 79, 79))
      .setLabel(START_LABEL)
      .setFont(font);

    login = cp5.addButton(LOGIN_LABEL)
      .setPosition(10, 10)
      .setSize(100, 50)
      .setColorBackground(color(33, 33, 33))
      .setColorForeground(color(48, 48, 48))
      .setColorActive(color(79, 79, 79))
      .setLabel(LOGIN_LABEL)
      .setFont(font);

    list = cp5.addListBox(LIST_LABEL)
      .setPosition(220, 340)
      .setSize(1000, 280)
      .setBarVisible(false)
      .setColorBackground(color(33, 33, 33))
      .setColorForeground(color(48, 48, 48))
      .setColorActive(color(79, 79, 79))
      .setItemHeight(70)
      .setFont(font)
      .addItems(stadiums);

    controllers.add(login);
    controllers.add(start);
    controllers.add(list);
  }

  void onClickStart() {
    game.start();
  }
  
  void onClickList(int selectedStadium) {
    String stadiumName = stadiums[selectedStadium];
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
      return;
    }
  }
}
