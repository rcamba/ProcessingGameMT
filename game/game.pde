color bgColor = color(50, 50, 50);
ArrayList<Character> keyPressedList;
ArrayList<Enemy> leftEnemyList, rightEnemyList;

Player leftPlayer, rightPlayer;
float pSize = 20;
float pSpeed = 4; // low speed causes boundary jutter/seizure like movement

Boundary leftBoundary, rightBoundary;
PowerUp leftPup, rightPup;

float lastTimeEnemyAdded;
float enemyAdditionInterval;
boolean alive = true;

float restartCooldown = 2;
float lastTimeRestarted = -1;

float gameStartTime;
float scoreTime = -1;


void setup() {
  size(400, 600);
  background(bgColor);
  smooth();

  keyPressedList = new ArrayList<Character>();

  initializeGame();
}


void initializeGame() {
  leftEnemyList = new ArrayList<Enemy>();
  rightEnemyList = new ArrayList<Enemy>();

  initBoundaries();
  initPlayers();
  initEnemies();
  initPowerUp();

  gameStartTime = millis();
  scoreTime = -1;

  alive = true;
}


void initBoundaries() {
  float lBoundaryStartX = 0;
  float lBoundaryEndX = (width / 2.0);
  float lBoundaryStartY = 0;
  float lBoundaryEndY = height;
  leftBoundary = new Boundary(lBoundaryStartX, lBoundaryEndX, lBoundaryStartY, lBoundaryEndY);

  float rBoundaryStartX = lBoundaryEndX;
  float rBoundaryEndX = width;
  float rBoundaryStartY = 0;
  float rBoundaryEndY = height;
  rightBoundary = new Boundary(rBoundaryStartX, rBoundaryEndX, rBoundaryStartY, rBoundaryEndY);
}


void initPlayers() {
  leftPlayer = new Player(((leftBoundary.getStartX() + leftBoundary.getEndX()) / 2.0) - (pSize / 2.0),
                             leftBoundary.getEndY() * 0.90,
                             pSize, pSpeed, leftBoundary);
  rightPlayer = new Player(((rightBoundary.getStartX() + rightBoundary.getEndX()) / 2.0) - (pSize / 2.0),
                             rightBoundary.getEndY() * 0.90,
                             pSize, pSpeed, rightBoundary, color(140, 120, 200));

  leftBoundary.setOutlineColor(rightPlayer.getColor());
  rightBoundary.setOutlineColor(leftPlayer.getColor());
}


void initEnemies() {
  enemyAdditionInterval = 3; //seconds
  int numOfInitEnemies = 3;
  //spawn initial enemies only at top half of screen
  Enemy leftE, rightE;
  for(int i = 0; i < numOfInitEnemies; i ++) {
    leftE = createEnemy(random(leftBoundary.getStartX(), leftBoundary.getEndX()), random(leftBoundary.getStartY(), leftBoundary.getEndY() / 2.0), leftBoundary);
    leftE.setNewEnemyStatus(false);
    leftEnemyList.add(leftE);

    rightE = createEnemy(random(rightBoundary.getStartX(), rightBoundary.getEndX()), random(rightBoundary.getStartY(), rightBoundary.getEndY() / 2.0), rightBoundary);
    rightE.setNewEnemyStatus(false);
    rightEnemyList.add(rightE);
  }
}

void initPowerUp() {
  float powerUpScreenRatio = 0.000075;
  float powerUpRadius = (leftBoundary.getEndX() * leftBoundary.getEndY()) * powerUpScreenRatio;
  //spawn initial power ups only at top half of screen
  leftPup = new PowerUp(random(leftBoundary.getStartX(), leftBoundary.getEndX()), random(leftBoundary.getStartY(), leftBoundary.getEndY() / 2.0), powerUpRadius, leftBoundary, rightPlayer.getColor());
  rightPup = new PowerUp(random(rightBoundary.getStartX(), rightBoundary.getEndX()), random(rightBoundary.getStartY(), rightBoundary.getEndY() / 2.0), powerUpRadius, rightBoundary, leftPlayer.getColor());
}


Enemy createEnemy(Boundary b) {
  return createEnemy(random(b.getStartX(), b.getEndX()), random(b.getStartY(), b.getEndY()), b);
}


Enemy createEnemy(float x, float y, Boundary b) {
  float enemyScreenRatio = 0.00015;
  float enemyRadius = (b.getWidth() * b.getHeight()) * enemyScreenRatio;
  float enemySpeed = int(round(random(1, 2)));
  lastTimeEnemyAdded = millis();

  return new Enemy(x, y, enemyRadius, enemySpeed, b);
}


