Table table;
TableView gTable;
Screen tableScreen;
Screen barScreen;
Screen activeScreen;
Widget selectedWidget;
Button searchButton;
Button clearButton;
Button unreliableButton;
Button weekDaysButton;
Input search;
Input searchField;
Input startDateInput;
Input endDateInput;
DateVerify startDateVerify;
DateVerify endDateVerify;
Query origin;
Text filterText;
Text weekdaysText;
PFont bigFont;
PFont mediumFont;
PFont smallFont;
Airport atlanta;
Airport anchorage;
Airport albany;
Airport boston;
Airport albuquerque;
Airport austin;
Airport baltimore;
Airport bozeman;
Airport la;
PImage mapImage;
 boolean keyW = false;
 boolean keyA = false;
 boolean keyS = false;
 boolean keyD = false;
 

void settings() {
  size(WINDOW_WIDTH, WINDOW_HEIGHT);
}

void setup () {
  println("Start");
  // Load flight data from the specified CSV file
  table = loadTable("Files/"+MAIN_FILE_NAME, "header");
  println("Download done");
  // Initialize the main screen for displaying flight data
  tableScreen = new Screen(TABLE_TOP_BORDER, TABLE_LEFT_BORDER);
  searchField = new Input(110, 0, 200, 30, "Column name");  // Initialize search input and button
  search = new Input(320, 0, 200, 30, "Search value");
  tableScreen.addWidget(search); // Add UI elements to the main screen
  tableScreen.addWidget(searchField);  // Add UI elements to the main screen
  searchButton = new Button(560, 0, 50, 30, "Search");
  searchButton.setColor(color(255));
  tableScreen.addWidget(searchButton);  // Add UI elements to the main screen
  clearButton = new Button(620, 0, 50, 30, "Clear");
  clearButton.setColor(color(255));
  tableScreen.addWidget(clearButton);  // Add UI elements to the main screen
  unreliableButton = new Button(700, 0, 160, 30, "Display cancelled flights");
  unreliableButton.setColor(color(255));
  tableScreen.addWidget(unreliableButton);  // Add UI elements to the main screen
  startDateInput = new Input(1000, 0, 200, 30, "Start date");
  tableScreen.addWidget(startDateInput);  // Add UI elements to the main screen
  startDateVerify = new DateVerify(startDateInput, "Correct", "Wrong date format");
  tableScreen.addWidget(startDateVerify);  // Add UI elements to the main screen
  endDateInput = new Input(1220, 0, 200, 30, "End date");
  tableScreen.addWidget(endDateInput);  // Add UI elements to the main screen
  endDateVerify = new DateVerify(endDateInput, "Correct", "Wrong date format");
  tableScreen.addWidget(endDateVerify);  // Add UI elements to the main screen
  weekDaysButton = new Button(1450, 0, 200, 30, "Display flights by days of the week");
  weekDaysButton.setColor(color(255));
  tableScreen.addWidget(weekDaysButton);  // Add UI elements to the main screen
  filterText = new Text(10, 20, "Filter entries: ");
  tableScreen.addWidget(filterText);  // Add UI elements to the main screen
  weekdaysText = new Text(890, 20, "Enter date range: ");
  tableScreen.addWidget(weekdaysText);  // Add UI elements to the main screen

  //departureInput = new Input(10, 0, 100, 30);
  //tableScreen.addWidget(departureInput);
  //returnInput = new Input(120, 0, 100, 30);
  //tableScreen.addWidget(returnInput);

  // Set the active screen to the main table screen
  activeScreen = tableScreen;

  // Initialize the table view for displaying flight data
  gTable = new TableView(table, 0, 100);
  tableScreen.addWidget(gTable);
  searchButton.addObserver(new SearchFilter(gTable));  // Add event listeners to buttons
  clearButton.addObserver(new SearchFilter(gTable));
  unreliableButton.addObserver(new QueryShow(gTable));
  weekDaysButton.addObserver(new QueryShow(gTable));


  //barScreen = new Screen(TABLE_TOP_BORDER, TABLE_LEFT_BORDER);
  ////barScreen.addWidget(new Input(10, 400, 300, 30));
  ////barScreen.addWidget(new Button(360, 400, 100, 30, "Add airport"));
  //origin = new Query(table, "JFK", "FLL", "ORIGIN");

 mapScreen = new Screen(TABLE_TOP_BORDER, TABLE_LEFT_BORDER);
  USAMap = new Map(60, 60);
  atlanta = new Airport(atlantaX, atlantaY);
  anchorage = new Airport(anchorageX, anchorageY);
  albany = new Airport(albanyX, albanyY);
  boston = new Airport(bostonX, bostonY);
   albuquerque = new Airport(albuquerqueX, albuquerqueY);
    austin = new Airport(austinX, austinY);
     baltimore = new Airport(baltimoreX, baltimoreY);
      bozeman = new Airport(bozemanX, bozemanY);
      la = new Airport(laX, laY);
  airportsList = new AirportsList();
  airportsList.addAirport(atlanta);
  airportsList.addAirport(anchorage);
  airportsList.addAirport(albany);
  airportsList.addAirport(boston);
  airportsList.addAirport(albuquerque);
  airportsList.addAirport(austin);
  airportsList.addAirport(baltimore);
  airportsList.addAirport(bozeman);
  airportsList.addAirport(la);
  mapScreen.addWidget(USAMap);

  //barScreen = new Screen(TABLE_TOP_BORDER, TABLE_LEFT_BORDER);
  //origin = new Query(table, "JFK", "FLL", "MKT_CARRIER");
  //String[] entryArray = {"WN", "B6", "AS"};
  //String independentVariable = "MKT_CARRIER";
  //int[][] unreliability = {origin.unreliable(entryArray, "DEP_TIME", independentVariable), origin.unreliable(entryArray, "CANCELLED", independentVariable),
  //  origin.unreliable(entryArray, "DIVERTED", independentVariable)};

  //barScreen.addWidget(new BarChart(10, 10, 500, 250, "Airport", "Flights", unreliability[0], entryArray ));
  //origin.frequencyDays(1, 10);
  //origin.getFlight("AS");
  // Set up fonts for text rendering
  bigFont = loadFont(BIG_FONT);
  mediumFont = loadFont(MEDIUM_FONT);
  smallFont = loadFont(SMALL_FONT);
  textFont(bigFont);

  
}

void draw() {
  background(BACKGROUND_COLOR);
  activeScreen.draw();
  // departureInput.draw(activeScreen.getX(), activeScreen.getY());
  // returnInput.draw(activeScreen.getX(), activeScreen.getY());
  activeScreen.screenMove();
  if (activeScreen == mapScreen) {
        airportsList.displayAirports();
        la.connectAirports(la, austin);
}
/**
 
 Handles keyboard input.
 Allows scrolling the active screen and switching between screens.
 */

void keyPressed() {
  void keyPressed() {
   if(key == 'w') keyW = true;
   if(key == 'a') keyA = true;
   if(key == 's') keyS = true;
   if(key == 'd') keyD = true;
}

   void keyReleased() {
     if(key == 'w') keyW = false;
   if(key == 'a') keyA =   false;
   if(key == 's') keyS =   false;
   if(key == 'd') keyD =   false;
   }

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
