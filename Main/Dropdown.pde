class Dropdown extends Widget {
  String[] options;
  int selectedIndex;
  boolean expanded;
  int width, height;

  Dropdown(int x, int y, int width, int height, String[] options) {
    super(x, y);
    this.options = options;
    this.selectedIndex = 0;
    this.expanded = false;
    this.width = width;
    this.height = height;
  }

  boolean clicked(int screenX, int screenY, int mouseX, int mouseY) {
    return mouseX > screenX + x && mouseX < screenX + x + width && mouseY > screenY + y && mouseY < screenY + y + height;
  }

  void event(int screenX, int screenY, int mouseX, int mouseY, boolean click) {
    if (click) {
      if (clicked(screenX, screenY, mouseX, mouseY)) {
        expanded = !expanded;
      } else if (expanded) {
        int index = (mouseY - (screenY + y)) / height - 1;
        if (index >= 0 && index < options.length) {
          selectedIndex = index;
          expanded = false;
        }
      }
    }
  }

  void draw(int screenX, int screenY) {
    fill(BACKGROUND_COLOR);
    stroke(0);
    rect(screenX + x, screenY + y, width, height);
    fill(0);
    fill(TITLE_COLOR);
    text(options[selectedIndex], screenX + x + 2, screenY + y + height / 2 + 2);
    if (expanded) {
      for (int i = 0; i < options.length; i++) {
        if (i == selectedIndex) {
          fill(HIGHLIGHT_COLOR);
        } else {
          fill(255);
        }
        rect(screenX + x, screenY + y + (i+1) * height, width, height);
        fill(TEXT_COLOR);
        text(options[i], screenX + x + 2, screenY + y + (i+1) * height + height / 2 + 2);
      }
    }
  }

  String getSelectedOption() {
    return options[selectedIndex];
  }

  void clear() {
    selectedIndex = 0;
  }
}
