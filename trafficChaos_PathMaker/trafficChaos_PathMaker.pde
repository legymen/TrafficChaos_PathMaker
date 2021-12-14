boolean debug = true;
boolean mpressed = false;
PrintWriter output1, output2;

String state = "RECORD_PATH1";
String[] carPathPos;
String[] carPathCoords;

Path path1, path2;

PImage bg;

void setup() {

  size(1400, 997);

  path1 = new Path();
  path2 = new Path();

  output1 = createWriter("carPathPos_temp.txt");
  output2 = createWriter("walkerPathPos_temp.txt");

  bg = loadImage("images/bakgrundv2.jpg");
  carPathPos = loadStrings("carPathPos.txt");
  String entirePlay = join(carPathPos, ",");
  carPathCoords = split(entirePlay, ",");
}

void draw() {
  background(bg);

  switch(state) {

    //*********RECORD_PATH1**********
    case("RECORD_PATH1"):
    println(mpressed);

    if (mousePressed && !mpressed) {
      path1.addPoint(mouseX, mouseY);
      output1.println(mouseX + " " + mouseY + ",");
      mpressed = true;
    } else if (mpressed && !mousePressed) {
      mpressed = false;
    }
    if (keyPressed && key == '1') {
      state = "MAKE_PATH2";
    }  
    path1.render();   
    break;

    //*********RECORD_PATH2**********
    case("MAKE_PATH2"):
    if (mousePressed && !mpressed) {
      path2.addPoint(mouseX, mouseY);
      output2.println(mouseX + " " + mouseY + ",");
      mpressed = true;
    } else if (mpressed && !mousePressed) {
      mpressed = false;
    }
    if (keyPressed && key == '2') {
      state = "RUN";
    }
    path1.render();
    path2.render();  
    break;

    //*********RUN**********
    case("RUN"):
    for (int i = 0; i < carPathCoords.length; i++) {
      println(carPathCoords[i]);
    }
    break;
  }
}


public void keyPressed() {
  if (key == ' ') {
    debug = !debug;
  } else if (key == 's') {
    output1.flush(); // Writes the remaining data to the file
    output1.close(); // Finishes the file
    output2.flush(); // Writes the remaining data to the file
    output2.close(); // Finishes the file
    exit(); // Stops the program
  }
}
