class Widget {
  int x, y;
  boolean clickable;

  Widget(int x, int y) {
    this.x = x;
    this.y = y;
  }

  void draw(int x, int y) {
  }

  void event(int screenX, int screenY, int mouseX, int mouseY, boolean click) {
  }
}


void screenMove() {
  if (selectedWidget == null) {
    if (keyW && !keyA && !keyS && !keyD) {
      if (activeScreen.getY()+SCROLL_SPEED<TABLE_TOP_BORDER)
        activeScreen.move(activeScreen.getX(), activeScreen.getY()+SCROLL_SPEED);
    } else if (!keyW && keyA && !keyS && !keyD) {
      if (activeScreen.getX()+SCROLL_SPEED<TABLE_LEFT_BORDER)
        activeScreen.move(activeScreen.getX()+SCROLL_SPEED, activeScreen.getY());
    } else if (!keyW && !keyA && keyS && !keyD) {
      activeScreen.move(activeScreen.getX(), activeScreen.getY()-SCROLL_SPEED);
    } else if (!keyW && !keyA && !keyS && keyD) {
      activeScreen.move(activeScreen.getX()-SCROLL_SPEED, activeScreen.getY());
    } else if (keyW && keyA && !keyS && !keyD) {
      activeScreen.move(activeScreen.getX()+SCROLL_SPEED, activeScreen.getY()+SCROLL_SPEED);
    } else if (keyW && !keyA && !keyS && keyD) {
      activeScreen.move(activeScreen.getX()-SCROLL_SPEED, activeScreen.getY()+SCROLL_SPEED);
    } else if (!keyW && keyA && keyS && !keyD) {
      activeScreen.move(activeScreen.getX()+SCROLL_SPEED, activeScreen.getY()-SCROLL_SPEED);
    } else if (!keyW && !keyA && keyS && keyD) {
      activeScreen.move(activeScreen.getX()-SCROLL_SPEED, activeScreen.getY()-SCROLL_SPEED);
    } else if (key == 'm') {
      activeScreen = barScreen;
    } else if (key == 'n') {
      activeScreen = tableScreen;
    } else if (key == 'b') {
      activeScreen = mapScreen;
    } else if (key == 'k') {
      gTable.filter(searchField.getInput(), search.getInput());
    }
  } else {
    selectedWidget.event(activeScreen.getX(), activeScreen.getY(), mouseX, mouseY, false);
  }
}
class Map extends Widget {

  Map(int x, int y) {
    super(x, y);
    ArrayList<Airport> points = new ArrayList<Airport>();
  }

  void draw(int screenX, int screenY) {
    println(screenX);
    println(y);
    image(mapImage, screenX+x, screenY+y, 1000, 800);
  }
}
class Airport {

  int x, y;
  String code, cityName;

  Airport(int x, int y, String code, String cityName) {
    this.x = x;
    this.y = y;
    this.code = code;
    this.cityName = cityName;
  }

  void draw(int screenX, int screenY) {
    fill(245, 158, 66);
    ellipse(activeScreen.getX()+x, activeScreen.getY()+y, 15, 15);
    text(cityName, activeScreen.getX()+x, activeScreen.getY()+y+20);
    
  }
  int getX() {
    return x;
  }
  int getY() {
    return y;
  }
  String getCode() {
    return code; 
  }

  void connectAirports(Airport airportA, Airport airportB) {
    stroke(191, 19, 19);
    strokeWeight(4);
    line(airportA.x, airportA.y, airportB.x, airportB.y);
  }
  
  void getTopAirports(int n, String []popularAirports) {
    String[] top5Airports = new String[n];
    arrayCopy(popularAirports, 0, top5Airports, 0, n);
    ArrayList<Airport> top5AirportsObj = new ArrayList<Airport>();
    top5AirportsObj = airportsList.mostPopularAirports(top5Airports);
    airportsList.displayAirports(top5AirportsObj);
}
}


class AirportsList {
  ArrayList<Airport> points = new ArrayList<>();
  AirportsList() {
  }

  void addAirport(Airport airport) {
    points.add(airport);
  }
  void displayAirports(ArrayList<Airport> top5Airports) {
    for (Airport airport : top5Airports) {
      airport.draw(airport.getX(), airport.getY());
    }
  }
  ArrayList<Airport> getPoints() {
    return points;
  }
  ArrayList<Airport> mostPopularAirports(String[]airportCodes ) {
    ArrayList<Airport> mostPopularAirports = new ArrayList<Airport>();
    for (int i = 0; i<airportCodes.length; i++) {
   for (Airport airports : points) {
    if ( airports.getCode().equalsIgnoreCase( airportCodes[i])) {
      mostPopularAirports.add(airports);
   }
  }
    }
    return mostPopularAirports;
}
}




class Text extends Widget {
  String txt;
  Text(int x, int y, String txt) {
    super(x, y);
    this.txt = txt;
  }

  void draw(int screenX, int screenY) {
    fill(TEXT_COLOR);
    text(txt, screenX+x, screenY+y);
  }
}



class Screen {
  int x, y;

  ArrayList<Widget> widgets;

  Screen(int x, int y) {
    this.x = x;
    this.y = y;
    widgets = new ArrayList<Widget>();
  }

  void addWidget(Widget widget) {
    widgets.add(widget);
  }

  void removeWidget(Widget widget) {
    widgets.remove(widget);
  }

  void move(int desX, int desY) {
    x = desX;
    y = desY;
  }

  int getX() {
    return x;
  }


  int getY() {
    return y;
  }

  ArrayList<Widget> getWidgets() {
    return widgets;
  }

  void draw() {
    for (Widget widget : widgets) {
      widget.draw(x, y);
    }
  }
}
