Table table;
TableView gTable;
Screen controlsScreen;
Screen tableScreen;
Screen barScreen;
Screen activeScreen;
Screen mapScreen;
Widget selectedWidget;
Button searchButton;
Button clearButton;
Button cancelledButton;
Button delayedButton;
Button weekDaysButton;
Button showTableButton;
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
Map USAMap;
AirportsList airportsList;
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

int rowX, rowStart, rowHeight;
boolean keyW = false;
boolean keyA = false;
boolean keyS = false;
boolean keyD = false;
//import processing.sound.*;
//SoundFile file;

//PImage[] clouds = new PImage[6];
//PImage plane;

//int cloudCount = 6;
//Cloud[] cloudObjects = new Cloud[cloudCount];
//Plane planeObject;
//color bgColor1 = color(250);
//color bgColor = color(255); // Background color to remove

//// Screen states
//final int HOME_SCREEN = 0;
//final int GRAPHS_SCREEN = 1;
//final int TABLE_SCREEN = 2;

//int currentScreen = HOME_SCREEN;

//Buttons graphsButton;
//Buttons tableButton;
//Buttons homeButton;

void settings() {
  size(WINDOW_WIDTH, WINDOW_HEIGHT);
}

void setup () {
  println("Start");
  // Load flight data from the specified CSV file
  table = loadTable("Files/"+MAIN_FILE_NAME, "header");
  println("Download done");
  // Initialize the main screen for displaying flight data
  rowX = WINDOW_WIDTH/3;
  rowStart = WINDOW_HEIGHT/5;
  rowHeight = WINDOW_HEIGHT/20;
  tableScreen = new Screen(TABLE_TOP_BORDER, TABLE_LEFT_BORDER);
  controlsScreen = new Screen(TABLE_TOP_BORDER, TABLE_LEFT_BORDER);
  searchField = new Input(rowX+110, rowStart, 200, 30, "Column name");  // Initialize search input and button
  search = new Input(rowX+320, rowStart, 200, 30, "Search value");
  controlsScreen.addWidget(search); // Add UI elements to the main screen
  controlsScreen.addWidget(searchField);  // Add UI elements to the main screen
  searchButton = new Button(rowX+560, rowStart, 50, 30, "Search");
  searchButton.setColor(color(255));
  controlsScreen.addWidget(searchButton);  // Add UI elements to the main screen
  clearButton = new Button(rowX+620, rowStart, 50, 30, "Clear");
  clearButton.setColor(color(255));
  controlsScreen.addWidget(clearButton);  // Add UI elements to the main screen
  cancelledButton = new Button(rowX, rowStart+rowHeight*2, 160, 30, "Display cancelled flights");
  cancelledButton.setColor(color(255));
  controlsScreen.addWidget(cancelledButton);
  delayedButton = new Button(880, 0, 160, 30, "Display delayed flights");
  delayedButton.setColor(color(255));
  //controlsScreen.addWidget(delayedButton); // Add UI elements to the main screen
  startDateInput = new Input(rowX+120, rowStart+rowHeight, 200, 30, "Start date");
  controlsScreen.addWidget(startDateInput);  // Add UI elements to the main screen
  startDateVerify = new DateVerify(startDateInput, "Correct", "Wrong date format");
  controlsScreen.addWidget(startDateVerify);  // Add UI elements to the main screen
  endDateInput = new Input(rowX+350, rowStart+rowHeight, 200, 30, "End date");
  controlsScreen.addWidget(endDateInput);  // Add UI elements to the main screen
  endDateVerify = new DateVerify(endDateInput, "Correct", "Wrong date format");
  controlsScreen.addWidget(endDateVerify);  // Add UI elements to the main screen
  weekDaysButton = new Button(rowX+200, rowStart+rowHeight*2, 200, 30, "Display flights by days of the week");
  weekDaysButton.setColor(color(255));
  controlsScreen.addWidget(weekDaysButton);  // Add UI elements to the main screen
  showTableButton = new Button(rowX+430, rowStart+rowHeight*2, 150, 30, "Display table entries");
  showTableButton.setColor(color(255));
  controlsScreen.addWidget(showTableButton);
  filterText = new Text(rowX, rowStart+20, "Filter entries: ");
  controlsScreen.addWidget(filterText);  // Add UI elements to the main screen
  weekdaysText = new Text(rowX, rowStart+rowHeight+20, "Enter date range: ");
  controlsScreen.addWidget(weekdaysText);  // Add UI elements to the main screen


  // Set the active screen to the main table screen
  activeScreen = controlsScreen;

  // Initialize the table view for displaying flight data
  gTable = new TableView(table, 0, 100);
  tableScreen.addWidget(gTable);
  searchButton.addObserver(new SearchFilter(gTable));  // Add event listeners to buttons
  clearButton.addObserver(new SearchFilter(gTable));
  cancelledButton.addObserver(new QueryShow(gTable));
  delayedButton.addObserver(new QueryShow(gTable));
  weekDaysButton.addObserver(new QueryShow(gTable));
  showTableButton.addObserver(new TableShow(gTable));




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

  // Set up fonts for text rendering
  bigFont = loadFont(BIG_FONT);
  mediumFont = loadFont(MEDIUM_FONT);
  smallFont = loadFont(SMALL_FONT);
  textFont(bigFont);
  <<<<<<< HEAD
    =======

    // Set the active screen to the main table screen
    activeScreen = tableScreen;

  //loadClouds();
  //file = new SoundFile(this, "background.mp3");
  //file.play();
  //file.amp(0.5);
  //for (int i = 0; i < cloudCount; i++) {
  //  int randomIndex = int(random(clouds.length));
  //  cloudObjects[i] = new Cloud(clouds[randomIndex]);
  //}

  //plane = loadImage("plane.jpg"); // Load your plane image
  //removeBackground(plane); // Remove background from plane image
  //planeObject = new Plane(plane);

  //graphsButton = new Buttons("Graphs", width/2 - 300, height-500);
  //tableButton = new Buttons("Table", width/2 + 300, height-500);
  >>>>>>> d2433aa9e19a14d4a13503eaf47351cee57706b5
}

