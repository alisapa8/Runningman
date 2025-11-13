//Alisa Pavlova | 11.11.2025 | RunningMan Start screen
Player fred;
void setup() {
  size(700,300);
  background(#2debfc);
  fred = new Player();
}

void draw() {
  background(#2debfc);
  fred.display();
}
