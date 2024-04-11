import processing.sound.*;
SoundFile file;
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
Button showMapButton;
Input search;
Input searchField;
Input startDateInput;
Input endDateInput;
Dropdown columnSelect;
Slider airportSlider;
DateVerify startDateVerify;
DateVerify endDateVerify;
Query origin;
Query initAirports;
Text filterText;
Text weekdaysText;
Text airportsText;
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
Airport denver;
Airport charlotte;
Airport chicago;
Airport honolulu;
Airport ny;
Airport seattle;
Airport nashville;
Airport washington;
Airport detroit;
Airport newark;
Airport fortLauderdale;
Airport houston;
Airport juneau;
Airport vegas;
Airport orlando;
Airport sanFrancisco;
Airport portland;
Airport kahului;
Airport sanJuan;
Airport ketchikan;
Airport phoenix;
Airport dallas;
PImage mapImage;

int rowX, rowStart, rowHeight;
boolean keyW = false;
boolean keyA = false;
boolean keyS = false;
boolean keyD = false;
PImage[] clouds = new PImage[6];
PImage plane;
PImage startButton;

int cloudCount = 6;
Cloud[] cloudObjects = new Cloud[cloudCount];
Plane planeObject;
color bgColor1 = color(250);
color bgColor = color(255); // Background color to remove

// Screen states
final int HOME_SCREEN = 0;
final int GRAPHS_SCREEN = 1;


int currentScreen = HOME_SCREEN;

Buttons graphsButton;

void settings() {
  size(WINDOW_WIDTH, WINDOW_HEIGHT);
}

