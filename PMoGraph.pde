import java.util.*; //<>// //<>// //<>// //<>//

int t = 0;
int T = 300;
KeyFrameTimeline testTimeline = new KeyFrameTimeline();
KeyFrameTimeline tl2 = new KeyFrameTimeline();
MoRect r1;

void setup() {
  size(800, 600);
  
  testTimeline.addKeyFrame(10, 0);
  testTimeline.addKeyFrame(10, 50);
  testTimeline.addKeyFrame(400, 100);
  testTimeline.addKeyFrame(400, 130);
  testTimeline.addKeyFrame(100, 170);
  testTimeline.addKeyFrame(100, 220);
  testTimeline.addKeyFrame(200, 250);
  testTimeline.addKeyFrame(200, 270);
  testTimeline.addKeyFrame(10, 300);
  testTimeline.setAllTransitions(TransitionType.EASE);
  
  tl2.addKeyFrame(10, 0);
  tl2.addKeyFrame(10, 50);
  tl2.addKeyFrame(400, 100);
  tl2.addKeyFrame(400, 130);
  tl2.addKeyFrame(100, 170);
  tl2.addKeyFrame(100, 220);
  tl2.addKeyFrame(200, 250);
  tl2.addKeyFrame(200, 270);
  tl2.addKeyFrame(10, 300);
  tl2.setAllTransitions(TransitionType.LINEAR);
  
  background(255);
  
  r1 = new MoRect(width/2, height/2, 50, 50);
  r1.x.addKeyFrame(200, 2);
  r1.x.addKeyFrame(width/2, 4);
  r1.x.setAllTransitions(TransitionType.EASE);
  print(r1.x.keyframes);
  r1.x.buildTimeline();
  print(r1.x.outputValues);
  r1.isPlaying = true;
}

void draw() {
  
  background(255);
  
  strokeWeight(3);
  stroke(0);
  float v = testTimeline.get(t);
  float v2 = tl2.get(t);
  
  line(width * t / T, height, width * t / T, height - v / 5);
  line(width * t / T, height - 100, width * t / T, height - v2 / 5 - 100);
  
  fill(0);
  ellipse(map(v, 10, 400, 100, width-100), height/2, 20, 20);
  ellipse(map(v2, 10, 400, 100, width-100), height/2-100, 20, 20);
  
  r1.draw();
  
  if (t < T) t++;
  else t = 0;
}
