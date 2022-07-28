public class LoginPage extends Page {
  Button submit;
  Textfield pass, email;
  
  static final String SUBMIT_LABEL = "Login";
  static final String PASS_LABEL = "Password";
  static final String EMAIL_LABEL = "Email";

  LoginPage() {
    font = createFont("arial", 25);
    background = loadImage(dataPath(FIG_PATH) + File.separator + "Background.png");

    submit = cp5.addButton(SUBMIT_LABEL)
      .setPosition(670, 650)
      .setSize(100, 50)
      .setColorBackground(color(20, 20, 20))
      .setColorBackground(color(33, 33, 33))
      .setColorForeground(color(48, 48, 48))
      .setColorActive(color(79, 79, 79))
      .setLabel("Login")
      .setFont(font);

    email = cp5.addTextfield(EMAIL_LABEL)
      .setPosition(220, 340)
      .setSize(1000, 40)
      .setColorBackground(color(33, 33, 33))
      .setColorForeground(color(48, 48, 48))
      .setColorActive(color(79, 79, 79))
      .setFont(font);

    pass = cp5.addTextfield(PASS_LABEL)
      .setPosition(220, 440)
      .setSize(1000, 40)
      .setColorBackground(color(33, 33, 33))
      .setColorForeground(color(48, 48, 48))
      .setColorActive(color(79, 79, 79))
      .setPasswordMode(true)
      .setFont(font);
      
    controllers.add(email);
    controllers.add(pass);
    controllers.add(submit);
  }
  
  void onClickSubmit() {
    
  }
}