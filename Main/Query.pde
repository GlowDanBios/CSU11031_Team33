import java.util.Collections;
import java.util.Comparator;

class Query {
  String origin1;
  String origin2;
  String category;
  String[] popularAirports;

  Query(Table table1, String Origin1, String Origin2, String Category) {
    table = table1;
    origin1 = Origin1;
    origin2 = Origin2;
    category = Category;
    popularAirports = popularAirports(10);

  }

  int getFlight(String entry, String category) {
    int i = 0;
    for (TableRow row : table.findRows(entry, category)) {
      i++;
    }
    return i;
  }

  int[] unreliable(Table table, String[] indVariable, String cat, String type) {
    int[] delays  = new int[indVariable.length];
    for (int i=0; i<indVariable.length; i++) {
      if (cat == "DEP_TIME") {
        delays[i] = delayedFlight(table, indVariable[i], type);
      } else {
        delays[i] = cancelledDivertedFLights(table, indVariable[i], cat, type);
      }
    }
    for (int i=0; i<delays.length; i++) {
    }
    return delays;
  }

  int delayedFlight(Table table, String indVariable, String type) {
    int delayed = 0;
    for (TableRow row : table.findRows(indVariable, type)) {
      if (row.getInt("DEP_TIME") > row.getInt("CRS_DEP_TIME")) {
        delayed += 1;
      }
    }
    return delayed;
  }

  int cancelledDivertedFLights(Table table, String indVariable, String cat, String type) {
    int amountInstances = 0;
    for (TableRow row : table.findRows(indVariable, type)) {
      if (row.getInt(cat) ==1) {
        amountInstances += 1;
      }
    }
    return amountInstances;
  }


  int[] frequencyDays(int startDate, int endDate) {
    int monday = 0;
    int tuesday = 0;
    int wednesday = 0;
    int thursday = 0;
    int friday = 0;
    int saturday = 0;
    int sunday = 0;
    String date = "";
    for (int i =0; i<=table.getRowCount()-1; i++) {
      TableRow row = table.getRow(i);
      date = row.getString("FL_DATE");
      String[] parts = date.split("/");
      int day = Integer.parseInt(parts[1]);
      if (day>= startDate && day<= endDate) {
        if ((day%7) == 1) {
          saturday ++;
        }
        if ((day%7)==2) {
          sunday++;
        }
        if ((day%7)==3) {
          monday++;
        }
        if ((day%7)==4) {
          tuesday++;
        }
        if ((day%7)==5) {
          wednesday++;
        }
        if ((day%7)==6) {
          thursday++;
        }
        if ((day%7)==0) {
          friday++;
        }
      }
    }
    int[] frequencyByDay = {monday, tuesday, wednesday, thursday, friday, saturday, sunday};
    for (int i=0; i<7; i++) {
      println(frequencyByDay[i]);
    }
    return frequencyByDay;
  }
  String[] popularAirports(int numAirports){
    ArrayList<CustomItem> airportList = new ArrayList<>();
    ArrayList<String> airports = new ArrayList<>();
    for(int i=0; i<table.getRowCount(); i++){
      String airport = table.getString(i, "ORIGIN");
      boolean inList = false;
      for(int j=0; j<airports.size(); j++){
        if (airport.equals(airports.get(j))){
          inList = true;
          break;
        }
      }
      if(!inList){
        airportList.add(new CustomItem(airport, getFlight(airport, "ORIGIN")));
        airports.add(airport);
      }     
    }

     String[] sortedList = new String[numAirports];
    Collections.sort(airportList, (item1, item2) -> item2.getIntValue() - item1.getIntValue());
    for(int k=0; k<numAirports; k++){
       CustomItem item = airportList.get(k);
       sortedList[k] = item.getString();
    }

    return sortedList;  
  }
  
  int[] intValuesPopularflights(int numberAirports){
      int[] values = new int[numberAirports];
      String[] airportNames = popularAirports(numberAirports);
      for(int i=0; i<numberAirports; i++){
        values[i] = getFlight(airportNames[i], "ORIGIN");
      }
      return values;
  }
  String[] getPopularAirports () {
    return popularAirports;
}
  
}
static int[] unreliable(Table table, String[] indVariable, String cat, String type) {
  int[] delays  = new int[indVariable.length];
  for (int i=0; i<indVariable.length; i++) {
    if (cat == "DEP_TIME") {
      delays[i] = delayedFlight(table, indVariable[i], type);
    } else {
      delays[i] = cancelledDivertedFLights(table, indVariable[i], cat, type);
    }
  }
  for (int i=0; i<delays.length; i++) {
  }
  return delays;
}

static int delayedFlight(Table table, String indVariable, String type) {
  int delayed = 0;
  for (TableRow row : table.findRows(indVariable, type)) {
    if (row.getInt("DEP_TIME") > row.getInt("CRS_DEP_TIME")) {
      delayed += 1;
    }
  }
  return delayed;
}

static int cancelledDivertedFLights(Table table, String indVariable, String cat, String type) {
  int amountInstances = 0;
  for (TableRow row : table.findRows(indVariable, type)) {
    if (row.getInt(cat) ==1) {
      amountInstances += 1;
    }
  }
  return amountInstances;
}

static int[] frequencyDays(Table table, String startDat, String endDat) {
  int monday = 0;
  int tuesday = 0;
  int wednesday = 0;
  int thursday = 0;
  int friday = 0;
  int saturday = 0;
  int sunday = 0;
  String date = "";
  int startDate = Integer.parseInt(startDat.split("/")[1]);
  int endDate = Integer.parseInt(endDat.split("/")[1]);
  for (int i =0; i<=table.getRowCount()-1; i++) {
    TableRow row = table.getRow(i);
    date = row.getString("FL_DATE");
    String[] parts = date.split("/");
    int day = Integer.parseInt(parts[1]);
    if (day>= startDate && day<= endDate) {
      if ((day%7) == 1) {
        saturday ++;
      }
      if ((day%7)==2) {
        sunday++;
      }
      if ((day%7)==3) {
        monday++;
      }
      if ((day%7)==4) {
        tuesday++;
      }
      if ((day%7)==5) {
        wednesday++;
      }
      if ((day%7)==6) {
        thursday++;
      }
      if ((day%7)==0) {
        friday++;
      }
    }
  }
  int[] frequencyByDay = {monday, tuesday, wednesday, thursday, friday, saturday, sunday};
  for (int i=0; i<7; i++) {
    println(frequencyByDay[i]);
  }
  return frequencyByDay;
}

class CustomItem {
    private String string;
    private int intValue;

    public CustomItem(String string, int intValue) {
        this.string = string;
        this.intValue = intValue;
    }

    public String getString() {
        return string;
    }

    public int getIntValue() {
        return intValue;
    }
}
