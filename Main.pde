Table table;
TableView gTable;
Screen tableScreen;
Screen activeScreen;
Widget selectedWidget;
    boolean keyW = false;
    boolean keyA = false;
    boolean keyS = false;
    boolean keyD = false;

void settings() {
  size(WINDOW_WIDTH, WINDOW_HEIGHT);
}

void setup () {
  table = loadTable("Files/flights2k.csv", "header");

  tableScreen = new Screen(TABLE_TOP_BORDER, TABLE_LEFT_BORDER);
  tableScreen.addWidget(new Input(10, 0, 300, 30));
  gTable = new TableView(table, 0, 50);
  tableScreen.addWidget(gTable);
  activeScreen = tableScreen;
}

void draw() {
  background(BACKGROUND_COLOR);
  activeScreen.draw();
 screenMove();
}

void keyPressed() {
   if(key == 'w') keyW = true;
   if(key == 'a') keyA = true;
   if(key == 's') keyS = true;
   if(key == 'd') keyD = true;
}
   
   void keyReleased() {
     if(key == 'w') keyW = false;
   if(key == 'a') keyA =   false;
   if(key == 's') keyS =   false;
   if(key == 'd') keyD =   false;
   }
   void screenMove() {
  if (selectedWidget == null) {
   if(keyW && !keyA && !keyS && !keyD){
   if (activeScreen.getY()+SCROLL_SPEED<TABLE_TOP_BORDER)
   activeScreen.move(activeScreen.getX(), activeScreen.getY()+SCROLL_SPEED);
  }
  else if(!keyW && keyA && !keyS && !keyD){
  if (activeScreen.getX()+SCROLL_SPEED<TABLE_LEFT_BORDER)
  activeScreen.move(activeScreen.getX()+SCROLL_SPEED, activeScreen.getY());
  }
  else if(!keyW && !keyA && keyS && !keyD){
  activeScreen.move(activeScreen.getX(), activeScreen.getY()-SCROLL_SPEED);
  }
  else if(!keyW && !keyA && !keyS && keyD){
  activeScreen.move(activeScreen.getX()-SCROLL_SPEED, activeScreen.getY());
 }
 else if(keyW && keyA && !keyS && !keyD){
   activeScreen.move(activeScreen.getX()+SCROLL_SPEED, activeScreen.getY()+SCROLL_SPEED);
 }
 else if(keyW && !keyA && !keyS && keyD){
   activeScreen.move(activeScreen.getX()-SCROLL_SPEED, activeScreen.getY()+SCROLL_SPEED);
 }
  else if(!keyW && keyA && keyS && !keyD){
   activeScreen.move(activeScreen.getX()+SCROLL_SPEED, activeScreen.getY()-SCROLL_SPEED);
  }
   else if(!keyW && !keyA && keyS && keyD){
   activeScreen.move(activeScreen.getX()-SCROLL_SPEED, activeScreen.getY()-SCROLL_SPEED);
   }
  }
  else{
    selectedWidget.event(activeScreen.getX(), activeScreen.getY(), mouseX, mouseY, false);
    
  }
   }
void mousePressed() {
  ArrayList<Widget> screenWidgets = activeScreen.getWidgets();


  for (Widget widget : screenWidgets) {
    widget.event(activeScreen.getX(), activeScreen.getY(), mouseX, mouseY, true);
  }
}