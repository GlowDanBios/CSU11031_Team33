class Query {
  String origin1;
  String origin2;
  String category;

  Query(Table table1, String Origin1, String Origin2, String Category) {
    table = table1;
    origin1 = Origin1;
    origin2 = Origin2;
    category = Category;
  }

  int getFlight(String entry) {
    int i = 0;
    for (TableRow row : table.findRows(entry, category)) {
      i++;
    }
    return i;
  }

  void chart() {
    int first = getFlight(origin1);
    int second = getFlight(origin2);
    //stroke(0);
    //fill(225);
    //rect(70, 70, 200, 300);
    //fill(255, 0, 0);
    //rect(120, 120, (first), 40);
    //fill(0, 255, 0);
    //rect(120, 180, (second), 40);
    
  }
}