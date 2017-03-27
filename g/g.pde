color bgColor = color(50, 50, 50);
ArrayList<Character> keyPressedList;
ArrayList<Enemy> enemyList;
Player p;
Boundary b;

float lastTimeEnemyAdded;
float enemyAdditionInterval;


void setup() {
  size(400, 600);
  background(bgColor);
  smooth();

  keyPressedList = new ArrayList<Character>();
  enemyList = new ArrayList<Enemy>();

  initLeftBoundary();
  initPlayer();
  initEnemies();
}


void initPlayer() {
  float pSize = 20;
  float pSpeed = 4; // low speed causes boundary jutter/seizure like movement
  p = new Player(b.getEndX() / 2.0 - (pSize / 2.0), b.getEndY() * 0.90, pSize, pSpeed, b);
}


void initEnemies() {
  enemyAdditionInterval = 5; //seconds
  //spawn initial enemies only at top half of screen
  addEnemy(random(b.getStartX(), b.getEndX()), random(b.getStartY(), b.getEndY() / 2.0));
  addEnemy(random(b.getStartX(), b.getEndX()), random(b.getStartY(), b.getEndY() / 2.0));
  addEnemy(random(b.getStartX(), b.getEndX()), random(b.getStartY(), b.getEndY() / 2.0));
}


void addEnemy() {
  addEnemy(random(b.getStartX(), b.getEndX()), random(b.getStartY(), b.getEndY()));
}


void addEnemy(float x, float y) {
  float enemyScreenRatio = 0.00015;
  float enemyRadius = (b.getEndX() * b.getEndY()) * enemyScreenRatio;
  float enemySpeed = int(round(random(1, 2)));
  enemyList.add(new Enemy(x, y, enemyRadius, enemySpeed, b));
  lastTimeEnemyAdded = millis();
}


void initLeftBoundary() {
  float lBoundaryStartX = 0;
  float lBoundaryEndX = width / 2.0;
  float lBoundaryStartY = 0;
  float lBoundaryEndY = height;
  b = new Boundary(lBoundaryStartX, lBoundaryEndX, lBoundaryStartY, lBoundaryEndY);
}


void draw() {
  background(bgColor);
  b.display();

  handlePlayerInput();
  drawPlayer();

  checkToAddMoreEnemies();
  newEnemyWarning();

  updateEnemiesPos();
  drawEnemies();

  checkPlayerEnemyCollision();

}


boolean pCollideE(Player p, Enemy e) {
  float distX = abs(e.getXpos() - p.getXpos());
  float distY = abs(e.getYpos() - p.getYpos());

  if (distX > (p.getSize() / 2.0) + (e.getSize() / 2.0)) { return false; } // early check, if passes, can't possibly have collided
  if (distY > (p.getSize() / 2.0) + (e.getSize() / 2.0)) { return false; } // early check, if passes, can't possibly have collided

  if (distX <= (p.getSize() / 2.0)) {
    return true;
  }
  if (distY <= (p.getSize() / 2.0)) {
    return true;
  }

  float dx = distX - (p.getSize() / 2.0);
  float dy = distY - (p.getSize() / 2.0);

  return ((dx * dx) + (dy * dy)) <= (e.getSize() / 2.0) * (e.getSize() / 2.0);
}


void checkPlayerEnemyCollision() {
  Enemy e;
  for(int i = 0; i < enemyList.size(); i++) {
    e = enemyList.get(i);
    if(e.isNewEnemy() == false) { // new enemies cannot be collided in to until cooldown wears off
      if (pCollideE(p, e)) {
        noLoop();
        println("Hit");
      }
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


void drawPlayer() {
  p.display();
}


void drawEnemies() {
  for(int i = 0; i < enemyList.size(); i++) {
    enemyList.get(i).display();
  }
}


void handlePlayerInput() {

  for(int i = 0; i < keyPressedList.size(); i ++) {
    if (keyPressedList.get(i).equals('w')) {
       p.setYpos(p.getYpos() - p.getSpeed());
    }
    else if (keyPressedList.get(i).equals('s')) {
      p.setYpos(p.getYpos() + p.getSpeed());
    }
    else if (keyPressedList.get(i).equals('a')) {
      p.setXpos(p.getXpos() - p.getSpeed());
    }
    else if (keyPressedList.get(i).equals('d')) {
      p.setXpos(p.getXpos() + p.getSpeed());
    }
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
      //flicker effect - swap fill color ever 2/100th of a second;
      color c = e.getDefaultColor();
      if((round(millis() - lastTimeEnemyAdded) / 100) % 2 == 0) {
        e.setColor(color(red(c), green(c), blue(c), alpha(c) + 200));
      }
      else {
        e.setColor(color(red(c), green(c), blue(c), alpha(c) - 200));
      }
    }
    else {
      e.setNewEnemyStatus(false);
      e.setColor(e.getDefaultColor());
    }
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