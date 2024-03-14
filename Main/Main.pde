void settings() {
  size(windowWidth, windowHeight);
}

//variables:
ArrayList<DataPoint> data;


void setup() {
  background(backgroundColor);
  data = getAllFlights();
  for(DataPoint point:data){
    println(point.getString());
  }
}

void draw() {
  
}
