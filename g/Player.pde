class Player {
  float xPos, yPos, size, speed;
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

  float getSize() {
    return size;
  }

  float getSpeed() {
    return speed;
  }
}
