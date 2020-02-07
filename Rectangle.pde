class MoRect {
  
  // Center of the rectangle
  public KeyFrameTimeline x, y;
  
  // Width and height of the rectangle
  public KeyFrameTimeline w, h;
  
  // Rotation in radians
  public KeyFrameTimeline rotation;
  
  // Shape properties
  public KeyFrameTimeline fillR, fillG, fillB;
  public KeyFrameTimeline strokeR, strokeG, strokeB;
  public KeyFrameTimeline strokeThickness;
  
  // Keyframe animation
  public Boolean isPlaying;
  public Boolean isLooping;
  private int t;
  
  public MoRect(float x, float y, float w, float h) {
    this.x = new KeyFrameTimeline(x);
    this.y = new KeyFrameTimeline(y);
    this.w = new KeyFrameTimeline(w);
    this.h = new KeyFrameTimeline(h);
    this.rotation = new KeyFrameTimeline(0);

    this.fillR = new KeyFrameTimeline(255);
    this.fillG = new KeyFrameTimeline(255);
    this.fillB = new KeyFrameTimeline(255);
    this.strokeR = new KeyFrameTimeline(0);
    this.strokeG = new KeyFrameTimeline(0);
    this.strokeB = new KeyFrameTimeline(0);

    this.strokeThickness = new KeyFrameTimeline(1);
    
    this.isPlaying = false;
    this.t = 0;
  }
  
  public void draw() {
    rectMode(CENTER);
    pushMatrix();
    translate(this.x.get(this.t), this.y.get(this.t));
    rotate(this.rotation.get(this.t));
    fill(this.fillR.get(this.t), this.fillG.get(this.t), this.fillB.get(this.t));
    stroke(this.strokeR.get(this.t), this.strokeG.get(this.t), this.strokeB.get(this.t));
    strokeWeight(this.strokeThickness.get(this.t));
    rect(0, 0, this.w.get(this.t), this.h.get(this.t));
    popMatrix();

    if (this.isPlaying) {
      this.t++;
    }
  }
}
