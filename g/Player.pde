class Player {
  float xPos, yPos, size, speed;
  color playerOutline = color(10, 170, 125);
  color playerColor = color(130, 260, 230, 150);
  Boundary b;

  Player(float pXpos, float pYpos, float pSize, float pSpeed, Boundary b) {
    this.xPos = pXpos;
    this.yPos = pYpos;
    this.size = pSize;
    this.speed = pSpeed;
    this.b = b;
  }

  float getXpos() {
    return xPos;
  }

  float getYpos() {
    return yPos;
  }

  void setXpos(float newX) {
    xPos = newX;
    if (xPos + size > b.getEndX()) {
        xPos = b.getEndX() - size - b.getThickness() + 1;
    }
    else if (xPos < b.getStartX()) {
        xPos = b.getStartX() + b.getThickness() - 1;
    }
  }

  void setYpos(float newY) {
    yPos = newY;
    if (yPos + size > b.getEndY()) {
        yPos = b.getEndY() - size - b.getThickness() + 1;
    }
    else if (yPos < b.getStartY()) {
        yPos = b.getStartY() + b.getThickness() - 1;
    }
  }

  void display() {
      stroke(playerOutline);
      fill(playerColor);
      rectMode(CENTER);
      rect(xPos, yPos, size,  size);
  }

  float getSize() {
    return size;
  }

  float getSpeed() {
    return speed;
  }
}