void draw() {
  if (alive) {
    background(bgColor);
    leftBoundary.display();
    rightBoundary.display();

    handlePlayersInputs();
    drawPlayers();

    checkToAddMoreEnemies();
    newEnemyWarning(leftEnemyList);
    newEnemyWarning(rightEnemyList);

    updateEnemiesPos(leftEnemyList);
    updateEnemiesPos(rightEnemyList);
    drawEnemies();

    checkPlayerEnemyCollision(leftPlayer, leftEnemyList);
    checkPlayerEnemyCollision(rightPlayer, rightEnemyList);

    drawPowerUp();
    checkPlayerPowerUpCollision(leftPlayer, rightEnemyList, leftPup);  //left pup controls right enemies and vice versa
    checkPlayerPowerUpCollision(rightPlayer, leftEnemyList, rightPup);
  }
  else {
    showGameOverScreen();

    handlePlayersInputs();
  }

}


void handlePlayersInputs() {
  for(int i = 0; i < keyPressedList.size(); i ++) {
    if(keyPressedList.get(i).equals('r') && (millis() - lastTimeRestarted) / 1000 >= restartCooldown) {
      lastTimeRestarted = millis();
      initializeGame();
    }
    else {
      handleLeftPlayerInput(keyPressedList.get(i));
      handleRightPlayerInput(keyPressedList.get(i));
    }
  }
}


void handleLeftPlayerInput(Character keyChar) {
  if (keyChar.equals('w')) {
     leftPlayer.setYpos(leftPlayer.getYpos() - leftPlayer.getSpeed());
  }
  else if (keyChar.equals('s')) {
    leftPlayer.setYpos(leftPlayer.getYpos() + leftPlayer.getSpeed());
  }
  else if (keyChar.equals('a')) {
    leftPlayer.setXpos(leftPlayer.getXpos() - leftPlayer.getSpeed());
  }
  else if (keyChar.equals('d')) {
    leftPlayer.setXpos(leftPlayer.getXpos() + leftPlayer.getSpeed());
  }
}


void handleRightPlayerInput(Character keyChar) {
  if (keyChar.equals('i')) {
     rightPlayer.setYpos(rightPlayer.getYpos() - rightPlayer.getSpeed());
  }
  else if (keyChar.equals('k')) {
    rightPlayer.setYpos(rightPlayer.getYpos() + rightPlayer.getSpeed());
  }
  else if (keyChar.equals('j')) {
    rightPlayer.setXpos(rightPlayer.getXpos() - rightPlayer.getSpeed());
  }
  else if (keyChar.equals('l')) {
    rightPlayer.setXpos(rightPlayer.getXpos() + rightPlayer.getSpeed());
  }
}


void drawPlayers() {
  leftPlayer.display();
  rightPlayer.display();
}


void checkToAddMoreEnemies() {
  if ((millis() - lastTimeEnemyAdded) / 1000 >= enemyAdditionInterval)  {
    leftEnemyList.add(createEnemy(leftBoundary));
    rightEnemyList.add(createEnemy(rightBoundary));
  }
}


void newEnemyWarning(ArrayList<Enemy> enemyList) {
  Enemy e;
  float newEnemyCoolDownTime = 2; // seconds
  for(int i = 0; i < enemyList.size(); i++) {
    e = enemyList.get(i);

    if (e.isNewEnemy() && (millis() - lastTimeEnemyAdded) / 1000 <= newEnemyCoolDownTime) {
      flickerEffect(e, e.getDefaultColor());
    }
    else if (e.isNewEnemy()) {
      e.setNewEnemyStatus(false);
      e.setColor(e.getDefaultColor());
    }
  }
}


void flickerEffect (Enemy e, color flickerBaseColor) {
   //flicker effect - swap fill color ever 2/100th of a second;

  if((round(millis() - lastTimeEnemyAdded) / 100) % 2 == 0) {
    e.setColor(color(red(flickerBaseColor), green(flickerBaseColor), blue(flickerBaseColor), alpha(flickerBaseColor) + 200));
  }
  else {
    e.setColor(color(red(flickerBaseColor), green(flickerBaseColor), blue(flickerBaseColor), alpha(flickerBaseColor) - 200));
  }
}


void updateEnemiesPos(ArrayList<Enemy> enemyList) {
  Enemy e;
  for(int i = 0; i < enemyList.size(); i++) {
    e = enemyList.get(i);
    if(e.isNewEnemy() == false) {
      e.updatePos(e.getXpos() + e.getSpeedX(), e.getYpos() + e.getSpeedY());
    }
  }
}


void drawEnemies() {
  for(int i = 0; i < leftEnemyList.size(); i++) {
    leftEnemyList.get(i).display();
  }

  for(int i = 0; i < rightEnemyList.size(); i++) {
    rightEnemyList.get(i).display();
  }
}


