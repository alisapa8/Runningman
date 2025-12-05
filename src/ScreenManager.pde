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
}

// -------------------------------------------
// SCREEN DRAW METHODS (Starter Example)
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

// -------------------------------------------
// EMPTY SCREEN METHODS FOR STUDENT PROJECT
// -------------------------------------------

void drawPlay() {
  background(255);
  text("PLAY SCREEN (fill this in)", 200, 200);
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
