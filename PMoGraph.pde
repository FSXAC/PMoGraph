import java.util.*;

enum TransitionType {
  NONE,
  LINEAR,
  QUADRATIC,
  EASEOUT,
  EASEIN
}

public class KeyFrameObject implements Comparable<KeyFrameObject> {
  float value;
  int frame;
  TransitionType inTrans, outTrans;
  
  public KeyFrameObject(float value, int frame, TransitionType transitionType) {
    this.value = value;
    this.frame = frame;
    this.inTrans = transitionType;
    this.outTrans = TransitionType.NONE;
  }
  
  // For sorting
  @Override
  public int compareTo(KeyFrameObject other) {
    return this.frame - other.frame;
  }
  
  // For string rep
  @Override
  public String toString() {
    return "{v=" + this.value + ",t=" + this.frame + ",trans=" + this.inTrans + "/" + this.outTrans + "}";
  }
}

class KeyFrameTimeline {
  ArrayList<KeyFrameObject> keyframes = new ArrayList<KeyFrameObject>();
  FloatList outputValues = new FloatList();
  Boolean outputIsValid = false;
  
  public KeyFrameTimeline(float initialValue) {
    
    // Add inital keyframe
    keyframes.add(new KeyFrameObject(initialValue, 0, TransitionType.NONE));
  }
  
  public void addKeyFrame(float value, int frame, TransitionType transition) {
    int lastIndex = keyframes.size() - 1; 
    keyframes.add(new KeyFrameObject(value, frame, transition));
    Collections.sort(this.keyframes);
    keyframes.get(lastIndex).outTrans = transition;
    
    // Mark timeline as dirty
    this.outputIsValid = false;
  }
  
  public void buildTimeline() {
    
    println("Building keyframe timeline");
    println(this.keyframes);
    
    // Build the output list
    this.outputValues.clear();
    
    // For each segment of the keyframes
    for (int i = 0; i < this.keyframes.size() - 1; i++) {
      int startFrame = this.keyframes.get(i).frame;
      int endFrame = this.keyframes.get(i + 1).frame;
      int totalFrames = endFrame - startFrame;
      
      float startVal = this.keyframes.get(i).value;
      float endVal = this.keyframes.get(i + 1).value;
      
      TransitionType startTrans = this.keyframes.get(i).outTrans;
      TransitionType endTrans = this.keyframes.get(i + 1).inTrans;
      if (startTrans != endTrans) {
        println("ERROR: Keyframe inTrans and outTrans mismatched");
        startTrans = TransitionType.LINEAR;
      }
      
      for (int dt = 0; dt < totalFrames; dt++) { //<>//
        this.outputValues.append(0.0);
        int currentIndex = this.outputValues.size() - 1;
        float frac = (float) dt / totalFrames;
        
        if (startTrans == TransitionType.LINEAR) {
          this.outputValues.set(currentIndex, frac * (endVal - startVal) + startVal);
        }
      }
    }
    
    // Add final value
    this.outputValues.append(this.keyframes.get(this.keyframes.size() - 1).value);
    
    // Mark timeline as updated
    this.outputIsValid = true;
    println(this.outputValues.size());
    println(this.outputValues.get(this.outputValues.size() - 1));
  }
  
  public float getValue(int t) {
    if (!this.outputIsValid) {
      this.buildTimeline();
    }
    
    if (t < this.outputValues.size() - 1) {
      return this.outputValues.get(t);
    }
    
    return 0;
  }
}

int t = 0;
int T = 300;
KeyFrameTimeline testTimeline = new KeyFrameTimeline(0);

void setup() {
  size(800, 600);
  testTimeline.addKeyFrame(100, 75, TransitionType.LINEAR);
  testTimeline.addKeyFrame(100, 100, TransitionType.LINEAR);
  testTimeline.addKeyFrame(300, 150, TransitionType.LINEAR);
  testTimeline.addKeyFrame(10, 200, TransitionType.LINEAR);
  testTimeline.addKeyFrame(150, 250, TransitionType.LINEAR);
  testTimeline.addKeyFrame(0, 300, TransitionType.LINEAR);
  
  //for (int i = 0; i < 300; i++) {
  //  print(testTimeline.getValue(i));
  //  print(", ");
  //}
  background(255);
}


void draw() {
  
  noStroke();
  fill(255, 2);
  rect(0, 0, width, height);
  
  strokeWeight(3);
  stroke(0);
  float v = testTimeline.getValue(t);
  line(width * t / T, height, width * t / T, height - v);
  
  if (t < T) t++;
  else t = 0;
}
