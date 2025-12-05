// Combined Running Man Game Code | Alisa/Sam |

// Screen Management
final int STATE_START = 0;
final int STATE_GAME = 1;
final int STATE_OVER = 2;
int gameState = STATE_START;

char currentScreen = 's'; // s=start, p=play
Button btnStart;

// --- Game Objects ---
Dino dino; // This is now the Adventurer character
Ground ground;
ArrayList<Obstacle> obstacles;

// --- Game Variables ---
float gameSpeed = 6;
int score = 0;

// --- Image Variables ---
PImage backgroundImg; // Background.png for the start screen (Sunset)
PImage groundImg; // Sand.png for the ground
// PImage adventurerImg; // Removed for shape animation
PImage mummyImg; // MummyM1.png for the obstacle

// --- Animation Variable ---
int legFrame = 0; // Controls the position of the stick figure's legs

void settings() {
  size(700, 300); // Increased size slightly for better visibility
}

void setup() {
  // Load images
  // NOTE: Ensure these files (Background.png, Sand.png, MummyM1.png)
  // are in your sketch folder and match the file names exactly!
  // If you don't have these, the code will use fallback shapes/colors.
  backgroundImg = loadImage("Background.png");
  groundImg = loadImage("Sand.png");
  mummyImg = loadImage("MummyM1.png");


  // Initialize game objects
  dino = new Dino();
  ground = new Ground(); 
  obstacles = new ArrayList<Obstacle>();

  // Initialize buttons (The button object is not used, but kept for context)
  btnStart = new Button("Press SPACE to Start", width / 2 - 100, height / 2 + 50, 200, 50);

  textAlign(CENTER, CENTER);
}

void draw() {
  // Update the animation frame only when the game is running
  if (gameState == STATE_GAME) {
    if (frameCount % 6 == 0) { // Change leg position every 6 frames
      legFrame = (legFrame + 1) % 4; // Cycle through frames 0, 1, 2, 3
    }
  } else {
      legFrame = 0; // Stop movement when not running
  }
  
  switch(currentScreen) {
    case 's':
      drawStartScreen();
      break;
    case 'p':
      // The main game logic is now driven by gameState inside drawPlay()
      drawPlay();
      break;
  }
}

// -------------------------------------------
// MOUSE CLICK HANDLER
// -------------------------------------------
void mousePressed() {
  // We don't use the button clicked method because the game relies on 'SPACE'
  // to start/jump/restart, which is handled in keyPressed().
}

void keyPressed() {
  if (key == ' ') {
    if (currentScreen == 's') {
      // Transition from Start Screen to Play Screen
      currentScreen = 'p';
      gameState = STATE_GAME;
    } else if (currentScreen == 'p') {
      if (gameState == STATE_GAME) {
        dino.jump();
      } else if (gameState == STATE_OVER) {
        resetGame();
      }
    }
  }
}
// -------------------------------------------
// SCREEN DRAW METHODS
// -------------------------------------------

void drawStartScreen() {
  // Display the Background.png image
  if (backgroundImg != null) {
    backgroundImg.resize(width, height);
    image(backgroundImg, 0, 0);
  } else {
    // Fallback if image fails to load
    background(150, 200, 250);
  }

  fill(255); // Use white text for better contrast against the sunset
  textSize(50);
  text("Mummy Game", width / 2, height / 2 - 50);

  // Draw the button text (since we're using SPACE, we just draw the prompt)
  textSize(30);
  text("Press SPACE to Start", width / 2, height / 2 + 60);
}


void drawPlay() {
  // Draw a lighter sky background for the game
  background(173, 216, 230); // Light blue sky
  switch(gameState) {
    case STATE_GAME:
      drawGameScreen();
      break;
    case STATE_OVER:
      drawGameOverScreen();
      break;
  }
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
  // Draw game elements in their final state
  ground.draw();
  dino.draw();
  for (Obstacle ob : obstacles) {
    ob.draw();
  }

  // Game Over text
  fill(50);
  textSize(40);
  text("GAME OVER", width / 2, height / 2 - 80);

  textSize(24);
  text("Score: " + score, width / 2, height / 2 - 40);
  text("Press SPACE to Restart", width / 2, height / 2);
}

