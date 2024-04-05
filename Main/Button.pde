class Button extends Widget {
  ArrayList<ButtonObserver> observers;
  String text;
  int width, height;
  color c;

  Button(int x, int y, int width, int height, String text) {
    super(x, y);
    this.width = width;
    this.height = height;
    this.text = text;
    observers = new ArrayList<ButtonObserver>();
    setColor(BUTTON_COLOR);
  }

  void draw(int screenX, int screenY) {
    fill(c);
    rect(screenX+x, screenY+y, width, height);
    fill(0);
    text(text, screenX+x, screenY+y+3*height/4);
  }
  void addObserver(ButtonObserver observer) {
    observers.add(observer);
  }
  void removeObserver(ButtonObserver observer) {
    observers.remove(observer);
  }

  void notifyObservers() {
    println(text);
    for (ButtonObserver observer : observers) {
      observer.buttonClicked(this);
    }
  }

  void setColor(color c) {
    this. c = c;
  }

  boolean clicked(int screenX, int screenY, int mouseX, int mouseY) {
    return mouseX>screenX+x && mouseX<screenX+x+width && mouseY>screenY+y && mouseY<screenY+y+height;
  }

  void event(int screenX, int screenY, int mouseX, int mouseY, boolean click) {
    if (click) {
      if (clicked(screenX, screenY, mouseX, mouseY)) {
        notifyObservers();
      }
    }
  }
}
