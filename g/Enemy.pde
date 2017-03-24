class Enemy {
  float xPos, yPos, radius, speedX, speedY;
  color outlineColor = color(150, 0, 150);
  color fillColor = color(0, 0, 50, 50);
  Boundary b;

  Enemy(float xPos, float yPos, float radius, float speed, Boundary b) {
    this.xPos = xPos;
    this.yPos = yPos;
    this.radius = radius;
    this.speedX = speed;
    this.speedY = speed;
    this.b = b;
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

  void updatePos(float newXpos, float newYpos) {
    xPos = newXpos;
    yPos = newYpos;
    int flip = int(round(random(0, 1)));
    if (flip == 0) {
        flip -= 1;
    }

    if (xPos + radius>= b.getEndX()) {
        xPos = b.getEndX() - radius;
        speedX *= -1;
        speedY *= flip;
    }
    else if(xPos - radius + 1 <= b.getStartX()) {
        xPos = b.getStartX() + radius;
        speedX *= -1;
        speedY *= flip;
    }

    if(yPos + radius >= b.getEndY()) {
        yPos = b.getEndY() - radius;
        speedX *= flip;
        speedY *= -1;
    }
    else if(yPos - radius <= b.getStartY()) {
        yPos = b.getStartY() + radius;
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
}
