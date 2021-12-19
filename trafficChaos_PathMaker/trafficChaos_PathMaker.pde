boolean mpressed = false;
PrintWriter outputCars, outputWalkers;

String state = "RECORD_CARPATH";

Path carPath, walkerPath;

PImage bg;

void setup() {

  size(1400, 997);

  carPath = new Path();
  walkerPath = new Path();

  outputCars = createWriter("carPathPos_temp.txt");
  outputWalkers = createWriter("walkerPathPos_temp.txt");

  bg = loadImage("images/bakgrundv3.jpg");

}

void draw() {
  background(bg);

  switch(state) {

    //*********RECORD_CARPATH**********
    case("RECORD_CARPATH"):
    println(mpressed);

    if (mousePressed && !mpressed) {
      carPath.addPoint(mouseX, mouseY);
      outputCars.println(mouseX + " " + mouseY + ",");
      mpressed = true;
    } else if (mpressed && !mousePressed) {
      mpressed = false;
    }
    if (keyPressed && key == '1') {
      state = "MAKE_WALKERPATH";
    }  
    carPath.render();   
    break;

    //*********RECORD_WALKERPATH**********
    case("MAKE_WALKERPATH"):
    if (mousePressed && !mpressed) {
      walkerPath.addPoint(mouseX, mouseY);
      outputWalkers.println(mouseX + " " + mouseY + ",");
      mpressed = true;
    } else if (mpressed && !mousePressed) {
      mpressed = false;
    }
    if (keyPressed && key == '2') {
      state = "SAVE_QUIT";
    }
    carPath.render();
    walkerPath.render();  
    break;

    //*********SAVE_QUIT**********
    case("SAVE_QUIT"):
    outputCars.flush(); // Writes the remaining data to the file
    outputCars.close(); // Finishes the file
    outputWalkers.flush(); // Writes the remaining data to the file
    outputWalkers.close(); // Finishes the file
    exit(); // Stops the program
    break;

  }
}
