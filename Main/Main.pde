Table table;
TableView gTable;
Screen tableScreen;
Screen barScreen;
Screen activeScreen;
Widget selectedWidget;
Button searchButton;
Button clearButton;
Button unreliableButton;
Input search;
Input searchField;
Query origin;
PFont bigFont;
PFont smallFont;

void settings() {
  size(WINDOW_WIDTH, WINDOW_HEIGHT);
}

void setup () {
  table = loadTable("Files/flights2k.csv", "header");

  tableScreen = new Screen(TABLE_TOP_BORDER, TABLE_LEFT_BORDER);
  search = new Input(250, 0, 200, 30, "Search value");
  searchField = new Input(10, 0, 200, 30, "Column name");
  tableScreen.addWidget(search);
  tableScreen.addWidget(searchField);
  searchButton = new Button(460, 0, 50, 30, "Search");
  searchButton.setColor(color(255));
  tableScreen.addWidget(searchButton);
  clearButton = new Button(520, 0, 50, 30, "Clear");
  clearButton.setColor(color(255));
  tableScreen.addWidget(clearButton);
  unreliableButton = new Button(600, 0, 160, 30, "Display unreliable flights");
  unreliableButton.setColor(color(255));
  tableScreen.addWidget(unreliableButton);
  //departureInput = new Input(10, 0, 100, 30);
  //tableScreen.addWidget(departureInput);
  //returnInput = new Input(120, 0, 100, 30);
  //tableScreen.addWidget(returnInput);

  gTable = new TableView(table, 0, 100);
  tableScreen.addWidget(gTable);
  searchButton.addObserver(new SearchFilter(gTable));
  clearButton.addObserver(new SearchFilter(gTable));
  unreliableButton.addObserver(new QueryShow(gTable));


  //barScreen = new Screen(TABLE_TOP_BORDER, TABLE_LEFT_BORDER);
  ////barScreen.addWidget(new Input(10, 400, 300, 30));
  ////barScreen.addWidget(new Button(360, 400, 100, 30, "Add airport"));
  //origin = new Query(table, "JFK", "FLL", "ORIGIN");

  //barScreen = new Screen(TABLE_TOP_BORDER, TABLE_LEFT_BORDER);
  //origin = new Query(table, "JFK", "FLL", "MKT_CARRIER");
  //String[] entryArray = {"WN", "B6", "AS"};
  //String independentVariable = "MKT_CARRIER";
  //int[][] unreliability = {origin.unreliable(entryArray, "DEP_TIME", independentVariable), origin.unreliable(entryArray, "CANCELLED", independentVariable),
  //  origin.unreliable(entryArray, "DIVERTED", independentVariable)};

  //barScreen.addWidget(new BarChart(10, 10, 500, 250, "Airport", "Flights", unreliability[0], entryArray ));
  //origin.frequencyDays(1, 10);
  //origin.getFlight("AS");
  bigFont = loadFont(BIG_FONT);
  smallFont = loadFont(SMALL_FONT);
  textFont(bigFont);

  activeScreen = tableScreen;

}

void draw() {
  background(BACKGROUND_COLOR);
  activeScreen.draw();
  // departureInput.draw(activeScreen.getX(), activeScreen.getY());
  // returnInput.draw(activeScreen.getX(), activeScreen.getY());
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
    } else if (key == 'm') {
      activeScreen = barScreen;
    } else if (key == 'n') {
      activeScreen = tableScreen;
    } else if (key == 'k') {
      gTable.filter(searchField.getInput(), search.getInput());
    }
  } else {
    selectedWidget.event(activeScreen.getX(), activeScreen.getY(), mouseX, mouseY, false);
  }
}

void mousePressed() {
  ArrayList<Widget> screenWidgets = activeScreen.getWidgets();


  for (Widget widget : screenWidgets) {
    widget.event(activeScreen.getX(), activeScreen.getY(), mouseX, mouseY, true);
  }
}
// written by James McNamee
//ArrayList<DataPoint> queryDateRange(ArrayList<DataPoint> dataSet, Date startDate, Date endDate)
//{
//    ArrayList<DataPoint> results = new ArrayList<>();
//    for (DataPoint dataPoint : dataSet)
//   {
//        Date flightDate = dataPoint.getDate();
//        if (flightDate.after(startDate) && flightDate.before(endDate))
//        {
//            results.add(dataPoint);
//        }
//    }
//    return results;
//}
