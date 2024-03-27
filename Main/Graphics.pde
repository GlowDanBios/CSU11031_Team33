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

  TableView(Table table, int x, int y) {
    super(x, y);
    this.table = table;
    displayedTable = cleanData(table);
    setColumnWidths();
    clickable = false;
  }

  void setColumnWidths() {
    columnStarts = new int[displayedTable.getColumnCount()+1];
    int previousWidth = 0;
    for (int i = 0; i <displayedTable.getColumnCount()+1; i++) {
      int width;
      if(i<displayedTable.getColumnCount())
        width = (int)textWidth(displayedTable.getColumnTitle(i));
      else{
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
      if (i!=15 && i!=16)
        text(displayedTable.getColumnTitle(i), screenX+x+columnStarts[i], screenY+y);
      String[] col = displayedTable.getStringColumn(i);
      for (int j = 0; j<col.length; j++) {
        if (i == 1) {
          if (isCancelled(col[j])) {
            fill(200, 0, 0, 100);
            rect(screenX+x, screenY+y+20+j*20, columnStarts[columnStarts.length-1], 20);
            fill(TEXT_COLOR);
          } else if (isDiverted(col[j])) {
            fill(200, 200, 0, 100);
            rect(screenX+x, screenY+y+20+j*20, screenX+x+WINDOW_WIDTH, 20);
            fill(TEXT_COLOR);
          }
        }

        text(col[j], screenX+x+columnStarts[i], screenY+y+20+j*20);
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
    returnTable.addColumn("ORIGIN_WAC");
    returnTable.addColumn("DEST");
    returnTable.addColumn("DEST_CITY_NAME");
    returnTable.addColumn("DEST_STATE_ABR");
    returnTable.addColumn("DEST_WAC");
    returnTable.addColumn("CRS_DEP_TIME");
    returnTable.addColumn("DEP_TIME");
    returnTable.addColumn("CRS_ARR_TIME");
    returnTable.addColumn("ARR_TIME");
    returnTable.addColumn("DISTANCE");
    for (int i = 0; i<originalTable.getRowCount(); i++) {
      TableRow row = originalTable.getRow(i);
      TableRow newRow = returnTable.addRow();
      newRow.setString("FL_DATE", row.getString("FL_DATE").substring(0, 11));
      newRow.setString("MKT_CARRIER", row.getString("MKT_CARRIER")+row.getString("MKT_CARRIER_FL_NUM"));
      newRow.setString("ORIGIN", row.getString("ORIGIN"));
      newRow.setString("ORIGIN_CITY_NAME", row.getString("ORIGIN_CITY_NAME"));
      newRow.setString("ORIGIN_STATE_ABR", row.getString("ORIGIN_STATE_ABR"));
      newRow.setString("ORIGIN_WAC", row.getString("ORIGIN_WAC"));
      newRow.setString("DEST", row.getString("DEST"));
      newRow.setString("DEST_CITY_NAME", row.getString("DEST_CITY_NAME"));
      newRow.setString("DEST_STATE_ABR", row.getString("DEST_STATE_ABR"));
      newRow.setString("DEST_WAC", row.getString("DEST_WAC"));
      newRow.setString("CRS_DEP_TIME", row.getString("CRS_DEP_TIME"));
      newRow.setString("DEP_TIME", row.getString("DEP_TIME"));
      newRow.setString("CRS_ARR_TIME", row.getString("CRS_ARR_TIME"));
      newRow.setString("ARR_TIME", row.getString("ARR_TIME"));
      newRow.setString("DISTANCE", row.getString("DISTANCE"));
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

class Button extends Widget {
  String text;
  int width, height;

  Button(int x, int y, int width, int height, String text) {
    super(x, y);
    this.width = width;
    this.height = height;
    this.text = text;
  }

  void draw(int screenX, int screenY) {
    fill(255);
    rect(screenX+x, screenY+y, width, height);
    fill(0);
    text(text, screenX+x, screenY+y+height/2);
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
