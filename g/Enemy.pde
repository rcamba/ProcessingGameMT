class Enemy {
  float xPos, yPos, radius, speed;
  color outlineColor = color(0, 0, 0);
  color fillColor = color(0, 0, 50);

  Enemy(float xPos, float yPos, float radius) {
    this.xPos = xPos;
    this.yPos = yPos;
    this.radius = radius;
    this.speed = 3;
  }

  Enemy(float xPos, float yPos, float radius, float speed) {
    this.xPos = xPos;
    this.yPos = yPos;
    this.radius = radius;
    this.speed = speed;
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
    ellipse(xPos, yPos, radius * 2, radius * 2);
  }

  void updatePos(float xPos, float yPos) {
      this.xPos = xPos;
      this.yPos = yPos;
  }

  float getSpeed() {
    return speed;
  }
}
