//Samuel Maass | Start Screen | Nov 14
char screenState;

char screen = 's';   // s = start, m = menu, t = settings, p = play, u = pause, g = game over, a = app stats
Button btnStart, btnMenu, btnSettings, btnBack, btnPause;

Button startButton;
Button settingsButton;
Button backToMenuButton;
Button pauseButton;


void setup() {
  size(800, 600); 
  

  screenState = 's'; 
  

  startButton = new Button("Start Game", 300, 350, 200, 50);
  settingsButton = new Button("Settings", 300, 420, 200, 50);
  backToMenuButton = new Button("Back to Menu", 50, 550, 150, 40);
  pauseButton = new Button("Pause", 700, 20, 80, 30);
  // ... etc.
}

// [MAIN DRAW LOOP]
// Runs 60 times per second
void draw() {
  // This is the Screen Manager
  switch(screenState) {
    case 's':
      drawStartScreen();
      break;
    case 'm':
      drawMenuScreen();
      break;
    case 't':
      drawSettingsScreen();
      break;
    case 'p':
      drawPlayScreen();
      break;
    case 'u':
      drawPauseScreen();
      break;
    case 'g':
      drawGameOverScreen();
      break;
    case 'a':
      drawStatsScreen();
      break;
    default:
      // Optional: A default case for errors
      background(255, 0, 0); // Bright red = error
      fill(255);
      textAlign(CENTER);
      text("ERROR: Unknown screen state: " + screenState, width/2, height/2);
      break;
  }
}

void mousePressed() {

  

  if (screenState == 's') {
    if (startButton.isClicked(mouseX, mouseY)) {
      screenState = 'p';
    }
    if (settingsButton.isClicked(mouseX, mouseY)) {
      screenState = 't'; 
    }
  }
  

  else if (screenState == 'p') {
    if (pauseButton.isClicked(mouseX, mouseY)) {
      screenState = 'u'; 
    }
    // (You might also check if the player died)
    // if (player.health <= 0) {
    //   screenState = 'g'; // Go to Game Over
    // }
  }
  

  else if (screenState == 'u') {
    // Add a "Resume" button
    // if (resumeButton.isClicked(mouseX, mouseY)) {
    //   screenState = 'p'; // Go back to Play
    // }
    if (backToMenuButton.isClicked(mouseX, mouseY)) {
      screenState = 'm'; 
    }
  }
  

  else if (screenState == 't') {
    if (backToMenuButton.isClicked(mouseX, mouseY)) {
      screenState = 'm'; 
    }
  }
  
  // ... and so on for 'm', 'g', and 'a'
}
