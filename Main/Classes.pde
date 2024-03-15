
class specificEntry {
  Table table;
  String entry;
  String category;

  specificEntry(Table table1, String category1, String desiredEntry) {
    table = table1;
    entry = desiredEntry;
    category = category1;
  }

  void getFlights() {
    for (TableRow row : table.findRows(entry, category)) {
      String category1 = row.getString("ORIGIN_CITY_NAME");
      String category2 = row.getString("DEST_CITY_NAME");

      println(category1 + category2);
    }
  }
}
