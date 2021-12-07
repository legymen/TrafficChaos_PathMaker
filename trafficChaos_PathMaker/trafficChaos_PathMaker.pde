boolean debug = true;
boolean mpressed = false;
PrintWriter output;
int check;

String state = "RECORD_PATH1";

Path path1, path2;

void setup() {

  size(1600, 1200);

  path1 = new Path();
  path2 = new Path();

  output = createWriter("positions.txt");
}

void draw() {
  background(140);

  switch(state) {

    //*********RECORD_PATH1**********
    case("RECORD_PATH1"):
    check = 0;

    if (check == 0) {
      output.println("Path1: "); // Write the coordinate to the file
      check = 1;
    }
    if (mousePressed && !mpressed) {
      path1.addPoint(mouseX, mouseY);
      output.println(mouseX + "\t" + mouseY);
      mpressed = true;
    } else {
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
      mpressed = true;
    } else {
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
    path1.render();
    path2.render();
    break;
  }
}

public void keyPressed() {
  if (key == ' ') {
    debug = !debug;
  }
}
