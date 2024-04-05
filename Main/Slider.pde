class Slider extends Widget {
  int minValue, maxValue;
  int value;
  float sliderX;
  int width, height;
  boolean sliding;

  Slider(int x, int y, int width, int height, int minValue, int maxValue) {
    super(x, y);
    this.minValue = minValue;
    this.maxValue = maxValue;
    this.value = minValue;
    this.sliderX = map(value, minValue, maxValue, x, x + width);
    this.sliding = false;
    this.width = width;
    this.height = height;
  }

  boolean clicked(int screenX, int screenY, int mouseX, int mouseY) {
    return mouseX > screenX + sliderX - 5 && mouseX < screenX + sliderX + 5 && mouseY > screenY + y && mouseY < screenY + y + height;
  }

  void event(int screenX, int screenY, int mouseX, int mouseY, boolean click) {
    if (click) {
      if (clicked(screenX, screenY, mouseX, mouseY) && !sliding) {
        sliding = true;
      }
    } else {
      sliding = false;
    }

    if (sliding) {
      sliderX = constrain(mouseX - screenX, x, x + width);
      float range = maxValue - minValue;
      float valuePerPixel = range / (width - 10);
      value = minValue + int(valuePerPixel * (sliderX - x));
      value = constrain(value, minValue, maxValue);
    }
  }

  void draw(int screenX, int screenY) {
    fill(BACKGROUND_COLOR);
    stroke(0);
    rect(screenX + x, screenY + y, width, height);

    fill(255);
    rect(screenX + sliderX - 5, screenY + y, 10, height);

    fill(TEXT_COLOR);
    text(value, screenX + sliderX, screenY + y + height + 15);
  }

  int getValue() {
    return value;
  }
}
