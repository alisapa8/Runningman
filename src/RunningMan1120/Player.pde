class Player{
  int x,y,w,h;
  PImage p1;
  PImage p2;
 Player() {
    x = 10;
    y = 100;
    w = 50;
    h = 50;
    p1 = loadImage("MummyM1.gif");
    p2 = loadImage("MummyM2.gif");
  }
  
  
  void display() {
    p1.resize(70,70);
    image(p1,x,y);
    p2.resize(70,70);
    image(p1,x,y);
  }
  
}
