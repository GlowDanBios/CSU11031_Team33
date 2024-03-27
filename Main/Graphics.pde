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

class TableView extends Widget {
  Table table;
  Table displayedTable;
  int[] columnStarts;
  String sortedBy;
  boolean sortReverse = false;
  Button[] columnNames;

  TableView(Table table, int x, int y) {
    super(x, y);
    this.table = table;
    displayedTable = cleanData(table);
    setColumnWidths();
    clickable = false;
    columnNames = new Button[displayedTable.getColumnCount()];
    for (int i = 0; i<displayedTable.getColumnCount(); i++) {
      columnNames[i] = new Button(x+columnStarts[i], y-ROW_HEIGHT, columnStarts[i+1]-columnStarts[i]-10, ROW_HEIGHT, displayedTable.getColumnTitle(i));
      SortClick obs = new SortClick(this);
      tableScreen.addWidget(columnNames[i]);
      columnNames[i].addObserver(obs);
    }
  }

  void setColumnWidths() {
    columnStarts = new int[displayedTable.getColumnCount()+1];
    int previousWidth = 0;
    for (int i = 0; i <displayedTable.getColumnCount()+1; i++) {
      int width;
      if (i<displayedTable.getColumnCount())
        width = (int)textWidth(displayedTable.getColumnTitle(i));
      else {
        columnStarts[i] = columnStarts[i-1]+previousWidth;
        return;
      }
      String[] col = displayedTable.getStringColumn(i);
      for (int j = 0; j<col.length; j++) {
        if ((int)textWidth(col[j])>width) width = (int)textWidth(col[j]);
      }
      if (i==0) {
        columnStarts[i] = 0;
      } else {
        columnStarts[i] = columnStarts[i-1]+previousWidth+COLUMN_SPACE;
      }
      previousWidth = width;
    }
  }

  void draw(int screenX, int screenY) {
    fill(TEXT_COLOR);
    for (int i = 0; i <displayedTable.getColumnCount(); i++) {
      if (sortedBy!=null && sortedBy.equals(columnNames[i].text)) {
        if (sortReverse) {
          columnNames[i].setColor(color(200, 0, 0, 100));
        } else {
          columnNames[i].setColor(color(0, 200, 0, 100));
        }
      } else {
        columnNames[i].setColor(255);
      }
      columnNames[i].draw(screenX, screenY);
      String[] col = displayedTable.getStringColumn(i);
      for (int j = 0; j<col.length; j++) {
        if (i == 1) {
          if (isCancelled(col[j])) {
            fill(200, 0, 0, 100);
            rect(screenX+x, screenY+y+20+j*ROW_HEIGHT, columnStarts[columnStarts.length-1], ROW_HEIGHT);
            fill(TEXT_COLOR);
          } else if (isDiverted(col[j])) {
            fill(200, 200, 0, 100);
            rect(screenX+x, screenY+y+20+j*ROW_HEIGHT, columnStarts[columnStarts.length-1], ROW_HEIGHT);
            fill(TEXT_COLOR);
          }
        }

        text(col[j], screenX+x+columnStarts[i], screenY+y+ROW_HEIGHT+j*20);
      }
    }
  }


