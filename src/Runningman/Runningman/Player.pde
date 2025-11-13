class Player{
  int x,y,w,h;
  PImage p1;
  Player() {
    x =  100;
    y = 100;
    w = 50;
    h = 50;
    p1 = loadImage("Mummy.gif");
  }
  
  
  void display() {
    p1.resize(70,70);
    image(p1,x,y);
  }
  
}
