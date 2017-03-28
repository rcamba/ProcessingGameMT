class Player {
  float xPos, yPos, size, speed;
  color playerOutline = color(10, 170, 125); // change palyer outline tooo along with fill for other play
  color playerColor = color(130, 260, 230, 150);
  Boundary b;

  Player(float pXpos, float pYpos, float pSize, float pSpeed, Boundary b) {
    this.xPos = pXpos;
    this.yPos = pYpos;
    this.size = pSize;
    this.speed = pSpeed;
    this.b = b;
  }

  Player(float pXpos, float pYpos, float pSize, float pSpeed, Boundary b, color c) {
    this.xPos = pXpos;
    this.yPos = pYpos;
    this.size = pSize;
    this.speed = pSpeed;
    this.b = b;
    this.playerColor = c;
  }

  float getXpos() {
    return xPos;
  }

  float getYpos() {
    return yPos;
  }

  void setXpos(float newX) {
    xPos = newX;
    if (xPos + (size / 2.0) > b.getEndX()) {
        xPos = b.getEndX() - (size / 2.0) - b.getThickness();
    }
    else if (xPos - (size / 2.0) <= b.getStartX()) {
        xPos = b.getStartX() + (size / 2.0) + b.getThickness();
    }
  }

  void setYpos(float newY) {
    yPos = newY;
    if (yPos + (size / 2.0) >= b.getEndY()) {
        yPos = b.getEndY() - (size / 2.0) - b.getThickness();
    }
    else if (yPos - (size / 2.0) <= b.getStartY()) {
        yPos = b.getStartY() + (size / 2.0) + b.getThickness();
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
