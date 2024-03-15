
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

  int getYear() {
    return year;
  }

  String toString() {
    return (day<10?"0":"")+day+"/"+(month<10?"0":"")+month+"/"+year;
  }
}

class Time {
  //written by Danila Romanenko


      println(category1 + category2);
    }
  }


  int getHour() {
    return hour;
  }

  int getMinute() {
    return minute;
  }

  String toString() {
    return (hour<10?"0":"")+hour+":"+(minute<10?"0":"")+minute;
  }
}

class Airport {
  //written by Danila Romanenko

  String code;
  String cityName;
  String state;
  String WAC;

  Airport(String code, String cityName, String state, String WAC) {
    this.code = code;
    this.cityName = cityName;
    this.state = state;
    this.WAC = WAC;
  }

  String getCode() {
    return code;
  }

  String getCityName() {
    return cityName;
  }

  String getState() {
    return state;
  }

  String getWAC() {
    return WAC;
  }
  
  String toString(){
    return code+", "+cityName+", "+state+", "+WAC;
  }
}

class DataPoint {
  //written by Danila Romanenko
  
  Date date; //date of flight
  String IATA; //carrier code
  int flightNumber; //flight number
  Airport origin; //airport of origin
  Airport destination; //destination airport
  Time CRSDepTime; //scheduled departure time
  Time DepTime; //actual departure time
  Time CRSArrTime; //scheduled arrival time
  Time ArrTime; //actual arrival time
  boolean cancelled; //if flight was cancelled
  boolean diverted; //if flight was diverted
  int distance; //distance between airports in miles

  DataPoint(Date date, String IATA, int flightNumber, Airport origin, Airport destination, Time CRSDepTime, Time DepTime, Time CRSArrTime, Time ArrTime, boolean cancelled, boolean diverted, int distance) {
    this.date = date;
    this.IATA = IATA;
    this.flightNumber = flightNumber;
    this.origin = origin;
    this.destination = destination;
    this.CRSDepTime = CRSDepTime;
    this.DepTime = DepTime;
    this.CRSArrTime = CRSArrTime;
    this.ArrTime = ArrTime;
    this.cancelled = cancelled;
    this.diverted = diverted;
    this.distance = distance;
  }

  DataPoint(String data) {
    String[] parts = data.split(",\\s*(?=([^\"]*\"[^\"]*\")*[^\"]*$)");
    date = new Date(parts[0]);
    IATA = parts[1];
    flightNumber = Integer.parseInt(parts[2]);
    origin = new Airport(parts[3], parts[4], parts[5], parts[6]);
    destination = new Airport(parts[7], parts[8], parts[9], parts[10]);
    CRSDepTime = new Time(parts[11]);
    DepTime = new Time(parts[12]);
    CRSArrTime = new Time(parts[13]);
    ArrTime = new Time(parts[14]);
    cancelled = parts[15] == "1";
    diverted = parts[16] == "1";
    distance = Integer.parseInt(parts[17]);
  }
  
  String toString(){
    return date+", "+IATA+", "+flightNumber+", "+origin+", "+destination+", "+CRSDepTime+", "+DepTime+", "+CRSArrTime+", "+ArrTime+", "+distance;
  }
}
