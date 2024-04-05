class Input extends Widget {
  String inputString;
  String title;
  int width, height;
  int cursorLocation;
  boolean selected;

  int blink;

  Input(int x, int y, int width, int height, String title) {
    super(x, y);
    this.width = width;
    this.height = height;
    inputString = "";
    clickable = true;
    this.title = title;
  }

  boolean clicked(int screenX, int screenY, int mouseX, int mouseY) {
    return mouseX>screenX+x && mouseX<screenX+x+width && mouseY>screenY+y && mouseY<screenY+y+height;
  }

  void clear() {
    inputString = "";
  }

  void event(int screenX, int screenY, int mouseX, int mouseY, boolean click) {
    if (click) {
      if (clicked(screenX, screenY, mouseX, mouseY)) {
        if (!selected) {
          selected = true;
          selectedWidget = this;
          blink = 0;
        } else {
          selectedWidget = null;
        }
      } else {
        if (selectedWidget == this) selectedWidget = null;
        selected = false;
      }
    } else {
      if (selected) {
        if (keyCode ==8) {
          if (inputString.length()>0) {
            inputString = inputString.substring(0, inputString.length()-1);
          }
        } else if (key!=CODED) {
          inputString += key;
        }
      }
    }
  }

  void draw(int screenX, int screenY) {
    fill(BACKGROUND_COLOR);
    stroke(0);

    rect(screenX+x, screenY+y, width, height);
    fill(0);
    if (inputString.length()>0)
      text(inputString.substring(textWidth(inputString)>width?lastEl():0), screenX+x+2, screenY+y+height/2+2);
    else {
      fill(TITLE_COLOR);
      text(title, screenX+x+2, screenY+y+height/2+2);
    }
    if (selected) {
      fill(0);
      if (blink<BLINK_INTERVAL) line(screenX+x+(textWidth(inputString)>width?width-1:textWidth(inputString)+1), screenY+y+5, screenX+x+(textWidth(inputString)>width?width-1:textWidth(inputString)+1), screenY+y+height-5);
      else if (blink>BLINK_INTERVAL*2) blink = 0;
      blink++;
    }
  }


  int lastEl() {
    for (int i = inputString.length()-1; i>0; i--) {
      if (textWidth(inputString.substring(i))>width) {
        return i+1;
      }
    }
    return 0;
  }

  String getInput() {
    return inputString;
  }
}

class DateVerify extends Widget {
  Input input;
  String textIfCorrect, textIfWrong;

  DateVerify(Input input, String textIfCorrect, String textIfWrong) {
    super(input.x, input.y+input.height+20);
    this.input = input;
    this.textIfCorrect = textIfCorrect;
    this.textIfWrong = textIfWrong;
  }

  void draw(int screenX, int screenY) {
    if (input.getInput().matches("^(1[0-2]|0[1-9])/(3[01]|[12][0-9]|0[1-9])/[0-9]{4}$")) {
      fill(0, 200, 0);
      text(textIfCorrect, screenX+x, screenY+y);
    } else {
      fill(200, 0, 0);
      text(textIfWrong, screenX+x, screenY+y);
    }
  }

  boolean isCorrect() {
    return input.getInput().matches("^(1[0-2]|0[1-9])/(3[01]|[12][0-9]|0[1-9])/[0-9]{4}$");
  }
}
