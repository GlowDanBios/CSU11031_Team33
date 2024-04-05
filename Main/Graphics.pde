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

  void draw(int x, int y) {
    image(mapImage, 50, 10, 1000, 800);
  }
}
class Airport {

  int x, y;

  Airport(int x, int y) {
    this.x = x;
    this.y = y;
  }

  void draw(int x, int y) {
    fill(245, 158, 66);
    ellipse(this.x, this.y, 15, 15);
  }
  int getX() {
    return x;
  }
  int getY() {
    return y;
  }

  void connectAirports(Airport airportA, Airport airportB) {
    stroke(191, 19, 19);
    strokeWeight(4);
    line(airportA.x, airportA.y, airportB.x, airportB.y);
  }
}


class AirportsList {
  ArrayList<Airport> points = new ArrayList<>();
  AirportsList() {
  }

  void addAirport(Airport airport) {
    points.add(airport);
  }
  void displayAirports() {
    for (Airport airport : points) {
      airport.draw(airport.getX(), airport.getY());
    }
    System.out.println("hey");
  }
  ArrayList<Airport> getPoints() {
    return points;
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

class PageClick implements ButtonObserver {
  TableView table;

  PageClick(TableView table) {
    this.table = table;
  }

  void buttonClicked(Button button) {
    if (button.text.equals("Back")) {
      if (table.currentPage>0) table.currentPage--;
    } else if (button.text.equals("Next")) {
      if (table.currentPage<table.displayedTable.getRowCount()/FLIGHTS_PER_PAGE) table.currentPage++;
    }
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