  Table cleanData(Table originalTable) {
    Table returnTable = new Table();
    returnTable.addColumn("FL_DATE");
    returnTable.addColumn("MKT_CARRIER");
    returnTable.addColumn("ORIGIN");
    returnTable.addColumn("ORIGIN_CITY_NAME");
    returnTable.addColumn("ORIGIN_STATE_ABR");
    returnTable.addColumn("ORIGIN_WAC", Table.INT);
    returnTable.addColumn("DEST");
    returnTable.addColumn("DEST_CITY_NAME");
    returnTable.addColumn("DEST_STATE_ABR");
    returnTable.addColumn("DEST_WAC", Table.INT);
    returnTable.addColumn("CRS_DEP_TIME");
    returnTable.addColumn("DEP_TIME");
    returnTable.addColumn("CRS_ARR_TIME");
    returnTable.addColumn("ARR_TIME");
    returnTable.addColumn("DISTANCE", Table.INT);
    for (int i = 0; i<originalTable.getRowCount(); i++) {
      TableRow row = originalTable.getRow(i);
      TableRow newRow = returnTable.addRow();
      newRow.setString("FL_DATE", row.getString("FL_DATE").substring(0, 11));
      newRow.setString("MKT_CARRIER", row.getString("MKT_CARRIER")+row.getString("MKT_CARRIER_FL_NUM"));
      newRow.setString("ORIGIN", row.getString("ORIGIN"));
      newRow.setString("ORIGIN_CITY_NAME", row.getString("ORIGIN_CITY_NAME"));
      newRow.setString("ORIGIN_STATE_ABR", row.getString("ORIGIN_STATE_ABR"));
      newRow.setInt("ORIGIN_WAC", Integer.parseInt(row.getString("ORIGIN_WAC")));
      newRow.setString("DEST", row.getString("DEST"));
      newRow.setString("DEST_CITY_NAME", row.getString("DEST_CITY_NAME"));
      newRow.setString("DEST_STATE_ABR", row.getString("DEST_STATE_ABR"));
      newRow.setInt("DEST_WAC", Integer.parseInt(row.getString("DEST_WAC")));
      newRow.setString("CRS_DEP_TIME", row.getString("CRS_DEP_TIME"));
      newRow.setString("DEP_TIME", row.getString("DEP_TIME"));
      newRow.setString("CRS_ARR_TIME", row.getString("CRS_ARR_TIME"));
      newRow.setString("ARR_TIME", row.getString("ARR_TIME"));
      newRow.setInt("DISTANCE", Integer.parseInt(row.getString("DISTANCE")));
    }
    return returnTable;
  }

  boolean isCancelled(String carr) {
    String carrier = carr.substring(0, 2);
    String flNum = carr.substring(2);

    for (TableRow row : table.findRows(carrier, "MKT_CARRIER")) {
      if (row.getString("MKT_CARRIER_FL_NUM").equals(flNum)) return row.getString("CANCELLED").equals("1");
    }
    return false;
  }
  boolean isDiverted(String carr) {
    String carrier = carr.substring(0, 2);
    String flNum = carr.substring(2);
    for (TableRow row : table.findRows(carrier, "MKT_CARRIER")) {
      if (row.getString("MKT_CARRIER_FL_NUM").equals(flNum)) return row.getString("DIVERTED").equals("1");
    }
    return false;
  }

  void sort(String col) {
    if (sortedBy == null) {
      displayedTable.sort(col);
      sortedBy = col;
    } else if (sortedBy.equals(col)) {
      sortReverse = !sortReverse;
      if (sortReverse) {
        displayedTable.sortReverse(col);
      } else {
        displayedTable = cleanData(table);
        sortedBy = null;
      }
    } else {
      displayedTable = cleanData(table);
      displayedTable.sort(col);
      sortedBy = col;
    }
  }
}

class Input extends Widget {
  String inputString;
  int width, height;
  int cursorLocation;
  boolean selected;

  int blink;

  Input(int x, int y, int width, int height) {
    super(x, y);
    this.width = width;
    this.height = height;
    inputString = "";
    clickable = true;
  }

  boolean clicked(int screenX, int screenY, int mouseX, int mouseY) {
    return mouseX>screenX+x && mouseX<screenX+x+width && mouseY>screenY+y && mouseY<screenY+y+height;
  }

  void event(int screenX, int screenY, int mouseX, int mouseY, boolean click) {
    if (click) {
      if (clicked(screenX, screenY, mouseX, mouseY)) {
        selected = true;
        selectedWidget = this;
        blink = 0;
      } else {
        selected = false;
        selectedWidget = null;
      }
    } else {
      if (selected) {
        if (keyCode ==8) {
          if (inputString.length()>0) {
            inputString = inputString.substring(0, inputString.length()-1);
          }
        } else if (key!=CODED) {
          inputString += key;
        }
      }
    }
  }

