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
    println(i);
    return i;
  }
  
  int[] unreliable(String[] indVariable, String cat, String type){
    int[] delays  = new int[indVariable.length];
      for (int i=0; i<indVariable.length; i++){
            if(cat == "DEP_TIME"){
          delays[i] = delayedFlight(indVariable[i], type);
      }
      else{
        delays[i] = cancelledDivertedFLights(indVariable[i], cat, type);
      }
    }   
    for(int i=0; i<delays.length; i++){
    }
    return delays;
  }

  int delayedFlight(String indVariable, String type){
    int delayed = 0;
    for (TableRow row : table.findRows(indVariable, type)){
      if (row.getInt("DEP_TIME") > row.getInt("CRS_DEP_TIME")){
        delayed += 1;
      }
    }
    return delayed;
  }
  
  int cancelledDivertedFLights(String indVariable, String cat, String type){
    int amountInstances = 0;
    for (TableRow row : table.findRows(indVariable, type)){
      if (row.getInt(cat) ==1){
        amountInstances += 1;
      }
    }
    return amountInstances;
  }


  int[] frequencyDays(int startDate, int endDate){
    int monday = 0; int tuesday = 0; int wednesday = 0; int thursday = 0;
    int friday = 0; int saturday = 0; int sunday = 0;
    String date = "";
    for (int i =0; i<=1998; i++){
      TableRow row = table.getRow(i);
      date = row.getString("FL_DATE");
      String[] parts = date.split("/");
      int day = Integer.parseInt(parts[1]);
      if (day>= startDate && day<= endDate){
        if((day%7) == 1){saturday ++;}
        if((day%7)==2){sunday++;}
        if((day%7)==3){monday++;}
        if((day%7)==4){tuesday++;}
        if((day%7)==5){wednesday++;}
        if((day%7)==6){thursday++;}
        if((day%7)==0){friday++;}
    }
  }
  int[] frequencyByDay = {monday, tuesday, wednesday, thursday, friday, saturday, sunday};
  for(int i=0; i<7; i++){
   println(frequencyByDay[i]); 
  }
  return frequencyByDay;
  }
}
