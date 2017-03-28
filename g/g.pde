color bgColor = color(50, 50, 50);
ArrayList<Character> keyPressedList;
ArrayList<Enemy> enemyList;

Player leftPlayer;
Player rightPlayer;
float pSize = 20;
float pSpeed = 4; // low speed causes boundary jutter/seizure like movement

Boundary leftBoundary;
Boundary rightBoundary;
PowerUp pup;

float lastTimeEnemyAdded;
float enemyAdditionInterval;


void setup() {
  size(400, 600);
  background(bgColor);
  smooth();

  keyPressedList = new ArrayList<Character>();
  enemyList = new ArrayList<Enemy>();

  initBoundaries();

  initPlayers();

  initEnemies();
  initPowerUp();
}


void initPlayers() {
  leftPlayer = new Player(((leftBoundary.getStartX() + leftBoundary.getEndX()) / 2.0) - (pSize / 2.0),
                             leftBoundary.getEndY() * 0.90,
                             pSize, pSpeed, leftBoundary);
  rightPlayer = new Player(((rightBoundary.getStartX() + rightBoundary.getEndX()) / 2.0) - (pSize / 2.0),
                             rightBoundary.getEndY() * 0.90,
                             pSize, pSpeed, rightBoundary, color(160, 85, 100));
}

void initEnemies() {
  enemyAdditionInterval = 3; //seconds
  //spawn initial enemies only at top half of screen
  addEnemy(random(leftBoundary.getStartX(), leftBoundary.getEndX()), random(leftBoundary.getStartY(), leftBoundary.getEndY() / 2.0));
  addEnemy(random(leftBoundary.getStartX(), leftBoundary.getEndX()), random(leftBoundary.getStartY(), leftBoundary.getEndY() / 2.0));
  addEnemy(random(leftBoundary.getStartX(), leftBoundary.getEndX()), random(leftBoundary.getStartY(), leftBoundary.getEndY() / 2.0));
  for(int i = 0; i < enemyList.size(); i ++) {
    enemyList.get(i).setNewEnemyStatus(false);
  }
}

void initPowerUp() {
  float powerUpScreenRatio = 0.000075;
  float powerUpRadius = (leftBoundary.getEndX() * leftBoundary.getEndY()) * powerUpScreenRatio;
  pup = new PowerUp(random(leftBoundary.getStartX(), leftBoundary.getEndX()), random(leftBoundary.getStartY(), leftBoundary.getEndY()), powerUpRadius, leftBoundary);
}


void addEnemy() {
  addEnemy(random(leftBoundary.getStartX(), leftBoundary.getEndX()), random(leftBoundary.getStartY(), leftBoundary.getEndY()));
}


void addEnemy(float x, float y) {
  float enemyScreenRatio = 0.00015;
  float enemyRadius = (leftBoundary.getEndX() * leftBoundary.getEndY()) * enemyScreenRatio;
  float enemySpeed = int(round(random(1, 2)));
  enemyList.add(new Enemy(x, y, enemyRadius, enemySpeed, leftBoundary));
  lastTimeEnemyAdded = millis();
}


void initBoundaries() {
  float lBoundaryStartX = 0;
  float lBoundaryEndX = width / 2.0;
  float lBoundaryStartY = 0;
  float lBoundaryEndY = height;

  leftBoundary = new Boundary(lBoundaryStartX, lBoundaryEndX, lBoundaryStartY, lBoundaryEndY);

  float rBoundaryStartX = lBoundaryEndX + 1;
  float rBoundaryEndX = width;
  float rBoundaryStartY = 0;
  float rBoundaryEndY = height;
  rightBoundary = new Boundary(rBoundaryStartX, rBoundaryEndX, rBoundaryStartY, rBoundaryEndY, color(225, 180, 50));
}


void draw() {
  background(bgColor);
  leftBoundary.display();
  rightBoundary.display();

  handlePlayersInputs();
  drawPlayers();

  checkToAddMoreEnemies();
  newEnemyWarning();

  updateEnemiesPos();
  drawEnemies();

  checkPlayerEnemyCollision();

  drawPowerUp();
  checkPlayerPowerUpCollision();

}

void drawPowerUp() {
  pup.display();
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

boolean pCollidePup(Player p_, PowerUp pup_) {
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


void checkPlayerEnemyCollision() {
  Enemy e;
  for(int i = 0; i < enemyList.size(); i++) {
    e = enemyList.get(i);
    if(e.isNewEnemy() == false) { // new enemies cannot be collided in to until cooldown wears off
      if (pCollideE(leftPlayer, e)) {
        if(e.isEdible()) {
          enemyList.remove(enemyList.indexOf(e));
        }
        else {
          noLoop();
          println("Hit");
        }
      }
    }
  }
}

void checkPlayerPowerUpCollision() {
  final float flickerDuration = pup.getLengthOfEffect() + 2; // 2 seconds

  if (pup.isVisible() && pCollidePup(leftPlayer, pup)) {
    pup.setVisibility(false);
    pup.setLastTimePickedUp(millis());
    Enemy e;
    for(int i = 0; i < enemyList.size(); i++) {
      e = enemyList.get(i);
      if (e.isNewEnemy() == false) {
        e.setEdibleStatus(true);
        e.setColor(color(255, 255, 255, 100));
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
        flickerEffect(e);
      }
      else {
        e.setEdibleStatus(false);
        e.setColor(e.getDefaultColor());
      }
    }
    if(pup.isVisible() == false && (millis() - pup.getLastTimePickedUp()) / 1000 >= pup.getRespawnInterval()) {
      pup.randomizePos();
      pup.setVisibility(true);
    }
  }
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


void drawPlayers() {
  leftPlayer.display();
  rightPlayer.display();
}


void drawEnemies() {
  for(int i = 0; i < enemyList.size(); i++) {
    enemyList.get(i).display();
  }
}


void handlePlayersInputs() {
  for(int i = 0; i < keyPressedList.size(); i ++) {

    handleLeftPlayerInput(keyPressedList.get(i));
    handleRightPlayerInput(keyPressedList.get(i));
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


void checkToAddMoreEnemies() {
  if ((millis() - lastTimeEnemyAdded) / 1000 >= enemyAdditionInterval)  {
    addEnemy();
  }
}

void newEnemyWarning() {
  Enemy e;
  float newEnemyCoolDownTime = 2; // seconds
  for(int i = 0; i < enemyList.size(); i++) {
    e = enemyList.get(i);

    if (e.isNewEnemy() && (millis() - lastTimeEnemyAdded) / 1000 <= newEnemyCoolDownTime) {
      flickerEffect(e);
    }
    else if (e.isNewEnemy()) {
      e.setNewEnemyStatus(false);
      e.setColor(e.getDefaultColor());
    }
  }
}

void flickerEffect (Enemy e) {
   //flicker effect - swap fill color ever 2/100th of a second;
  color c = e.getDefaultColor();
  if((round(millis() - lastTimeEnemyAdded) / 100) % 2 == 0) {
    e.setColor(color(red(c), green(c), blue(c), alpha(c) + 200));
  }
  else {
    e.setColor(color(red(c), green(c), blue(c), alpha(c) - 200));
  }
}


void updateEnemiesPos() {
  Enemy e;
  for(int i = 0; i < enemyList.size(); i++) {
    e = enemyList.get(i);
    if(e.isNewEnemy() == false) {
      e.updatePos(e.getXpos() + e.getSpeedX(), e.getYpos() + e.getSpeedY());
    }
  }
}