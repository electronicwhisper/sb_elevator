PrintWriter output;

void logData(String json) {
//  if (output == null) output = createWriter("data/log-"+fulldate()+".txt");
//  output.println(json);
//  output.flush();
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