void checkPlayerEnemyCollision(Player p, ArrayList<Enemy> enemyList) {
  Enemy e;
  for(int i = 0; i < enemyList.size(); i++) {
    e = enemyList.get(i);
    if(e.isNewEnemy() == false) { // new enemies cannot be collided in to until cooldown wears off
      if (pCollideE(p, e)) {
        if(e.isEdible()) {
          enemyList.remove(enemyList.indexOf(e));
        }
        else {
          alive = false;
        }
      }
    }
  }
}


boolean pCollideE(Player p_, Enemy e) {
  float distX = abs(e.getXpos() - p_.getXpos());
  float distY = abs(e.getYpos() - p_.getYpos());

  if (distX > (p_.getSize() / 2.0) + (e.getSize() / 2.0)) { return false; } // early check, if passes, can't possibly have collided
  if (distY > (p_.getSize() / 2.0) + (e.getSize() / 2.0)) { return false; } // early check, if passes, can't possibly have collided

  if (distX <= (p_.getSize() / 2.0)) {
    return true;
  }
  if (distY <= (p_.getSize() / 2.0)) {
    return true;
  }

  float dx = distX - (p_.getSize() / 2.0);
  float dy = distY - (p_.getSize() / 2.0);

  return ((dx * dx) + (dy * dy)) <= (e.getSize() / 2.0) * (e.getSize() / 2.0);
}


boolean pCollidePup(Player p_, PowerUp pup_) { // no inherit zzz
  float distX = abs(pup_.getXpos() - p_.getXpos());
  float distY = abs(pup_.getYpos() - p_.getYpos());

  if (distX > (p_.getSize() / 2.0) + (pup_.getSize() / 2.0)) { return false; } // early check, if passes, can't possibly have collided
  if (distY > (p_.getSize() / 2.0) + (pup_.getSize() / 2.0)) { return false; } // early check, if passes, can't possibly have collided

  if (distX <= (p_.getSize() / 2.0)) {
    return true;
  }
  if (distY <= (p_.getSize() / 2.0)) {
    return true;
  }

  float dx = distX - (p_.getSize() / 2.0);
  float dy = distY - (p_.getSize() / 2.0);

  return ((dx * dx) + (dy * dy)) <= (pup_.getSize() / 2.0) * (pup_.getSize() / 2.0);
}


void drawPowerUp() {
  leftPup.display();
  rightPup.display();
}


void checkPlayerPowerUpCollision(Player p, ArrayList<Enemy> enemyList, PowerUp pup) {
  final float flickerDuration = leftPup.getLengthOfEffect() + 2; // 2 seconds

  //check for pup collision, if hit make enemies edible
  if (pup.isVisible() && pCollidePup(p, pup)) {
    pup.setVisibility(false);
    pup.setLastTimePickedUp(millis());
    Enemy e;
    for(int i = 0; i < enemyList.size(); i++) {
      e = enemyList.get(i);
      if (e.isNewEnemy() == false) {
        e.setEdibleStatus(true);
        e.setColor(e.getEdibleColor());
        e.display();
      }
    }
  }

  // if last time picked up is -1 then it hasn't been picked up yet
  else if(pup.getLastTimePickedUp() > -1 && (millis() - pup.getLastTimePickedUp()) / 1000 >= pup.getLengthOfEffect()) {
    Enemy e;
    for(int i = 0; i < enemyList.size(); i++) {
      e = enemyList.get(i);
      if ((millis() - pup.getLastTimePickedUp()) / 1000 < flickerDuration && e.isEdible()) { // only flicker those that were initially edible, otehrs aren't affected by powerup
        flickerEffect(e, e.getEdibleColor());
      }
      else {
        e.setEdibleStatus(false);
        e.setColor(e.getDefaultColor());
      }
    }

    //respawn pup
    if(pup.isVisible() == false && (millis() - pup.getLastTimePickedUp()) / 1000 >= pup.getRespawnInterval()) {
      pup.randomizePos();
      pup.setVisibility(true);
    }
  }
}


void showGameOverScreen() {
  float tWidth;
  String restartPrompt = "Press 'r' to restart game";
  if (scoreTime == -1) { // only caclulate it once until restarted
    scoreTime = (millis() - gameStartTime) / 1000; //convert milliseconds to seconds
  }

  textSize(25);
  stroke(255);
  fill(255);
  tWidth = textWidth(Float.toString(scoreTime)) / 2.0;
  text(nf(scoreTime, 0, 2), (width / 2.0) - tWidth, height / 2.0);

  tWidth = textWidth(restartPrompt) / 2.0;
  //adding the textAscent() and textDescent() values will give you the total height of the line.
  text(restartPrompt, (width / 2.0) - tWidth, height / 2.0 + textAscent() + textDescent());
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