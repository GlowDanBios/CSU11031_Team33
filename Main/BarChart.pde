class BarChart extends Widget {
  Bar[] bars;
  int width, height;
  int colSpace;
  int colWidth;
  String xAxis, yAxis;

  BarChart(int x, int y, int width, int height, String xAxis, String yAxis, int[] values, String names[]) {
    super(x, y);
    this.width = width;
    this.height = height;
    this.xAxis= xAxis;
    this.yAxis = yAxis;
    int colNum = values.length;
    colWidth = (int)((width/colNum)/1.1);
    colSpace = colWidth/5;
    int maxVal = max(values);
    bars = new Bar[colNum];
    for (int i = 0; i <values.length; i++) {
      bars[i] = new Bar(values[i], color(100, 0, 0), colWidth, (int)(((float)values[i]/maxVal)*0.95*height), names[i], height);
    }
  }

  void draw(int screenX, int screenY) {
    line(screenX+x, screenY+y, screenX+x, screenY+y+height);
    line(screenX+x, screenY+y+height, screenX+x+width, screenY+y+height);
    for (int i =0; i<bars.length; i++) {
      bars[i].draw(screenX+x+20+i*(colSpace+colWidth), screenY+y, screenX+x);
    }
    text(xAxis, screenX+x, screenY+y);
    text(yAxis, screenX+width+20, screenY+y+height+35);
  }
}

class Bar {
  int value;
  color c;
  int width, height;
  int chartHeight;
  String name;

  Bar(int value, color c, int width, int height, String name, int chartHeight) {
    this.value = value;
    this.c = c;
    this.width = width;
    this.height = height;
    this.name = name;
    this.chartHeight = chartHeight;
  }

  void draw(int x, int y, int chartStart) {
    if (width<30)
      textFont(smallFont);
    else
      textFont(mediumFont);
    fill(c);
    rect(x, y+(chartHeight-height), width, height);
    text(name, x, y+chartHeight+20);
    text(value, chartStart-textWidth(String.valueOf(value))-1, y+(chartHeight-height));
    textFont(bigFont);
  }
}
