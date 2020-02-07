float cubicCurve(float x, float u0, float u1, float u2, float u3) {
  float nx = 1 - x;
  return u0*pow(nx,3) + 3*u1*pow(nx,2)*x + 3*u2*nx*pow(x,2) + u3*pow(x,3);
}

enum TransitionType {
  LINEAR,
  EASE,
  PAUSE,
  BOUNCE,
}

public class KeyFrameObject implements Comparable<KeyFrameObject> {
  float value;
  int frame;
  TransitionType inTrans, outTrans;
  
  public KeyFrameObject(float value, int frame, TransitionType tin, TransitionType tout) {
    this.value = value;
    this.frame = frame;
    this.inTrans = tin;
    this.outTrans = tout;
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
  Boolean loopEnabled = true;
  
  // Ease attach is how fast the "rise time"
  // Default is 1. Lowest is 0.4 before we start to affect the linear part
  // Highest is 2 (with overshoot/bounce)
  // Think of this as inverse of time-constant -- the smaller the value - the longer
  // it takes to settle
  float easeAttack = 1;
  
  public KeyFrameTimeline() {
  }
  
  public KeyFrameTimeline(float initValue) {
    this.addKeyFrame(initValue, 0);
  }
  
  public void addKeyFrame(float value, int frame, TransitionType tin, TransitionType tout) {
    for (KeyFrameObject k : this.keyframes) {
      if (k.frame > frame) {
        break;
      } else if (k.frame == frame) {
        this.keyframes.remove(k);
        break;
      }
    }

    keyframes.add(new KeyFrameObject(value, frame, tin, tout));
    Collections.sort(this.keyframes);
    
    // Mark timeline as dirty
    this.outputIsValid = false;
  }
  
  public void addKeyFrame(float value, int frame) {
    this.addKeyFrame(value, frame, TransitionType.LINEAR, TransitionType.LINEAR);
  }
  
  public void setAllTransitions(TransitionType t) {
    for (int i = 0; i < this.keyframes.size(); i++) {
      this.keyframes.get(i).inTrans = t;
      this.keyframes.get(i).outTrans = t;
    }
  }
  
  public void setAllTransitions(TransitionType t1, TransitionType t2) {
    for (int i = 0; i < this.keyframes.size(); i++) {
      this.keyframes.get(i).inTrans = t1;
      this.keyframes.get(i).outTrans = t2;
    }
  }
  
  public void buildTimeline() {
    
    //println("Building keyframe timeline");
    //println(this.keyframes);
    
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
      
      for (int dt = 0; dt < totalFrames; dt++) {
        this.outputValues.append(0.0);
        int currentIndex = this.outputValues.size() - 1;
        float frac = (float) dt / totalFrames;
        
        
        float multiplier;
        switch (startTrans) {
          
          case LINEAR:
            switch (endTrans) {
              case EASE: multiplier = cubicCurve(frac, 0, this.easeAttack, 1, 1); break;
              case BOUNCE: multiplier = cubicCurve(frac, 0, this.easeAttack, 1.2, 1); break;
              default: multiplier = frac;
            }
            break;
            
          case EASE:
            switch (endTrans) {
              case EASE: multiplier = cubicCurve(frac, 0, 0, 1, 1); break;
              case BOUNCE: multiplier = cubicCurve(frac, 0, 0, 1.4, 1); break;
              default: multiplier = cubicCurve(frac, 0, 0, 1-this.easeAttack, 1);
            }
            break;
            
          case PAUSE:
            switch (endTrans) {
              case PAUSE: multiplier = cubicCurve(frac, 0, 1, 0, 1); break;
              default: multiplier = frac;
            }
            break;
            
          case BOUNCE:
            switch (endTrans) {
              case EASE: multiplier = cubicCurve(frac, 0, -0.4, 1, 1); break;
              case BOUNCE: multiplier = cubicCurve(frac, 0, -0.4, 1.4, 1); break;
              default: multiplier = cubicCurve(frac, 0, -0.2, 0.1, 1); break;
            }
            break;
            
          default:
            multiplier = frac;
        }

        this.outputValues.set(currentIndex, multiplier * (endVal - startVal) + startVal);
      }
    }
    
    // Add final value
    this.outputValues.append(this.keyframes.get(this.keyframes.size() - 1).value);
    
    // Mark timeline as updated
    this.outputIsValid = true;
    //println(this.outputValues.size());
    //println(this.outputValues.get(this.outputValues.size() - 1));
  }
  
  public float get(int t) {

    if (!this.outputIsValid) {
      this.buildTimeline();
    }

    if (this.loopEnabled) {
      t = t % this.outputValues.size();
    }
    
    // If only 1 keyframe then there is no such thing as t
    if (this.outputValues.size() == 1) {
      return this.outputValues.get(0);
    }
    else if (t < this.outputValues.size() - 1) {
      return this.outputValues.get(t);
    }
    
    return 0;
  }
  
  public float get() {
    return this.get(0);
  }
}
