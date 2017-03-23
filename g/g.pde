color bgColor = color(50, 50, 50);
ArrayList<Character> keyPressedList;

float pXpos;
float pYpos;
float pSize;
float pSpeed;

void setup() {
  size(400, 600);
  background(bgColor);
  smooth();

  keyPressedList = new ArrayList<Character>();
  initPlayer();
}

void initPlayer() {
  pXpos = width / 2.0;
  pYpos = height * 0.90;
  pSize = 20;
  pSpeed = 4;
}

void draw() {
  background(bgColor);
  handlePlayerInput();
  drawPlayer();

}

void keyPressed() {
  if (keyPressedList.indexOf(key) == -1) {
    keyPressedList.add(key);
  }
}

void keyReleased() {
  if (keyPressedList.indexOf(key) != -1) {
    keyPressedList.remove(keyPressedList.indexOf(key));
  }
}

void drawPlayer() {
  color playerOutline = color(0, 0, 0);
  color playerColor = color(0, 90, 45);
  stroke(playerOutline);
  fill(playerColor);
  rect(pXpos, pYpos, pSize, pSize);
}

void handlePlayerInput() {

  for(int i = 0; i < keyPressedList.size(); i ++) {
    if (keyPressedList.get(i).equals('w')) {
       pYpos -= pSpeed;
    }
    else if (keyPressedList.get(i).equals('s')) {
      pYpos += pSpeed;
    }
    else if (keyPressedList.get(i).equals('a')) {
      pXpos -= pSpeed;
    }
    else if (keyPressedList.get(i).equals('d')) {
      pXpos += pSpeed;
    }
  }
}
