//Alisa Pavlova | 11.11.2025 | RunnningMan ScreenManager
Player fred;
char screen = 's';   // s = start, m = menu, t = settings, p = play, u = pause, g = game over, a = app stats
Button btnStart, btnMenu, btnSettings, btnBack;
PImage b1;
PImage g1;

void setup() {
  size(700, 300);

  // Example buttons for practice starter
  btnStart    = new Button("Press Space To Play", 270, 160, 160, 50);
  btnBack = new Button ("Start Screen", 220, 100, 260, 50);
   b1 = loadImage("Startup.png");
   g1 = loadImage("Sand.png");
  fred = new Player();
  ground = new Ground();
  obstacles = new ArrayList<Obstacle>();


  textAlign(CENTER, CENTER);
}

// -------------------------------------------
void draw() {
  b1 = loadImage("Startup.png");
  g1 = loadImage("Sand.png");
  switch(screen) {
  case 's':
    drawStart();
    break;
  case 'p':
    drawPlay();
    break;
  }
  //btnStart.display();
  //btnBack.display();
}

// -------------------------------------------
// MOUSE CLICK HANDLER
// -------------------------------------------
void mousePressed() {
  switch(screen) {
    case 's':
    if(btnStart.clicked()) {
      screen = 'p';
      break;
    }
  }
}

void keyPressed() {
  if (key == ' ') {
    screen= 'p' ;
  }
  if (key == ' ') {
    if (gameState == STATE_START) {
      gameState = STATE_GAME;
    } else if (gameState == STATE_GAME) {
      fred.jump();
    } else if (gameState == STATE_OVER) {
      resetGame();
    }
  }
}

// -------------------------------------------
// SCREEN DRAW METHODS
// -------------------------------------------
void drawStart() {
  b1.resize(800,300);
  image(b1,0,0);
  textAlign(CENTER);
  textSize(32);
  text("RunningMan", width/2, 50);
  btnStart.display();
}

void drawMenu() {
  background(120, 200, 140);
  textSize(32);
  text("MENU SCREEN", width/2, 50);
  btnMenu.display();
}

void drawSettings() {
  background(200, 150, 120);
  textSize(32);
  text("SETTINGS", width/2, 50);
  btnSettings.display();
}

 //void drawStartScreen() {}
 
void drawPlay() {

  ground.draw();
  fred.draw();

  fill(50);
  textSize(30);
  text("Press SPACE to Start", width / 2, height / 2 - 40);
}

void drawGameScreen() {
  ground.update();
  ground.draw();
  fred.update();
  fred.draw();
  manageObstacles();
  updateScore();
  gameSpeed += 0.005;
}

void drawGameOverScreen() {
  ground.draw();
  fred.draw();

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
    if (fred.hits(ob)) {
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
  fred = new Player();
  gameState = STATE_GAME;
}



class Player {
  float x, y;
  float w, h;
  float yVel;
  float gravity;
  float groundY;

  fred() {
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
     if (fredImg != null) {
     // This is where you would draw your fred image
     image(fredImg, x, y, w, h);
     
     // For animation, you could do:
     // if (frameCount % 10 < 5) {
     //   image(fredRun1, x, y, w, h);
     // } else {
     //   image(fredRun2, x, y, w, h);
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
  float x1, x2;
  float y;
  float w;

  Ground() {
    w = width;
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

void drawPause() {
  background(255);
  text("PAUSE SCREEN (fill this in)", 200, 200);
}

void drawGameOver() {
  background(255);
  text("GAME OVER SCREEN (fill this in)", 200, 200);
}

void drawStats() {
  background(255);
  text("STATS SCREEN (fill this in)", 200, 200);
}
