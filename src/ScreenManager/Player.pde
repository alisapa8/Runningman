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
  class JumpingCharacter {
  float x;
  float y;

  float yVelocity;
  boolean isJumping;
  final float GRAVITY = 0.6;
  final float JUMP_STRENGTH = -15.0;
  float groundLevel;
  JumpingCharacter(float startX, float startY, float groundLevel) {
    this.x = startX;
    this.y = startY;
    this.groundLevel = groundLevel;

    this.yVelocity = 0;
    this.isJumping = (this.y < this.groundLevel);
  }

  void jump() {
    if (!isJumping) {
      this.yVelocity = JUMP_STRENGTH;
      this.isJumping = true;
    }
  }

  void update() {
    if (isJumping) {
      this.yVelocity += GRAVITY;
      this.y += this.yVelocity;
      if (this.y >= this.groundLevel) {
        this.y = this.groundLevel;
        this.yVelocity = 0;
        this.isJumping = false;
      }
    }
  }
  void moveHorizontally(float deltaX) {
    this.x += deltaX;
  }
  void draw() {
    fill(220, 50, 50);
    noStroke();
    ellipseMode(CENTER);
    ellipse(this.x, this.y - 25, 50, 50);
  }
}
}
