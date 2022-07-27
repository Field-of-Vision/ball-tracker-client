import java.util.concurrent.ConcurrentLinkedQueue;
import java.io.FileWriter;
import java.io.BufferedWriter;
import java.io.PrintWriter;

String filename;
File file;
volatile boolean terminate;
volatile boolean finished;

// JSON strings describing the position of the ball
ConcurrentLinkedQueue<String> steps = new ConcurrentLinkedQueue<String>();

void saveThread() {
  PrintWriter out;
  try {
    out = new PrintWriter(new BufferedWriter(new FileWriter(file)));

    out.println("[");

    for(;;) {
      String head = steps.poll();
      
      if (head == null) {
        if (terminate) {
            break;
        }

        delay(1000);
        continue;
      }
      
      out.println(head + ",");
    }
    
    // flush remaining steps
    for(;;) {
        println("remaining...");
      String head = steps.poll();
      
      if (head == null) {
        break;
      }
      
      out.println(head + ",");
    }
    
    out.println("]");
    out.close();
  } catch (Exception e) {
    println(e.getMessage());
  }
  
  finished = true;
  println("finished...");
}

void saveAppend(String step) {
    steps.add(step);
}

void saveStart(String name) {
    filename = SAVE_PATH + File.separator + name.replace(" ", "_") + "-" + String.valueOf(System.currentTimeMillis()) + ".json";
    filename = dataPath(filename);
    file = new File(filename);
    try {

    file.createNewFile();
    } catch(Exception e) {
        println(e.getMessage());
    }
    terminate = false;
    finished = false;
    thread("saveThread");
}

void saveEnd() {
    terminate = true;
    
    for(;;) {
        if (finished) {
            break;
        }

        delay(50);
    }
}