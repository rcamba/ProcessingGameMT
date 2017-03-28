class Enemy {
  float xPos, yPos, radius, speedX, speedY;
  color outlineColor = color(150, 0, 150);
  color defaultColor =  color(0, 0, 50, 50);
  color fillColor = defaultColor;
  boolean newEnemyStatus = true;
  boolean edibleStatus = false;
  Boundary b;

  Enemy(float xPos, float yPos, float radius, float speed, Boundary b) {
    this.b = b;

    this.xPos = b.getWidth() / 2.0;
    this.yPos = b.getHeight() / 2.0;
    this.radius = radius * 2;
    this.speedX = speed;
    this.speedY = speed;

    updatePos(xPos, yPos); // keep the ball in bounds from random x/yPos
  }

  float getXpos() {
    return xPos;
  }

  float getYpos() {
    return yPos;
  }

  void display() {
    stroke(outlineColor);
    fill(fillColor);
    ellipseMode(CENTER);
    ellipse(xPos, yPos, radius, radius);
  }

  void updatePos(float newXpos, float newYpos) {
    xPos = newXpos;
    yPos = newYpos;
    int flip = int(round(random(0, 1)));
    if (flip == 0) {
      flip -= 1;
    }
    if (xPos + (radius / 2.0) >= b.getEndX()) {
      xPos = b.getEndX() - (radius / 2.0) - b.getThickness();
      speedX *= -1;
      speedY *= flip;
    }
    else if(xPos - (radius / 2.0) <= b.getStartX()) {
      xPos = b.getStartX() + (radius / 2.0) + b.getThickness();
      speedX *= -1;
      speedY *= flip;
    }

    if(yPos + (radius / 2.0) >= b.getEndY()) {
      yPos = b.getEndY() - (radius / 2.0) - b.getThickness();
      speedX *= flip;
      speedY *= -1;
    }
    else if(yPos - (radius / 2.0) <= b.getStartY()) {
      yPos = b.getStartY() + (radius / 2.0) + b.getThickness();
      speedX *= flip;
      speedY *= -1;
    }
  }

  float getSpeedX() {
    return speedX;
  }

  float getSpeedY() {
    return speedY;
  }

  void setSpeedX(float newSpeed) {
    speedX = newSpeed;
  }

  void setSpeedY(float newSpeed) {
    speedY = newSpeed;
  }

  float getSize() {
    return radius;
  }

  boolean isNewEnemy() {
    return newEnemyStatus;
  }

  void setNewEnemyStatus(boolean newStatus) {
    newEnemyStatus = newStatus;
  }

  color getColor() {
    return fillColor;
  }

  color getDefaultColor() {
    return defaultColor;
  }

  void setColor(color c) {
    fillColor = c;
  }

  void setColor(int c1, int c2, int c3) {
    fillColor = color(c1, c2, c3);
  }

  void setEdibleStatus(boolean newStatus) {
    edibleStatus = newStatus;
  }

  boolean isEdible() {
    return edibleStatus;
  }

}
