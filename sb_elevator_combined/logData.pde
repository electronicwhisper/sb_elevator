PrintWriter output;

void logData(String json) {
  // log to console
  println(json);
  
  if (!debugMode) {
    // log to text file
    if (output == null) output = createWriter("data/log-"+fulldate()+".txt");
    output.println(json);
    output.flush();
    // log to gabby's server
    loadStrings("http://levinegabriella.com/sensitive_buildings/elevator_data.php?data="+json);
  }
}

String fulldate() {
  return (year() + "-" + month() + "-" + day() + "T" + hour() + "-" + minute() + "-" + second());
}
long systemTime() {
  Date d = new Date();
  long current = d.getTime();
  return current;
}

void logFloor(int elevator, int fl) {
  logData("{type:\"floor\",timestamp:"+systemTime()+",elevator:"+elevator+",floor:"+fl+"}");
}

void logPeople(int elevator, boolean people) {
  logData("{type:\"people\",timestamp:"+systemTime()+",elevator:"+elevator+",people:"+people+"}");
}
