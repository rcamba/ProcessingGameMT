class PowerUp {
  float xPos, yPos, radius;
  color outlineColor = color(190, 150, 0);
  color fillColor = color(210, 80, 180, 150);
  boolean visibilityStatus = true;
  float lastTimePickedUp = -1;
  final float lengthOfEffect = 5; // seconds
  final float respawnInterval = 15; // seconds
  Boundary b;

  PowerUp(float xPos, float yPos, float radius, Boundary b) {
    this.b = b;

    // unnecessary... ?
    this.xPos = b.getWidth() / 2.0;
    this.yPos = b.getHeight() / 2.0;

    this.radius = radius * 2;

    updatePos(xPos, yPos); // keep the ball in bounds from random x/yPos
  }

  float getXpos() {
    return xPos;
  }

  float getYpos() {
    return yPos;
  }

  void display() {
    if (visibilityStatus) {
      stroke(outlineColor);
      fill(fillColor);
      ellipseMode(CENTER);
      ellipse(xPos, yPos, radius, radius);
    }
  }

  void randomizePos() {
    updatePos(random(b.getStartX(), b.getEndX()), random(b.getStartY(), b.getEndY()));
  }

  void updatePos(float newXpos, float newYpos) {
    xPos = newXpos;
    yPos = newYpos;

    if (xPos + (radius / 2.0) >= b.getEndX()) {
      xPos = b.getEndX() - (radius / 2.0) - b.getThickness();
    }
    else if(xPos - (radius / 2.0) <= b.getStartX()) {
      xPos = b.getStartX() + (radius / 2.0) + b.getThickness();
    }

    if(yPos + (radius / 2.0) >= b.getEndY()) {
      yPos = b.getEndY() - (radius / 2.0) - b.getThickness();
    }
    else if(yPos - (radius / 2.0) <= b.getStartY()) {
      yPos = b.getStartY() + (radius / 2.0) + b.getThickness();
    }
  }

  float getSize() {
    return radius;
  }

  boolean isVisible() {
    return visibilityStatus;
  }

  void setVisibility(boolean status) {
    visibilityStatus = status;
  }

  void setLastTimePickedUp(float t) {
    lastTimePickedUp = t;
  }

  float getLengthOfEffect() {
    return lengthOfEffect;
  }

  float getRespawnInterval() {
    return respawnInterval;
  }

  float getLastTimePickedUp() {
    return lastTimePickedUp;
  }
}
