Table table;


void setup (){
size(400,400);
table = loadTable("Files/flights2k.csv", "header");
println(table.getRowCount());
  
  specificEntry flight = new specificEntry(table, "ORIGIN", "JFK");
  flight.getFlights();
 
}
