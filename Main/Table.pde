class TableView extends Widget {
  Table table;
  Table displayedTable;
  Table beforeSortTable;
  int[] columnStarts;
  int currentPage;
  String sortedBy;
  boolean sortReverse = false;
  Button[] columnNames;
  Button forwardPage;
  Button backPage;
  ArrayList<Button> mapButtons;

  TableView(Table table, int x, int y) {
    super(x, y);
    currentPage = 0;
    this.table = table;
    displayedTable = cleanData(table);
    setColumnWidths();
    clickable = false;
    columnNames = new Button[displayedTable.getColumnCount()];
    for (int i = 0; i<displayedTable.getColumnCount(); i++) {
      columnNames[i] = new Button(x+columnStarts[i], y-ROW_HEIGHT, columnStarts[i+1]-columnStarts[i], ROW_HEIGHT, displayedTable.getColumnTitle(i));
      SortClick obs = new SortClick(this);
      tableScreen.addWidget(columnNames[i]);
      columnNames[i].addObserver(obs);
    }
    forwardPage = new Button(x+columnStarts[columnStarts.length-1]/2, y+ROW_HEIGHT*FLIGHTS_PER_PAGE+1, 40, 30, "Next");
    forwardPage.addObserver(new PageClick(this));
    backPage = new Button(x+columnStarts[columnStarts.length-1]/2-170, y+ROW_HEIGHT*FLIGHTS_PER_PAGE+1, 40, 30, "Back");
    backPage.addObserver(new PageClick(this));
    //setupMapButtons();
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
      for (int j = FLIGHTS_PER_PAGE*currentPage; j<FLIGHTS_PER_PAGE*(currentPage+1); j++) {
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

  void setupMapButtons() {
    mapButtons = new ArrayList<Button>();
    for (int i = FLIGHTS_PER_PAGE*currentPage; i<FLIGHTS_PER_PAGE*(currentPage+1); i++) {
      Button b = new Button(x+columnStarts[columnStarts.length-1], y+i*ROW_HEIGHT, 40, ROW_HEIGHT, "MAP");
      b.addObserver(new MapButton(activeScreen, table.getRow(i)));
      b.setColor(color(255));
      mapButtons.add(b);
    }
  }


  void draw(int screenX, int screenY) {
    text("Displayed flights: "+displayedTable.getRowCount(), screenX+x, screenY+y-ROW_HEIGHT*1.5);
    for (int i = 0; i <displayedTable.getColumnCount(); i++) {
      fill(TEXT_COLOR);
      line(screenX+x+columnStarts[i], screenY+y, screenX+x+columnStarts[i], screenY+y+ROW_HEIGHT*FLIGHTS_PER_PAGE);
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
      int lastRow = FLIGHTS_PER_PAGE*(currentPage+1)<displayedTable.getRowCount()?FLIGHTS_PER_PAGE*(currentPage+1):displayedTable.getRowCount();
      for (int j = FLIGHTS_PER_PAGE*currentPage; j<lastRow; j++) {
        if (i == 1) {
          if (isCancelled(col[j])) {
            fill(200, 0, 0, 100);
            rect(screenX+x, screenY+y+20+j%FLIGHTS_PER_PAGE*ROW_HEIGHT, columnStarts[columnStarts.length-1], ROW_HEIGHT);
            fill(TEXT_COLOR);
          } else if (isDiverted(col[j])) {
            fill(200, 200, 0, 100);
            rect(screenX+x, screenY+y+20+j%FLIGHTS_PER_PAGE*ROW_HEIGHT, columnStarts[columnStarts.length-1], ROW_HEIGHT);
            fill(TEXT_COLOR);
          }
          //mapButtons.get(j).draw(screenX, screenY);
        }
        line(screenX+x, screenY+y+j%FLIGHTS_PER_PAGE*ROW_HEIGHT, screenX+x+columnStarts[columnStarts.length-1], screenY+y+j%FLIGHTS_PER_PAGE*ROW_HEIGHT);
        if (i<10 || i>13) {
          text(col[j], screenX+x+columnStarts[i], screenY+y+ROW_HEIGHT+j%FLIGHTS_PER_PAGE*20);
        } else {
          String a = ""+col[j];
          if (a.length()==1) {
            a = "00:0"+a;
          } else if (a.length()==2) {
            a = "00:"+a;
          } else if (a.length() == 3) {
            a = "0"+a.substring(0, 1)+":"+a.substring(1);
          } else {
            a = a.substring(0, 2)+":"+a.substring(2);
          }
          text(a, screenX+x+columnStarts[i], screenY+y+ROW_HEIGHT+j%FLIGHTS_PER_PAGE*20);
        }
      }
    }
    if (currentPage<displayedTable.getRowCount()/FLIGHTS_PER_PAGE)
      forwardPage.draw(screenX, screenY);
    if (currentPage>0)
      backPage.draw(screenX, screenY);
    text("Page "+currentPage+" out of "+displayedTable.getRowCount()/FLIGHTS_PER_PAGE, screenX+forwardPage.x-120, screenY+forwardPage.y+20);
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
    returnTable.addColumn("CRS_DEP_TIME", Table.INT);
    returnTable.addColumn("DEP_TIME", Table.INT);
    returnTable.addColumn("CRS_ARR_TIME", Table.INT);
    returnTable.addColumn("ARR_TIME", Table.INT);
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
      newRow.setInt("CRS_DEP_TIME", Integer.parseInt(row.getString("CRS_DEP_TIME")));
      newRow.setInt("DEP_TIME", row.getString("DEP_TIME").length()>0?Integer.parseInt(row.getString("DEP_TIME")):0);
      newRow.setInt("CRS_ARR_TIME", Integer.parseInt(row.getString("CRS_ARR_TIME")));
      newRow.setInt("ARR_TIME", row.getString("ARR_TIME").length()>0?Integer.parseInt(row.getString("ARR_TIME")):0);
      newRow.setInt("DISTANCE", (int)Float.parseFloat(row.getString("DISTANCE")));
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
      beforeSortTable = displayedTable.copy();
      displayedTable.sort(col);
      sortedBy = col;
    } else if (sortedBy.equals(col)) {
      sortReverse = !sortReverse;
      if (sortReverse) {
        displayedTable.sortReverse(col);
      } else {
        displayedTable = beforeSortTable;
        sortedBy = null;
      }
    } else {
      displayedTable = beforeSortTable;
      displayedTable.sort(col);
      sortedBy = col;
    }
    //setupMapButtons();
  }

  void filter(String column, String query) {
    boolean flag = false;
    for (String col : displayedTable.getColumnTitles()) {
      if (column.toUpperCase().equals(col)) {
        flag = true;
        break;
      }
    }
    if (!flag) return;
    displayedTable = new Table(displayedTable.matchRows("^.*"+query.toUpperCase()+".*$", column.toUpperCase()));
    //setupMapButtons();
  }

  void clear() {
    sortedBy = null;
    displayedTable = cleanData(table);
    setupMapButtons();
  }

  void event(int screenX, int screenY, int mouseX, int mouseY, boolean click) {
    //for (Button b : mapButtons) {
    //  b.event(screenX, screenY, mouseX, mouseY, click);
    //}
    forwardPage.event(screenX, screenY, mouseX, mouseY, click);
    backPage.event(screenX, screenY, mouseX, mouseY, click);
  }
}
