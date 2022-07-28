public class LeavePage extends Page {
  Button yes, no;
  Textlabel message;

  static final String LEAVE_PAGE_YES_LABEL = "LEAVE_PAGE_YES_LABEL";
  static final String LEAVE_PAGE_NO_LABEL = "LEAVE_PAGE_NO_LABEL";
  static final String LEAVE_PAGE_TXT_LABEL = "LEAVE_PAGE_TXT_LABEL";

  LeavePage() {
    font = createFont("arial", 25);
    background = loadImage(dataPath(FIG_PATH) + File.separator + "Background.png");

    message = cp5.addTextlabel(LEAVE_PAGE_TXT_LABEL)
      .setPosition(600, 350)
      .setSize(100, 50)
      .setColorBackground(color(20, 20, 20))
      .setColorBackground(color(33, 33, 33))
      .setColorForeground(color(48, 48, 48))
      .setColorActive(color(79, 79, 79))
      .setStringValue("Exit game?")
      .setFont(createFont("arial", 40));

    yes = cp5.addButton(LEAVE_PAGE_YES_LABEL)
      .setPosition(550, 410)
      .setSize(100, 50)
      .setColorBackground(color(20, 20, 20))
      .setColorBackground(color(33, 33, 33))
      .setColorForeground(color(48, 48, 48))
      .setColorActive(color(79, 79, 79))
      .setLabel("Yes")
      .setFont(font);

    no = cp5.addButton(LEAVE_PAGE_NO_LABEL)
      .setPosition(750, 410)
      .setSize(100, 50)
      .setColorBackground(color(20, 20, 20))
      .setColorBackground(color(33, 33, 33))
      .setColorForeground(color(48, 48, 48))
      .setColorActive(color(79, 79, 79))
      .setLabel("No")
      .setFont(font);

    controllers.add(yes);
    controllers.add(no);
    controllers.add(message);
  }
  
  void onClickYes() {
    game.finish();
  }

  void onClickNo() {
  }
}