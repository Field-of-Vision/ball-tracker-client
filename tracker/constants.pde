//Initalise image of background and ball.
PImage bg;
//Make constants for the stadiums.
final String DALYMOUNT_PARK = "wss://cbxuz3133a.execute-api.eu-west-1.amazonaws.com/production";
final String MARVEL_STADIUM = "wss://h5ozod1wbk.execute-api.ap-southeast-2.amazonaws.com/production";
final String MELBOURNE_CRICKET_GROUND = "wss://kc5addsuj3.execute-api.ap-southeast-2.amazonaws.com/production";

final String FIG_PATH = "../etc/fig";

// Initialise all variables
int time;
ControlP5 controlP5;
double timestamp;
int selectedImage;
PrintWriter output;
int pass, receive, home, away, out;
int possession;
ControlP5 cp5;
String filename;
Boolean submit;
//Serial myPort;
String portName;
String json;
String info;
String stadium;
WebsocketClient wsc;
PImage[] images = new PImage[3];
String[] stadiums = new String[3];
PImage[] ball = new PImage[3];
