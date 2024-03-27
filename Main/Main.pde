Table table;
TableView gTable;
Screen tableScreen;
Screen barScreen;
Screen activeScreen;
Widget selectedWidget;
Button searchButton;
Query origin;

void settings() {
  size(WINDOW_WIDTH, WINDOW_HEIGHT);
}

void setup () {
  table = loadTable("Files/flights2k.csv", "header");

  tableScreen = new Screen(TABLE_TOP_BORDER, TABLE_LEFT_BORDER);
  //tableScreen.addWidget(new Input(10, 0, 300, 30));
  //searchButton = new Button(350, 0, 50, 30, "Search");
  //tableScreen.addWidget(searchButton);
  //departureInput = new Input(10, 0, 100, 30);
  //tableScreen.addWidget(departureInput);
  //returnInput = new Input(120, 0, 100, 30);
  //tableScreen.addWidget(returnInput);
  
  gTable = new TableView(table, 0, 50);
  tableScreen.addWidget(gTable);
  
  barScreen = new Screen(TABLE_TOP_BORDER, TABLE_LEFT_BORDER);
  //barScreen.addWidget(new Input(10, 400, 300, 30));
  //barScreen.addWidget(new Button(360, 400, 100, 30, "Add airport"));
  origin = new Query(table, "JFK", "FLL", "ORIGIN");
  barScreen.addWidget(new BarChart(10,10,500,250, "Airport", "Flights", new int[]{origin.getFlight("SEA"), origin.getFlight("FLL"), origin.getFlight("DCA")}, new String[]{"SEA", "FLL", "DCA"}));
  
  PFont font = loadFont("AgencyFB-Bold-20.vlw");
  textFont(font);
  
  activeScreen = tableScreen;
  //ButtonClick observer = new ButtonClick(); 
  //searchButton.addObserver(observer); 
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
