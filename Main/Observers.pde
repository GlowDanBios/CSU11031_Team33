interface ButtonObserver {
  void buttonClicked(Button button);
}

class SortClick implements ButtonObserver {
  TableView table;

  SortClick(TableView table) {
    this.table = table;
  }
  void buttonClicked(Button button) {
    table.sort(button.text);
  }
}

class SearchFilter implements ButtonObserver {
  TableView table;

  SearchFilter(TableView table) {
    this.table = table;
  }
  void buttonClicked(Button button) {
    if (button.text.equals("Search")) {
      table.filter(columnSelect.getSelectedOption(), search.getInput());
    } else if (button.text.equals("Clear")) {
      table.clear();
      columnSelect.clear();
      search.clear();
    }
  }
}

class QueryShow implements ButtonObserver {
  TableView table;
  Screen oldScreen;

  QueryShow(TableView table) {
    this.table = table;
  }

  void buttonClicked(Button button) {
    oldScreen = activeScreen;
    if (button.text.equals("Display cancelled flights")) {
      Screen newScreen = new Screen(TABLE_TOP_BORDER, TABLE_LEFT_BORDER);
      ArrayList<String> airports = new ArrayList<String>();
      String[] originCol = table.displayedTable.getStringColumn("ORIGIN");
      for (String s : originCol) {
        if (!airports.contains(s)) airports.add(s);
      }
      Button b = new Button(10, 10, 100, 30, "Close");
      b.addObserver(new CloseButton(oldScreen));
      b.setColor(color(255));
      newScreen.addWidget(b);
      BarChart barChart;
      int barWidth = (airports.size()/5)*200;
      int barHeight = (airports.size()/5)*70;
      if (barWidth<MIN_BAR_WIDTH) barWidth = MIN_BAR_WIDTH;
      if (barWidth>MAX_BAR_WIDTH) barWidth = MAX_BAR_WIDTH;
      if (barHeight<MIN_BAR_HEIGHT) barHeight = MIN_BAR_HEIGHT;
      if (barHeight>MAX_BAR_HEIGHT) barHeight = MAX_BAR_HEIGHT;
      barChart = new BarChart(10, 60, barWidth, barHeight, "Origin Airport", "Cancelled flights", unreliable(table.displayedTable, airports.toArray(new String[airports.size()]), "DEP_TIME", "ORIGIN"), airports.toArray(new String[airports.size()]));
      newScreen.addWidget(barChart);
      activeScreen = newScreen;
    } else if (button.text.equals("Display delayed flights")) {
      Screen newScreen = new Screen(TABLE_TOP_BORDER, TABLE_LEFT_BORDER);
      ArrayList<String> airports = new ArrayList<String>();
      String[] originCol = table.displayedTable.getStringColumn("ORIGIN");
      for (String s : originCol) {
        if (!airports.contains(s)) airports.add(s);
      }
      Button b = new Button(10, 10, 100, 30, "Close");
      b.addObserver(new CloseButton(oldScreen));
      b.setColor(color(255));
      newScreen.addWidget(b);
      BarChart barChart;
      int barWidth = (airports.size()/5)*200;
      int barHeight = (airports.size()/5)*70;
      if (barWidth<MIN_BAR_WIDTH) barWidth = MIN_BAR_WIDTH;
      if (barWidth>MAX_BAR_WIDTH) barWidth = MAX_BAR_WIDTH;
      if (barHeight<MIN_BAR_HEIGHT) barHeight = MIN_BAR_HEIGHT;
      if (barHeight>MAX_BAR_HEIGHT) barHeight = MAX_BAR_HEIGHT;
      barChart = new BarChart(10, 60, barWidth, barHeight, "Origin Airport", "Cancelled flights", unreliable(table.displayedTable, airports.toArray(new String[airports.size()]), "", "ORIGIN"), airports.toArray(new String[airports.size()]));
      newScreen.addWidget(barChart);
      activeScreen = newScreen;
    } else if (button.text.equals("Display flights by days of the week")) {
      if (startDateVerify.isCorrect() && endDateVerify.isCorrect()) {
        Screen newScreen = new Screen(TABLE_TOP_BORDER, TABLE_LEFT_BORDER);
        Button b = new Button(10, 10, 100, 30, "Close");
        b.addObserver(new CloseButton(oldScreen));
        b.setColor(color(255));
        newScreen.addWidget(b);
        BarChart barChart;
        int[] frequency = frequencyDays(table.displayedTable, startDateInput.getInput(), endDateInput.getInput());
        barChart = new BarChart(10, 60, 800, 500, "Number of flights", "Day of the week", frequency, new String[]{"Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday"});
        newScreen.addWidget(barChart);
        activeScreen = newScreen;
      }
    }
  }
}

class CloseButton implements ButtonObserver {
  Screen oldScreen;

  CloseButton(Screen screen) {
    oldScreen = screen;
  }

  void buttonClicked(Button button) {
    activeScreen = oldScreen;
  }
}

class MapButton implements ButtonObserver {
  Screen oldScreen;
  TableRow flight;

  MapButton(Screen screen, TableRow flight) {
    oldScreen = screen;
    this.flight = flight;
  }

  void buttonClicked(Button button) {
    oldScreen = activeScreen;
    Screen newScreen = new Screen(TABLE_TOP_BORDER, TABLE_LEFT_BORDER);
    Button b = new Button(10, 10, 100, 30, "Close");
    b.addObserver(new CloseButton(oldScreen));
    b.setColor(color(255));
    newScreen.addWidget(b);
    activeScreen = mapScreen;
  }
}

class TableShow implements ButtonObserver {
  Screen oldScreen;
  TableView table;

  TableShow(TableView table) {
    this.table = table;
  }

  void buttonClicked(Button button) {
    //oldScreen = activeScreen;
    //Screen newScreen = new Screen(TABLE_TOP_BORDER, TABLE_LEFT_BORDER);
    //Button b = new Button(10, 10, 100, 30, "Close");
    //b.addObserver(new CloseButton(oldScreen));
    //newScreen.addWidget(b);
    //newScreen.addWidget(table);
    //activeScreen = newScreen;
    activeScreen = tableScreen;
  }
}
