import java.util.*; //<>// //<>// //<>//

MoRect r1;
MoRoundedRect r2;

void setup() {
  size(800, 600);
  background(255);
  smooth(0);
  //frameRate(10);
  
  r1 = new MoRect(width/2, height/2, 50, 50);
  r1.x.addKeyFrame(width/2, 0);
  r1.x.addKeyFrame(200, 20);
  r1.x.addKeyFrame(width/2, 40);
  r1.x.setAllTransitions(TransitionType.EASE);
  r1.y.addKeyFrame(height/2, 0);
  r1.y.addKeyFrame(0, 100);
  r1.y.addKeyFrame(height, 200);
  r1.y.addKeyFrame(height/2, 300);
  r1.y.setAllTransitions(TransitionType.EASE);
  r1.fillR.addKeyFrame(255, 0);
  r1.fillR.addKeyFrame(0, 50);
  r1.fillR.addKeyFrame(255, 100);
  r1.isPlaying = true;

  r2 = new MoRoundedRect(200, 200, 50, 50, 10);
  r2.r.addKeyFrame(0, 0);
  r2.r.addKeyFrame(25, 100);
  r2.r.addKeyFrame(0, 200);
  r2.r.setAllTransitions(TransitionType.EASE);
  r2.isPlaying = true;
}

void draw() {
  
  background(255);
  r1.draw();

  r2.draw();
}