void setup () {
  println("Start");
  // Load flight data from the specified CSV file
  table = loadTable("Files/"+MAIN_FILE_NAME, "header");
  mapImage = loadImage("Files/USA-Country-Outline.jpg");
  println("Download done");
  // Initialize the main screen for displaying flight data
  rowX = WINDOW_WIDTH/3;
  rowStart = WINDOW_HEIGHT/5;
  rowHeight = WINDOW_HEIGHT/20;


  tableScreen = new Screen(TABLE_TOP_BORDER, TABLE_LEFT_BORDER);
  controlsScreen = new Screen(TABLE_TOP_BORDER, TABLE_LEFT_BORDER);

  initAirports = new Query(table, "", "", "ORIGIN");


  //First row
  //searchField = new Input(rowX+110, rowStart, 200, 30, "Column name");  // Initialize search input and button
  search = new Input(rowX+320, rowStart, 200, 30, "Search value");
  controlsScreen.addWidget(search); // Add UI elements to the main screen
  //controlsScreen.addWidget(searchField);  // Add UI elements to the main screen
  searchButton = new Button(rowX+560, rowStart, 50, 30, "Search");
  controlsScreen.addWidget(searchButton);  // Add UI elements to the main screen
  clearButton = new Button(rowX+620, rowStart, 50, 30, "Clear");
  controlsScreen.addWidget(clearButton);  // Add UI elements to the main screen

  //Second row
  weekdaysText = new Text(rowX, rowStart+rowHeight+20, "Enter date range: ");
  controlsScreen.addWidget(weekdaysText);  // Add UI elements to the main screen
  startDateInput = new Input(rowX+120, rowStart+rowHeight, 200, 30, "Start date");
  controlsScreen.addWidget(startDateInput);  // Add UI elements to the main screen
  startDateVerify = new DateVerify(startDateInput, "Correct", "Wrong date format");
  controlsScreen.addWidget(startDateVerify);  // Add UI elements to the main screen
  endDateInput = new Input(rowX+350, rowStart+rowHeight, 200, 30, "End date");
  controlsScreen.addWidget(endDateInput);  // Add UI elements to the main screen
  endDateVerify = new DateVerify(endDateInput, "Correct", "Wrong date format");
  controlsScreen.addWidget(endDateVerify);  // Add UI elements to the main screen

  //Third row
  airportsText = new Text(rowX, rowStart+rowHeight*2+20, "Select the number of airports to be displayed: ");
  controlsScreen.addWidget(airportsText);
  airportSlider = new Slider(rowX+300, rowStart+rowHeight*2, 200, 30, 1, 20);
  controlsScreen.addWidget(airportSlider);

  //Fourth row
  cancelledButton = new Button(rowX, rowStart+rowHeight*4, 160, 30, "Display cancelled flights");
  controlsScreen.addWidget(cancelledButton);
  weekDaysButton = new Button(rowX+200, rowStart+rowHeight*4, 200, 30, "Display flights by days of the week");
  controlsScreen.addWidget(weekDaysButton);  // Add UI elements to the main screen
  showMapButton = new Button(rowX+440, rowStart+rowHeight*4, 190, 30, "Show popular airports on a map");
  controlsScreen.addWidget(showMapButton);
  showTableButton = new Button(rowX+670, rowStart+rowHeight*4, 150, 30, "Display table entries");
  controlsScreen.addWidget(showTableButton);


  filterText = new Text(rowX, rowStart+20, "Filter entries: ");
  controlsScreen.addWidget(filterText);  // Add UI elements to the main screen



  String[] columnTitles = new String[table.getColumnCount()+1];
  columnTitles[0] = "Choose column name";
  for (int i = 0; i<table.getColumnCount(); i++) {
    columnTitles[i+1] = table.getColumnTitle(i);
  }
  columnSelect = new Dropdown(rowX+110, rowStart, 200, 30, columnTitles);
  controlsScreen.addWidget(columnSelect);

  // Set the active screen to the main table screen
  activeScreen = controlsScreen;

  // Initialize the table view for displaying flight data
  gTable = new TableView(table, 0, 100);
  tableScreen.addWidget(gTable);
  Button b = new Button(10, 10, 100, 30, "Close");
  b.addObserver(new CloseButton(controlsScreen));
  tableScreen.addWidget(b);
  searchButton.addObserver(new SearchFilter(gTable));  // Add event listeners to buttons
  clearButton.addObserver(new SearchFilter(gTable));
  cancelledButton.addObserver(new QueryShow(gTable));
  //delayedButton.addObserver(new QueryShow(gTable));
  weekDaysButton.addObserver(new QueryShow(gTable));
  showTableButton.addObserver(new TableShow(gTable));
  showMapButton.addObserver(new MapButton());




  mapScreen = new Screen(TABLE_TOP_BORDER, TABLE_LEFT_BORDER);
  mapScreen.addWidget(b);
  USAMap = new Map(10, 50);
   atlanta = new Airport(atlantaX, atlantaY, "ATL", "Atlanta, GA");
  anchorage = new Airport(anchorageX, anchorageY, "ANC", "Anchorage, AK");
  albany = new Airport(albanyX, albanyY, "ALB", "Albany, NY");
  boston = new Airport(bostonX, bostonY, "BOS", "Boston, MA");
  albuquerque = new Airport(albuquerqueX, albuquerqueY, "ABQ", "Albuquerque, NM");
  austin = new Airport(austinX, austinY, "AUS", "Austin, TX");
  baltimore = new Airport(baltimoreX, baltimoreY, "BWI", "Baltimore, ML");
  bozeman = new Airport(bozemanX, bozemanY, "BZN", "Bozeman, MT");
  la = new Airport(laX, laY, "LAX", "Los Angeles, CA");
  dallas = new Airport(dallasX, dallasY, "DAL", "Dallas, TX");
  denver = new Airport(denverX, denverY, "DEN", "Denver, CO");
  charlotte = new Airport(charlotteX, charlotteY, "CLT", "Charlotte, NC");
  chicago = new Airport(chicagoX, chicagoY, "ORD", "Chicago, IL");
  honolulu = new Airport(honoluluX, honoluluY, "HNL", "Honolulu, HI");
  ny = new Airport(nyX, nyY, "JFK", "New York, NY");
  seattle = new Airport(seattleX, seattleY, "SEA", "Seattle, WA");
  nashville = new Airport(nashvilleX, nashvilleY, "BNA", "Nashville, TN");
  washington = new Airport(washingtonX, washingtonY, "IAD", "Washington, DC");
  detroit = new Airport(detroitX, detroitY, "DTW", "Detroit, MI");
  newark = new Airport(newarkX, newarkY, "EWR", "Newark, NJ");
  fortLauderdale = new Airport(fortLauderdaleX, fortLauderdaleY, "FLL", "Fort Lauderdale, FL");
  houston = new Airport(houstonX, houstonY, "HOU", "Houston, TX");
  juneau = new Airport(juneauX, juneauY, "JNU", "Juneau, AK");
  vegas = new Airport(vegasX, vegasY, "LAS", "Las Vegas, NV");
  orlando = new Airport(orlandoX, orlandoY, "MCO", "Orlando, FL");
  sanFrancisco = new Airport(sanFranciscoX, sanFranciscoY, "SFO", "San Francisco, CA");
  portland = new Airport(portlandX, portlandY, "PDX", "Portland, Oregon");
  kahului = new Airport(kahuluiX, kahuluiY, "OGG", "Kahului, HI");
  sanJuan = new Airport(sanJuanX, sanJuanY, "SJU", "San Juan, PR");
  ketchikan = new Airport(ketchikanX, ketchikanY, "KTN", "Ketchikan, AK");
  phoenix = new Airport(phoenixX, phoenixY, "PHX", "Phoenix, AZ");
  dallasFW = new Airport(dallasX, dallasY, "DFW", "Dallas, TX");
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
  airportsList.addAirport(dallas);
  airportsList.addAirport(charlotte);
  airportsList.addAirport(denver);
  airportsList.addAirport(chicago);
  airportsList.addAirport(honolulu);
  airportsList.addAirport(ny);
  airportsList.addAirport(seattle);
  airportsList.addAirport(nashville);
  airportsList.addAirport(washington);
  airportsList.addAirport(detroit);
  airportsList.addAirport(newark);
  airportsList.addAirport(fortLauderdale);
  airportsList.addAirport(houston);
  airportsList.addAirport(juneau);
  airportsList.addAirport(vegas);
  airportsList.addAirport(orlando);
  airportsList.addAirport(sanFrancisco);
  airportsList.addAirport(portland);
  airportsList.addAirport(kahului);
  airportsList.addAirport(sanJuan);
  airportsList.addAirport(ketchikan);
  airportsList.addAirport(phoenix);
  airportsList.addAirport(dallas);
  airportsList.addAirport(dallasFW);
  mapScreen.addWidget(USAMap);

  // Set up fonts for text rendering
  bigFont = loadFont(BIG_FONT);
  mediumFont = loadFont(MEDIUM_FONT);
  smallFont = loadFont(SMALL_FONT);
  textFont(bigFont);
 for (int i = 0; i < cloudCount; i++) {
    clouds[i] = loadImage("cloud.jpg");
  }

  // Create cloud objects
  for (int i = 0; i < cloudCount; i++) {
    cloudObjects[i] = new Cloud(clouds[i]);
    removeBackground(clouds[i]);
  }



   // Load the plane image and create the plane object
   
  plane = loadImage("plane.jpg");
  removeBackground(plane);
  planeObject = new Plane(plane);
  startButton = loadImage("startButton.jpg");
  // Setup buttons
  removeBackground(startButton);
  graphsButton = new Buttons(startButton,width/2-150, height/2+200, 300, 150);


   //Setup sound file
  file = new SoundFile(this, "background.mp3");
  file.play();
  file.amp(0.1);
}

void draw() {
 
  background(135, 206, 235); // Sky Blue
  
  if (currentScreen == HOME_SCREEN) {
    drawHomeScreen();
  } else if (currentScreen == GRAPHS_SCREEN) {
    // Draw the graphs screen
    drawGraphsScreen();
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
    } else if (key == 'b') {
      activeScreen = mapScreen;
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
   if (currentScreen == HOME_SCREEN) {
    if (graphsButton.isClicked()) {
      currentScreen = GRAPHS_SCREEN;
    } 
  }
}
