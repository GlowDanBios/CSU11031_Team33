class Widget {
  int x, y;

  Widget(int x, int y) {
    this.x = x;
    this.y = y;
  }

  void draw(int x, int y) {
  }
}

class TableView extends Widget {
  Table table;
  int[] columnStarts;
  int x, y;

  TableView(Table table, int x, int y) {
    super(x, y);
    this.table = table;
    setColumnWidths();
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
        columnStarts[i] = columnStarts[i-1]+previousWidth*CHARACTER_WIDTH;
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
