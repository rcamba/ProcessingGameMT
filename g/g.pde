color bgColor = color(50, 50, 50);
ArrayList<Character> keyPressedList;
ArrayList<Enemy> enemyList;
Player p;
Boundary b;

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
  p = new Player(width / 2.0, height * 0.90, 20, 4, b);
}

void initEnemies() {
  addEnemy();
  addEnemy();
}

void addEnemy() {
  float enemyRadius = 5;
  enemyList.add(new Enemy(random(b.getStartX(), b.getEndX()), random(b.getStartY(), b.getEndY()), enemyRadius));
}

void initLeftBoundary() {
  float lBoundaryStartX = 0;
  float lBoundaryEndX = width;
  float lBoundaryStartY = 0;
  float lBoundaryEndY = height;
  b = new Boundary(lBoundaryStartX, lBoundaryEndX, lBoundaryStartY, lBoundaryEndY);
}

void draw() {
  background(bgColor);
  b.display();

  handlePlayerInput();
  drawPlayer();

  updateEnemiesPos();
  drawEnemies();
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
  rect(p.getXpos(), p.getYpos(), p.getSize(),  p.getSize());
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

void updateEnemiesPos() {
  float xInc, yInc;

  for(int i = 0; i < enemyList.size(); i++) {
    Enemy e = enemyList.get(i);
    if (p.getXpos() > e.getXpos()) {
      xInc = 1;
    }
    else {
      xInc = -1;
    }

    if (p.getYpos() > e.getYpos()) {
      yInc = 1;
    }
    else {
      yInc = -1;
    }

    enemyList.get(i).updatePos(e.getXpos() + xInc, e.getYpos() + yInc);
  }
}
