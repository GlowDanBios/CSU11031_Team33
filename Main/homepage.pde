void drawHomeScreen() {
  
  for (int i = 0; i < cloudCount; i++) {
    cloudObjects[i].display();
    cloudObjects[i].move();
  }
  planeObject.display();
  planeObject.move();
   graphsButton.display();


}

void drawGraphsScreen() {
  // Draw the graphs screen
  background(BACKGROUND_COLOR); // White background

  activeScreen.draw();
   if (activeScreen == controlsScreen) {
    text("Flights found: "+gTable.displayedTable.getRowCount(), activeScreen.getX()+rowX+700, activeScreen.getY()+rowStart+20);
  }
  if (activeScreen == mapScreen) {
    la.getTopAirports(airportSlider.getValue(), initAirports.popularAirports(airportSlider.getValue()));
  }
  // Draw home button

}



void removeBackground(PImage img) {
  PImage mask = createImage(img.width, img.height, ALPHA); // Create a mask with ALPHA (transparency) mode
  mask.loadPixels();
  
  for (int i = 0; i < img.pixels.length; i++) {
    // Check if the pixel color is similar to the background color
    if (red(img.pixels[i]) >= 250 && green(img.pixels[i]) >= 250 && blue(img.pixels[i]) >= 250) {
      mask.pixels[i] = color(0, 0); // Set the pixel to transparent
    } else {
      mask.pixels[i] = color(255); // Set the pixel to opaque
    }
  }
  mask.updatePixels();
  
  img.mask(mask); // Apply the mask to the image
}
class Plane {
  PImage img;
  float x, y;
  float speed = 1;
  float amplitude = 100; // Amplitude of the sine wave motion
  float angle = 0; // Angle for the sine wave motion
  
  Plane(PImage img_) {
    img = img_;
    x = width/2-200;
    y = height/2-350;
  }
  
  void display() {
    image(img, x, y, 400, 400); // Adjusted size to 400x400
  }
  
  void move() {
    angle += 0.05; // Increment angle for smooth motion
    y = height/2-350 + sin(angle) * amplitude; // Calculate y position based on sine wave
  }
}

class Cloud {
  PImage img;
  float x, y;
  float speed;
  
  Cloud(PImage img_) {
    img = img_;
    x = random(250, width - 250); // Ensure x-coordinate is within bounds
    y = -300; // Set initial y-coordinate above the screen
    speed = random(0.5, 1.5);
    
    // Check if the initial y-coordinate overlaps with other clouds
    for (Cloud cloud : cloudObjects) {
      if (cloud != null && dist(x, y, cloud.x, cloud.y) < 400) {
        y -= 400; // Adjust y-coordinate to avoid overlap
      }
    }
  }
  
  void display() {
    image(img, x, y, 400, 400);
  }
  
  void move() {
    y += speed + random(0.5, 1);
    
    if (y > height + 250) {
      y = -250;
      x = random(250, width - 250);
    }
  }
}


class Buttons {
  PImage img;
  float x, y;
  float w, h;

  Buttons(PImage img_,float x_, float y_, float w_, float h_) {
    x = x_;
    y = y_;
    w = w_;
    h = h_;
    img = img_; // Load the image
  }

  void display() {
    image(img, x, y, w, h);
  }

  boolean isClicked() {
    return mouseX > x && mouseX < x + w && mouseY > y && mouseY < y + h;
  }
}

