import websockets.*;
import java.util.concurrent.ConcurrentLinkedQueue;

ConcurrentLinkedQueue<String> requests = new ConcurrentLinkedQueue<String>();

WebsocketClient wsc;
String url;

void webConnect(String uri) {
  if (wsc != null) {
    println("Already connected to <" + url + ">. Disconnect first.");
    return;
  }

  url = uri;
  wsc = new WebsocketClient(this, uri);
}

void webDisconnect() {
  if (wsc == null) {
    println("Not connected to anything...");
    return;
  }

  // wait for remaining requests before destroying the socket...
  for(;;) {
    String head = requests.poll();
    
    if(head == null) {
      break;
    }

    delay(250);
  }

  wsc.dispose();
  wsc = null;
}

// thread will periodically poll for new requests from the concurrent Q
void webThread() {
  for(;;) {
    String head = requests.poll();
    
    if(head == null) {
      delay(100);
      continue;
    }
    
    wsc.sendMessage(head); 
  }
}

void webSendJson(String json) {
    // add json to request queue to ensure request order
    requests.add(json);
}

void webSetup() {
    thread("webThread");
}