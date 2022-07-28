import controlP5.*;
import java.util.LinkedList;

static LinkedList<Page> pages;

public static void addPages(Page... pgs) {
    if (pages == null) {
      pages = new LinkedList<Page>();
    }

    for (Page p : pgs) {
        pages.add(p);
        p.hide();
    }
}

public abstract class Page {
    
    protected LinkedList<Controller> controllers;
    protected PImage background;
    protected PFont font;

    private boolean visible;

    public Page() {
        controllers = new LinkedList<Controller>();
        visible = true;
    }

    public void show() {
      if (visible) {
        return;
      }
      visible = true;

      // hide other pages
      for (Page p : pages) {
        if (p == this) {
            // don't hide this page
            continue;
        }

        p.hide();
      }
      
      if (background != null) {
          background(background);
      }

      for (Controller c : controllers) {
        c.show();
      }
    }
    
    public void hide() {
      if (!visible) {
        return;
      }
      visible = false;
      
      for (Controller c : controllers) {
        c.hide();
      }
    }
}