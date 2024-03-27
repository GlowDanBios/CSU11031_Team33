Table table;
TableView gTable;
Screen tableScreen;
Screen barScreen;
Screen activeScreen;
Widget selectedWidget;
Query origin;

void settings() {
  size(WINDOW_WIDTH, WINDOW_HEIGHT);
}

void setup () {
  table = loadTable("flights2k.csv", "header");

  tableScreen = new Screen(TABLE_TOP_BORDER, TABLE_LEFT_BORDER);
  tableScreen.addWidget(new Input(10, 0, 300, 30));
  gTable = new TableView(table, 0, 50);
  tableScreen.addWidget(gTable);
  
  barScreen = new Screen(TABLE_TOP_BORDER, TABLE_LEFT_BORDER);
  origin = new Query(table, "JFK", "FLL", "MKT_CARRIER");
  String[] entryArray = {"WN", "B6", "AS"};
  String independentVariable = "MKT_CARRIER";
  int[][] unreliability = {origin.unreliable(entryArray, "DEP_TIME", independentVariable), origin.unreliable(entryArray, "CANCELLED", independentVariable),
                            origin.unreliable(entryArray, "DIVERTED", independentVariable)};

  barScreen.addWidget(new BarChart(10,10,500,250, "Airport", "Flights", unreliability,  entryArray ));
  origin.frequencyDays(1, 10);

  
  PFont font = loadFont("AgencyFB-Bold-20.vlw");
  textFont(font);
  
  activeScreen = tableScreen;
}

void draw() {
  background(BACKGROUND_COLOR);
  activeScreen.draw();
}

void keyPressed() {
  if (selectedWidget == null) {
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
    } else if(key == 'm'){
      activeScreen = barScreen;
    }
    else if(key == 'n'){
      activeScreen = tableScreen;
    }
  }
  else{
    selectedWidget.event(activeScreen.getX(), activeScreen.getY(), mouseX, mouseY, false);
    
  }
}

void mousePressed() {
  ArrayList<Widget> screenWidgets = activeScreen.getWidgets();


  for (Widget widget : screenWidgets) {
    widget.event(activeScreen.getX(), activeScreen.getY(), mouseX, mouseY, true);
  }
}
