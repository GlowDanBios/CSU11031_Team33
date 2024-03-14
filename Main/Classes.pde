class Date {
  //written by Danila Romanenko
  
  int day;
  int month;
  int year;

  Date(int day, int month, int year) {
    this.day = day;
    this.month = month;
    this.year = year;
  }

  Date(String date) {
    day = Integer.parseInt(date.substring(0, 2));
    month = Integer.parseInt(date.substring(3, 5));
    year = Integer.parseInt(date.substring(6, 10));
  }

  int getDay() {
    return day;
  }

  int getMonth() {
    return month;
  }

  int getYear() {
    return year;
  }

  String toString() {
    return (day<10?"0":"")+day+"/"+(month<10?"0":"")+month+"/"+year;
  }
}

class Time {
  //written by Danila Romanenko

  int hour;
  int minute;

  Time(int hour, int minute) {
    this.hour = hour;
    this.minute = minute;
  }

  Time(String time) {
    if (time.length() == 4) {
      hour = Integer.parseInt(time.substring(0, 2));
      minute = Integer.parseInt(time.substring(2, 4));
    } else if (time.length() == 3) {
      hour = Integer.parseInt(time.substring(0, 1));
      minute = Integer.parseInt(time.substring(1, 3));
    } else {
      hour = 0;
      minute = 0;
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
