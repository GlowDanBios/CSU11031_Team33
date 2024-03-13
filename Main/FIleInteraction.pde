ArrayList<DataPoint> getAllFlights(){
  //written by Danila Romanenko

  String[] rawStrings = readFromFile(mainFileName);
  
  ArrayList<DataPoint> result = new ArrayList<DataPoint>();
  for(int index=1;index<rawStrings.length;index++){
    println(rawStrings[index]);
    result.add(new DataPoint(rawStrings[index]));
  }
  
  return result;
}

String[] readFromFile(String fileName){
  return loadStrings("Files/"+fileName);
}
