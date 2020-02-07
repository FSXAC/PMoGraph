class MoRect {
  
  // Center of the rectangle
  private float x, y;
  
  // Width and height of the rectangle
  private float w, h;
  private float scaleX, scaleY;
  
  // Rotation in radians
  private float rotation;
  
  // Shape properties
  private color fillColor;
  private color strokeColor;
  private float strokeThickness;
  
  // Keyframe animation
  public Boolean isPlaying;
  public KeyFrameTimeline timeline;
  
  public MoRect(float x, float y) {
    this.x = x;
    this.y = y;
    this.w = 50;
    this.h = 50;
    this.scaleX = 1;
    this.scaleY = 1;
    this.rotation = 0;
    this.fillColor = color(255, 255, 255);
    this.strokeColor = color(0);
    this.strokeThickness = 1;
    
    this.isPlaying = false;
    this.timeline = new KeyFrameTimeline();
  }
  
  public void draw(PGraphics surf) {
    surf.rectMode(CENTER);
    surf.pushMatrix();
    surf.translate(this.x, this.y);
    surf.rotate(this.rotation);
    surf.fill(this.fillColor);
    surf.stroke(this.strokeColor);
    surf.strokeWeight(this.strokeThickness);
    surf.rect(0, 0, this.w * this.scaleX, this.h * this.scaleY);
    surf.popMatrix();
  }
  
  public void draw() {
    rectMode(CENTER);
    pushMatrix();
    translate(this.x, this.y);
    rotate(this.rotation);
    fill(this.fillColor);
    stroke(this.strokeColor);
    strokeWeight(this.strokeThickness);
    rect(0, 0, this.w * this.scaleX, this.h * this.scaleY);
    popMatrix();
  }
}
