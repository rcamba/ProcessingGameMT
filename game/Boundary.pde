class Boundary {
    float startX,  endX,  startY,  endY;
    color outlineColor = color(200, 200, 0);
    int outlineThickness = 3;

    Boundary(float startX, float endX, float startY, float endY){
      this.startX = startX;
      this.endX = endX;
      this.startY = startY;
      this.endY = endY;
    }

    Boundary(float startX, float endX, float startY, float endY, color outlineColor){
      this.startX = startX;
      this.endX = endX;
      this.startY = startY;
      this.endY = endY;
      this.outlineColor = outlineColor;
    }

    void display() {
        strokeWeight(outlineThickness);
        stroke(outlineColor);

        line(startX, startY, endX, startY); // top
        line(startX, startY, startX, endY); // left

        line(endX, startY, endX, endY); // right
        line(startX, endY, endX, endY); // bottom

        strokeWeight(1); //reset stroke thickness
    }

    int getThickness() {
        return outlineThickness;
    }

    float getStartX() {
        return startX;
    }

    float getEndX() {
        return endX;
    }

    float getStartY() {
        return startY;
    }

    float getEndY() {
        return endY;
    }

    float getWidth() {
      return endX - startX;
    }

    float getHeight() {
      return endY - startY;
    }

    void setOutlineColor(color c) {

      outlineColor = c;
    }
}