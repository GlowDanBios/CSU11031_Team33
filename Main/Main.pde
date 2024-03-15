Table table;
TableView gTable;
Screen tableScreen;
Screen activeScreen;

void settings() {
  size(WINDOW_WIDTH, WINDOW_HEIGHT);
}

void setup () {
  table = loadTable("Files/flights2k.csv", "header");

  tableScreen = new Screen(TABLE_TOP_BORDER, TABLE_LEFT_BORDER);
  gTable = new TableView(table, 0, 0);
  tableScreen.addWidget(gTable);
  activeScreen = tableScreen;

}

void draw() {
  background(BACKGROUND_COLOR);
  activeScreen.draw();
}

void keyPressed() {
  if (key == 'w') {
    if (activeScreen.getY()+SCROLL_SPEED<TABLE_TOP_BORDER)
      activeScreen.move(activeScreen.getX(), activeScreen.getY()+SCROLL_SPEED);
  } else if (key == 's') {
    activeScreen.move(activeScreen.getX(), activeScreen.getY()-SCROLL_SPEED);
  } else if (key == 'a') {
    if (activeScreen.getX()+SCROLL_SPEED<TABLE_LEFT_BORDER)
      activeScreen.move(activeScreen.getX()+SCROLL_SPEED, activeScreen.getY());
  } else if (key == 'd') {
    activeScreen.move(activeScreen.getX()-SCROLL_SPEED, activeScreen.getY());
  }
}
