Table table;


void setup (){
size(400,400);
table = loadTable("flights2k(1).csv", "header");
println(table.getRowCount());
  
  specificEntry dest = new specificEntry(table, "ORIGIN", "JFK");
  dest.getFlights();
 
}
