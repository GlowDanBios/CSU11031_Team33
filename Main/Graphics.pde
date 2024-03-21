class Widget {
  int x, y;
  boolean clickable;

  Widget(int x, int y) {
    this.x = x;
    this.y = y;
  }

  void draw(int x, int y) {
  }

  boolean clicked(int screenX, int screenY, int mouseX, int mouseY) {
    return false;
  }

  void select() {
  }

  void unselect() {
  }

  void enter(char key) {
  }
}

class TableView extends Widget {
  Table table;
  int[] columnStarts;

  TableView(Table table, int x, int y) {
    super(x, y);
    this.table = table;
    setColumnWidths();
    clickable = false;
  }

  void setColumnWidths() {
    columnStarts = new int[table.getColumnCount()];
    int previousWidth = 0;
    for (int i = 0; i <table.getColumnCount(); i++) {
      int width = table.getColumnTitle(i).length();
      String[] col = table.getStringColumn(i);
      for (int j = 0; j<col.length; j++) {
        if (col[j].length()>width) width = col[j].length();
      }
      if (i==0) {
        columnStarts[i] = 0;
      } else {
        columnStarts[i] = columnStarts[i-1]+previousWidth*CHARACTER_WIDTH+COLUMN_SPACE;
      }
      previousWidth = width;
    }
  }

  void draw(int screenX, int screenY) {
    fill(TEXT_COLOR);
    for (int i = 0; i <table.getColumnCount(); i++) {
      text(table.getColumnTitle(i), screenX+x+columnStarts[i], screenY+y);
      String[] col = table.getStringColumn(i);
      for (int j = 0; j<col.length; j++) {
        text(col[j], screenX+x+columnStarts[i], screenY+y+20+j*20);
      }
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

  void select() {
    selected = true;
    blink = 0;
  }

  void unselect() {
    selected = false;
  }

  void enter(char key) {
    if (keyCode ==8) {
      if (inputString.length()>0) {
        inputString = inputString.substring(0, inputString.length()-1);
      }
    } else if (key!=CODED) {
      inputString += key;
    }
  }

  void draw(int screenX, int screenY) {
    fill(BACKGROUND_COLOR);
    stroke(0);

    rect(screenX+x, screenY+y, width, height);
    fill(0);
    text(inputString, screenX+x+2, screenY+y+height/2+2);
    if (selected) {
      fill(0);
      if (blink<BLINK_INTERVAL) line(screenX+x+inputString.length()*CHARACTER_WIDTH+5, screenY+y+5, screenX+x+inputString.length()*CHARACTER_WIDTH+5, screenY+y+height-5);
      else if (blink>BLINK_INTERVAL*2) blink = 0;
      blink++;
    }
  }

  boolean clicked(int screenX, int screenY, int mouseX, int mouseY) {
    return mouseX>screenX+x && mouseX<screenX+x+width && mouseY>screenY+y && mouseY<screenY+y+height;
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

  BarChart(int x, int y, int width, int height, int[] values, String names[]) {
    super(x, y);
    this.width = width;
    this.height = height;
    int colNum = values.length;
    colWidth = (int)((width/colNum)/1.2);
    colSpace = colWidth/5;
    int maxVal = max(values);
    bars = new Bar[colNum];
    for (int i = 0; i <values.length; i++) {
      bars[i] = new Bar(values[i], color(100, 0, 0), colWidth, (int)(((float)values[i]/maxVal)*height), names[i], height);
    }
  }

  void draw(int screenX, int screenY) {
    line(screenX+x, screenY+y, screenX+x, screenY+y+height);
    line(screenX+x, screenY+y+height, screenX+x+width, screenY+y+height);
    for (int i =0; i<bars.length; i++) {
      bars[i].draw(screenX+x+20+i*(colSpace+colWidth), screenY+y, screenX+x);
    }
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
    text(name, x, y+chartHeight+15);
    text(value, chartStart-15, y+(chartHeight-height));
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
