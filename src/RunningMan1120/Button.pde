//Samuel Maass
class Button {


  float x, y, w, h;
  String label;

  color baseColor;
  color hoverColor;
  color textColor;


  Button(String label, float x, float y, float w, float h) {
    this.label = label;
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;


    this.baseColor = color(50, 100, 200);
    this.hoverColor = color(80, 130, 230);
    this.textColor = color(255);
  }

  void draw() {
    if (isHovering(mouseX, mouseY)) {
      fill(hoverColor);
    } else {
      fill(baseColor);
    }


    noStroke();
    rectMode(CORNER);
    rect(x, y, w, h, 7);


    fill(textColor);
    textAlign(CENTER, CENTER);
    textSize(18);
    text(label, x + w/2, y + h/2);
  }

  boolean isClicked(float mx, float my) {

    return (mx > x && mx < (x + w) &&
      my > y && my < (y + h));
  }


  private boolean isHovering(float mx, float my) {

    return (mx > x && mx < (x + w) &&
      my > y && my < (y + h));
  }
}