  void draw(int screenX, int screenY) {
    fill(BACKGROUND_COLOR);
    stroke(0);

    rect(screenX+x, screenY+y, width, height);
    fill(0);
    text(inputString.substring(textWidth(inputString)>width?lastEl():0), screenX+x+2, screenY+y+height/2+2);
    if (selected) {
      fill(0);
      if (blink<BLINK_INTERVAL) line(screenX+x+(textWidth(inputString)>width?width-1:textWidth(inputString)+1), screenY+y+5, screenX+x+(textWidth(inputString)>width?width-1:textWidth(inputString)+1), screenY+y+height-5);
      else if (blink>BLINK_INTERVAL*2) blink = 0;
      blink++;
    }
  }


  int lastEl() {
    for (int i = inputString.length()-1; i>0; i--) {
      if (textWidth(inputString.substring(i))>width) {
        return i+1;
      }
    }
    return 0;
  }

  String getInput() {
    return inputString;
  }
}

class BarChart extends Widget {
  Bar[] bars;
  int width, height;
  int colSpace;
  int colWidth;
  String xAxis, yAxis;

  BarChart(int x, int y, int width, int height, String xAxis, String yAxis, int[] values, String names[]) {
    super(x, y);
    this.width = width;
    this.height = height;
    this.xAxis= xAxis;
    this.yAxis = yAxis;
    int colNum = values.length;
    colWidth = (int)((width/colNum)/1.2);
    colSpace = colWidth/5;
    int maxVal = max(values);
    bars = new Bar[colNum];
    for (int i = 0; i <values.length; i++) {
      bars[i] = new Bar(values[i], color(100, 0, 0), colWidth, (int)(((float)values[i]/maxVal)*0.9*height), names[i], height);
    }
  }

  void draw(int screenX, int screenY) {
    line(screenX+x, screenY+y, screenX+x, screenY+y+height);
    line(screenX+x, screenY+y+height, screenX+x+width, screenY+y+height);
    for (int i =0; i<bars.length; i++) {
      bars[i].draw(screenX+x+20+i*(colSpace+colWidth), screenY+y, screenX+x);
    }
    text(xAxis, screenX+x-textWidth(xAxis)/2, screenY+y);
    text(yAxis, screenX+width, screenY+y+height+15);
  }
}

class Bar {
  int value;
  color c;
  int width, height;
  int chartHeight;
  String name;

  Bar(int value, color c, int width, int height, String name, int chartHeight) {
    this.value = value;
    this.c = c;
    this.width = width;
    this.height = height;
    this.name = name;
    this.chartHeight = chartHeight;
  }

  void draw(int x, int y, int chartStart) {
    fill(c);
    rect(x, y+(chartHeight-height), width, height);
    text(name, x, y+chartHeight+20);
    text(value, chartStart-textWidth(String.valueOf(value))-1, y+(chartHeight-height));
  }
}

interface ButtonObserver {
  void buttonClicked(Button button);
}

class Button extends Widget {
  ArrayList<ButtonObserver> observers;
  String text;
  int width, height;
  color c;

  Button(int x, int y, int width, int height, String text) {
    super(x, y);
    this.width = width;
    this.height = height;
    this.text = text;
    observers = new ArrayList<ButtonObserver>();
  }

  void draw(int screenX, int screenY) {
    fill(c);
    rect(screenX+x, screenY+y, width, height);
    fill(0);
    text(text, screenX+x, screenY+y+3*height/4);
  }
  void addObserver(ButtonObserver observer) {
    observers.add(observer);
  }
  void removeObserver(ButtonObserver observer) {
    observers.remove(observer);
  }

  void notifyObservers() {
    for (ButtonObserver observer : observers) {
      observer.buttonClicked(this);
    }
  }

  void setColor(color c) {
    this. c = c;
  }

  boolean clicked(int screenX, int screenY, int mouseX, int mouseY) {
    return mouseX>screenX+x && mouseX<screenX+x+width && mouseY>screenY+y && mouseY<screenY+y+height;
  }

  void event(int screenX, int screenY, int mouseX, int mouseY, boolean click) {
    if (click) {
      if (clicked(screenX, screenY, mouseX, mouseY)) {
        notifyObservers();
      }
    }
  }
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