// Changes obstacle frequency
void manageObstacles() {
  if (frameCount % (int)random(97, 155) == 0) {
    // Ensure obstacles are not too close when spawning
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
  textAlign(CENTER, CENTER); // Reset for other text
}

void resetGame() {
  score = 0;
  gameSpeed = 6;
  obstacles.clear();
  dino = new Dino(); // Recreate dino to reset its state
  gameState = STATE_GAME;
}

// -------------------------------------------
// GAME CLASSES
// -------------------------------------------

class Dino {
  float x, y;
  float w, h;
  float yVel;
  float gravity;
  float groundY;
  
  // Stick figure dimensions
  float headR = 10;
  float bodyH = 30;
  float armL = 15;
  float legL = 15;

  Dino() {
    w = 30; // Collision width
    h = 50; // Collision height
    x = 60;
    groundY = height - 20 - h;
    y = groundY;

    yVel = 0;
    gravity = 0.9;
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
    float centerX = x + w / 2;
    float headY = y + headR;
    float chestY = headY + headR * 0.5;
    float waistY = chestY + bodyH;
    
    // Set drawing style
    stroke(0);
    strokeWeight(2);
    fill(255, 200, 150); // Skin color for head
    
    // 1. Head (Circle)
    ellipse(centerX, headY, headR * 2, headR * 2);
    
    // 2. Body (Line)
    line(centerX, chestY, centerX, waistY);
    
    // 3. Arms (Lines, simple animation for running)
    if (y == groundY) { // Running animation
        if (legFrame == 0 || legFrame == 2) {
            // Arms straight back
            line(centerX, chestY + 5, centerX - 10, chestY + armL + 5);
            line(centerX, chestY + 5, centerX + 10, chestY + armL + 5);
        } else {
            // Arms bent forward/back
            line(centerX, chestY + 5, centerX - 5, chestY + armL - 5);
            line(centerX, chestY + 5, centerX + 15, chestY + armL + 5);
        }
    } else { // Jumping pose (arms up)
        line(centerX, chestY + 5, centerX - 5, chestY - armL + 5);
        line(centerX, chestY + 5, centerX + 5, chestY - armL + 5);
    }
    
    // 4. Legs (Lines, simple animation for running)
    // The leg lines start from waistY
    if (y == groundY) { // Running animation
        if (legFrame == 0) {
            // Frame 0: Both legs slightly bent back
            line(centerX, waistY, centerX - 5, waistY + legL);
            line(centerX, waistY, centerX + 5, waistY + legL);
        } else if (legFrame == 1) {
            // Frame 1: Right leg forward, left leg back
            line(centerX, waistY, centerX + 5, waistY + legL - 5);
            line(centerX, waistY, centerX - 10, waistY + legL);
        } else if (legFrame == 2) {
            // Frame 2: Both legs straight down (mid-run)
            line(centerX, waistY, centerX, waistY + legL);
            line(centerX, waistY, centerX + 3, waistY + legL);
        } else if (legFrame == 3) {
            // Frame 3: Left leg forward, right leg back
            line(centerX, waistY, centerX - 5, waistY + legL - 5);
            line(centerX, waistY, centerX + 10, waistY + legL);
        }
    } else { // Jumping pose (legs straight down)
        line(centerX, waistY, centerX - 3, waistY + legL);
        line(centerX, waistY, centerX + 3, waistY + legL);
    }
    
    noStroke(); // Reset stroke for non-dino elements
  }

  boolean hits(Obstacle ob) {
    // Basic collision detection (using the defined collision box w, h)
    return (x + w > ob.x &&
            x < ob.x + ob.w &&
            y + h > ob.y &&
            y < ob.y + ob.h);
  }
}

// -------------------------------------------
// MODIFIED OBSTACLE CLASS: Draws a Triangle
// -------------------------------------------
class Obstacle {
  float x, y;
  float w, h;

  Obstacle() {
    // Dimensions for the triangle obstacle
    w = 40; 
    h = 40; // Reduced height slightly to make it a smaller ground obstacle
    
    x = width;
    y = height - 20 - h;
  }

  void update() {
    x -= gameSpeed;
  }

  void draw() {
    // Set style for the triangle
    fill(200, 0, 0); // Red color for the spike/pyramid
    noStroke();
    
    // Draw the triangle using its bottom-left (x, y+h), 
    // bottom-right (x+w, y+h), and top-center (x+w/2, y) vertices
    float x1 = x;
    float y1 = y + h;
    
    float x2 = x + w;
    float y2 = y + h;
    
    float x3 = x + w / 2;
    float y3 = y;
    
    triangle(x1, y1, x2, y2, x3, y3);
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
    y = height - 20; // 20 pixels high for the ground
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
    if (groundImg != null) {
      // Draw the Sand.png image twice for seamless scrolling
      image(groundImg, x1, y, w, 20);
      image(groundImg, x2, y, w, 20);
    } else {
      // Placeholder rectangles for Ground
      fill(207, 150, 52);
      noStroke();
      rect(x1, y, w, 20);
      rect(x2, y, w, 20);
    }
  }
}

// -------------------------------------------
// BUTTON CLASS (Not actively used, but kept for completeness)
// -------------------------------------------

class Button {
  String label;
  float x, y, w, h;

  Button(String label, float x, float y, float w, float h) {
    this.label = label;
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
  }

  void display() {
    if (overButton()) {
      fill(200, 200, 255); // Highlight color
    } else {
      fill(255);
    }

    strokeWeight(2);
    stroke(0);
    float x1 = x + w / 2;
    float y1 = y;
    
    // (x2, y2) = Bottom Left
    float x2 = x;
    float y2 = y + h;
    
    // (x3, y3) = Bottom Right
    float x3 = x + w;
    float y3 = y + h;
    
    // Draw the triangle
    triangle(x1, y1, x2, y2, x3, y3);

    fill(0);
    textSize(20);
    text(label, x + w / 2, y + h / 2);
  }

  boolean overButton() {
    return mouseX > x && mouseX < x + w && mouseY > y && mouseY < y + h;
  }

  boolean clicked() {
    return overButton();
  }
}