void draw() {
  background(BACKGROUND_COLOR);
  activeScreen.draw();
  <<<<<<< HEAD

    if (activeScreen == controlsScreen) {
    text("Flights found: "+gTable.displayedTable.getRowCount(), activeScreen.getX()+rowX+700, activeScreen.getY()+rowStart+20);
  }

  //activeScreen.screenMove();
  =======
    // departureInput.draw(activeScreen.getX(), activeScreen.getY());
    // returnInput.draw(activeScreen.getX(), activeScreen.getY());

    //background(135, 206, 235); // Sky Blue

    //if (currentScreen == HOME_SCREEN) {
    //  drawHomeScreen();
    //} else if (currentScreen == GRAPHS_SCREEN) {
    //  // Draw the graphs screen
    //  drawGraphsScreen();
    //} else if (currentScreen == TABLE_SCREEN) {
    //  // Draw the table screen
    //  drawTableScreen();
    //}

    activeScreen.screenMove();
  >>>>>>> d2433aa9e19a14d4a13503eaf47351cee57706b5
    if (activeScreen == mapScreen) {
    airportsList.displayAirports();
    la.connectAirports(la, austin);
  }
}
/**
 Handles keyboard input.
 Allows scrolling the active screen and switching between screens.
 */
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

  //if (currentScreen == HOME_SCREEN) {
  //  if (graphsButton.isClicked()) {
  //    currentScreen = GRAPHS_SCREEN;
  //  } else if (tableButton.isClicked()) {
  //    currentScreen = TABLE_SCREEN;
  //  }
  //} else {
  //  if (homeButton.isClicked()) {
  //    currentScreen = HOME_SCREEN;
  //  }
  //}
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
//void drawHomeScreen() {
//  for (int i = 0; i < cloudCount; i++) {
//    cloudObjects[i].display();
//    cloudObjects[i].move();
//  }
//  planeObject.display();
//  planeObject.move();

//  graphsButton.display();
//  tableButton.display();
//}

//void drawGraphsScreen() {
//  // Draw the graphs screen
//  background(255); // White background
//  textSize(32);
//  fill(0);



//  // Draw home button
//  homeButton = new Buttons("Home", 100, 50);
//  homeButton.display();
//}

//void drawTableScreen() {
//  // Draw the table screen
//  background(255); // White background
// activeScreen.draw();
//  homeButton = new Buttons("Home", 50, 50);
//  homeButton.display();
//}
