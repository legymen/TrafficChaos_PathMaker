boolean mClicked = false;

PrintWriter outputCars, outputWalkers, outputLights;

String state = "RECORD_CARPATH";

Path carPath, walkerPath;

ArrayList<TrafficLight> lights;

PImage bg;

// Things for placing lights
  int lState = 1;
  int streetX = 0;
  int streetY = 0;
  int renderX = 0;
  int renderY = 0;


void setup() {

  size(1400, 997);

  carPath = new Path();
  walkerPath = new Path();
  lights = new ArrayList<TrafficLight>();

  outputCars = createWriter("carPathPos_temp.txt");
  outputWalkers = createWriter("walkerPathPos_temp.txt");
  outputLights = createWriter("lightsPos_temp.txt");

  bg = loadImage("images/bakgrundv3.jpg");

}


void draw() {
  background(bg);

  switch(state) {

    //*********RECORD_CARPATH**********
    case("RECORD_CARPATH"):

    if (mClicked) {
      carPath.addPoint(mouseX, mouseY);
      outputCars.println(mouseX + " " + mouseY + ",");
      mClicked = false;
    }
    if (keyPressed && key == '1') {
      state = "MAKE_WALKERPATH";
    }  
    carPath.render();   
    break;

    //*********RECORD_WALKERPATH**********
    case("MAKE_WALKERPATH"):
    if (mClicked) {
      walkerPath.addPoint(mouseX, mouseY);
      outputWalkers.println(mouseX + " " + mouseY + ",");
      mClicked = false;
    }
    if (keyPressed && key == '2') {
      state = "PLACE_LIGHTS";
    }
    carPath.render();
    walkerPath.render();  
    break;

    //*********PLACE_LIGHTS**********
    case("PLACE_LIGHTS"):
    
    if (mClicked) {
      switch(lState){
        case(1):
        streetX = mouseX;
        streetY = mouseY;
        lState = 2;
        break;

        case(2):
        renderX = mouseX;
        renderY = mouseY;
        lights.add(new TrafficLight(streetX, streetY, renderX, renderY));
        outputLights.println(streetX + " " + streetY + " " + renderX + " " + renderY);
        lState = 1;

        break;
      }
      mClicked = false;
    }
    if (keyPressed && key == '3') {
      state = "SAVE_QUIT";
    }

    walkerPath.render();

    for (int i = 0; i < lights.size(); i++) {
      TrafficLight light = lights.get(i);
      light.update();
    }

    break;

    //*********SAVE_QUIT**********
    case("SAVE_QUIT"):
    outputCars.flush(); // Writes the remaining data to the file
    outputCars.close(); // Finishes the file
    outputWalkers.flush(); // Writes the remaining data to the file
    outputWalkers.close(); // Finishes the file
    outputLights.flush(); // Writes the remaining data to the file
    outputLights.close(); // Finishes the file
    exit(); // Stops the program
    break;

  }
}

void mouseClicked() {
  mClicked = true;
}
