class Obstacle {


  PVector position; 
  float w;  
  float h;   
  color obsColor;

  Obstacle(float x, float y, float w_, float h_) {

    position = new PVector(x, y);
    w = w_;
    h = h_;
    obsColor = color(200, 30, 30); 
  }

  void display() {

    rectMode(CENTER); 
    noStroke(); 
    fill(obsColor); 

    rect(position.x, position.y, w, h);
  }

  float getTop() {
    return position.y - h / 2;
  }
  float getBottom() {
    return position.y + h / 2;
  }
  float getLeft() {
    return position.x - w / 2;
  }
  float getRight() {
    return position.x + w / 2;
  }
}
