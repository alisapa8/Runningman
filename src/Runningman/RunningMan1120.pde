//Samuel Maass | Running Man
final int STATE_START = 0;
final int STATE_GAME = 1;
final int STATE_OVER = 2;
int gameState = STATE_START;

Dino dino;
Ground ground;
ArrayList<Obstacle> obstacles;


float gameSpeed = 6;
int score = 0;

// PImage variables for your Piskel art
// PImage dinoImg;
// PImage obstacleImg;
// PImage groundImg;
// PImage dinoRun1, dinoRun2; // For animation
// PImage dinoDead;



void settings() {
  size(800, 400);
}

void setup() {
  dino = new Dino();
  ground = new Ground();
  obstacles = new ArrayList<Obstacle>();


  textAlign(CENTER, CENTER);

  /*
  // --- LOAD YOUR PISKEL IMAGES HERE ---
   // Make sure to add your image files to the sketch folder!
   // (In Processing: Sketch > Add File...)
   
   // Example:
   // dinoImg = loadImage("dino.png");
   // obstacleImg = loadImage("cactus.png");
   // groundImg = loadImage("ground.png");
   */
}

void draw() {
  background(240);
  switch(gameState) {
  case STATE_START:
    drawStartScreen();
    break;
  case STATE_GAME:
    drawGameScreen();
    break;
  case STATE_OVER:
    drawGameOverScreen();
    break;
  }
}

void keyPressed() {
  if (key == ' ') {
    if (gameState == STATE_START) {
      gameState = STATE_GAME;
    } else if (gameState == STATE_GAME) {
      dino.jump();
    } else if (gameState == STATE_OVER) {
      resetGame();
    }
  }
}



void drawStartScreen() {
  ground.draw();
  dino.draw();

  fill(50);
  textSize(30);
  text("Press SPACE to Start", width / 2, height / 2 - 40);
}

void drawGameScreen() {
  ground.update();
  ground.draw();
  dino.update();
  dino.draw();
  manageObstacles();
  updateScore();
  gameSpeed += 0.005;
}

void drawGameOverScreen() {
  ground.draw();
  dino.draw();

  for (Obstacle ob : obstacles) {
    ob.draw();
  }

  fill(50);
  textSize(40);
  text("GAME OVER", width / 2, height / 2 - 80);

  textSize(24);
  text("Score: " + score, width / 2, height / 2 - 40);
  text("Press SPACE to Restart", width / 2, height / 2);
}
//Changes obstacle frequency
void manageObstacles() {
  if (frameCount % (int)random(80, 150) == 0) {
    if (obstacles.size() == 0 || obstacles.get(obstacles.size()-1).x < width - 200) {
      obstacles.add(new Obstacle());
    }
  }

  for (int i = obstacles.size() - 1; i >= 0; i--) {
    Obstacle ob = obstacles.get(i);
    ob.update();
    ob.draw();
    if (dino.hits(ob)) {
      gameState = STATE_OVER;
    }
    if (ob.isOffscreen()) {
      obstacles.remove(i);
    }
  }
}

void updateScore() {
  if (frameCount % 5 == 0) {
    score++;
  }

  fill(50);
  textSize(20);
  textAlign(RIGHT, TOP);
  text("Score: " + score, width - 20, 20);
  textAlign(CENTER, CENTER);
}

void resetGame() {
  score = 0;
  gameSpeed = 6;
  obstacles.clear();
  dino = new Dino();
  gameState = STATE_GAME;
}



class Dino {
  float x, y;
  float w, h;
  float yVel;
  float gravity;
  float groundY;

  Dino() {
    w = 50;
    h = 60;
    x = 60;
    groundY = height - 20 - h;
    y = groundY;

    yVel = 0;
    gravity = 0.7;
  }

  void jump() {
    if (y == groundY) {
      yVel = -15;
      }
    }

    void update() {
      y += yVel;
      yVel += gravity;
      y = constrain(y, 0, groundY);
    }

    void draw() {
      /*
    // --- DRAW YOUR PISKEL IMAGE HERE ---
       if (dinoImg != null) {
       // This is where you would draw your dino image
       image(dinoImg, x, y, w, h);
       
       // For animation, you could do:
       // if (frameCount % 10 < 5) {
       //   image(dinoRun1, x, y, w, h);
       // } else {
       //   image(dinoRun2, x, y, w, h);
       // }
       
       } else {
       */
      fill(100);
      noStroke();
      rect(x, y, w, h);
      // }
    }

    boolean hits(Obstacle ob) {
      return (x + w > ob.x       && 
        x < ob.x + ob.w    && 
        y + h > ob.y       && 
        y < ob.y + ob.h);    
    }
  }


  class Obstacle {
    float x, y;
    float w, h;

    Obstacle() {
      w = 30; 
      h = 70; 

      x = width; 
      y = height - 20 - h;
    }

    void update() {
      x -= gameSpeed;
    }

    void draw() {
      /*
    // --- DRAW YOUR PISKEL IMAGE HERE ---
       if (obstacleImg != null) {
       image(obstacleImg, x, y, w, h);
       } else {
       */
      // Placeholder rectangle
      fill(200, 0, 0);
      noStroke();
      rect(x, y, w, h);
      // }
    }

    boolean isOffscreen() {
      return (x + w < 0);
    }
  }


  class Ground {
    // We use two "ground" images to create an infinite scrolling effect
    float x1, x2;
    float y;
    float w;

    Ground() {
      w = width; // The width of our "image" is the full screen width
      x1 = 0;
      x2 = w;
      y = height - 20; 
    }

    void update() {
      x1 -= gameSpeed;
      x2 -= gameSpeed;

      if (x1 + w < 0) {
        x1 = x2 + w;
      }
      if (x2 + w < 0) {
        x2 = x1 + w;
      }
    }

    void draw() {
      /*
    // --- DRAW YOUR PISKEL IMAGE HERE ---
       if (groundImg != null) {
       image(groundImg, x1, y, w, 20);
       image(groundImg, x2, y, w, 20);
       } else {
       */
      // Placeholder rectangles
      fill(80);
      noStroke();
      rect(x1, y, w, 20);
      rect(x2, y, w, 20);
      // }
    }
  }
