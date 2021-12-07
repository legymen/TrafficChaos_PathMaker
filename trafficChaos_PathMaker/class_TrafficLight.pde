class TrafficLight {

  String state;
  int stateTimer;
  float xpos, ypos;

  TrafficLight(float _xpos, float _ypos) {
    xpos = _xpos;
    ypos = _ypos;
    state = "RED";
    stateTimer = millis();
  }

  void render(boolean lightsR, boolean lightsY, boolean lightsG, boolean walkOn) {
    // Renders the trafficlight with walksignal and button at xpos, ypos

    pushMatrix();
    translate(xpos, ypos);
    renderTrafficLight(lightsR, lightsY, lightsG);
    renderWalkSignal(walkOn);
    renderButton(true);
    popMatrix();
  }

  void update() {
    // Update runs every frame and calls render()

    switch(state) {

    case "RED":
      render(true, false, false, true);
      if (millis() - stateTimer > 2000) {
        state = "RED_YELLOW";
        stateTimer = millis();
      }
      break;

    case "RED_YELLOW":
      render(true, true, false, false);
      if (millis() - stateTimer > 2000) {
        state = "GREEN";
        stateTimer = millis();
      }
      break;

    case "GREEN":
      render(false, false, true, false);
      if (millis() - stateTimer > 2000) {
        state = "YELLOW";
        stateTimer = millis();
      }
      break;

    case "YELLOW":
      render(false, true, false, false);
      if (millis() - stateTimer > 2000) {
        state = "RED";
        stateTimer = millis();
      }
      break;
    }

    //Check the button every frame
    if (buttonPressed()) {
      state = "RED";
    }
  }

  void renderTrafficLight(boolean redOn, boolean yellowOn, boolean greenOn) {
    // This function renders a traffic light. Origin is in upper left corner

    color black = color(0);
    color redLight = color(255, 0, 0 );
    color yellowLight = color(255, 255, 0);
    color greenLight = color(0, 255, 0);
    color offLight = color(200);

    rectMode(CORNER);

    // Render the "box"
    fill(black);
    rect(0, 0, 10, 30);

    // Render red light if on
    if (redOn) {
      fill(redLight);
    } else {
      fill(offLight);
    }
    ellipse(5, 5, 7.5, 7.5);

    // Render yellow light if on
    if (yellowOn) {
      fill(yellowLight);
    } else {
      fill(offLight);
    }
    ellipse(5, 15, 7.5, 7.5);

    // Render green light if on
    if (greenOn) {
      fill(greenLight);
    } else {
      fill(offLight);
    }
    ellipse(5, 25, 7.5, 7.5);
  }

  void renderWalkSignal(boolean walk) {
    // This function renders a walk signal

    color black = color(0);
    color redLight = color(255, 0, 0 );
    color greenLight = color(0, 255, 0);
    color offLight = color(200);

    rectMode(CORNER);

    // Render the "box"
    fill(black);
    rect(30, 0, 10, 20);

    // Render red light if on
    if (walk) {
      fill(offLight);
    } else {
      fill(redLight);
    }
    ellipse(35, 5, 7.5, 7.5);

    // Render green light if on
    if (walk) {
      fill(greenLight);
    } else {
      fill(offLight);
    }
    ellipse(35, 15, 7.5, 7.5);
  }

  void renderButton(boolean buttonOn) {
    // This function renders a button
    color black = color(0);
    color buttonOffColor = color(54, 74, 183);
    color buttonOnColor = color(182, 179, 203);

    fill(black);
    rectMode(CORNER);
    rect(30, 40, 10, 10);

    if (buttonOn) {
      fill(buttonOnColor);
    } else {
      fill(buttonOffColor);
    }
    ellipse(35, 45, 3.6, 3.6);
  }

  boolean buttonPressed() {
    // Returns true if the button is pressed, false otherwise
    if (mousePressed && sqrt(sq(mouseX-(xpos+35))+sq(mouseY-(ypos+45))) < 4) {
      return true;
    } else {
      return false;
    }
  }
}
