
class specificEntry{
Table table;
String entry;
String category;

  specificEntry(Table table1, String category1, String desiredEntry){  
    table = table1;
    entry = desiredEntry;
    category = category1;
  }
 
  void getFlights(){
    for (TableRow row : table.findRows(entry, category)){
      String source = row.getString("ORIGIN_CITY_NAME");
     String data = row.getString("DEST_CITY_NAME");

     println(source + data);
    }
  }
}
