public class PupalStage extends Alien {
  int incubationCounter;
  String previousState; 
  String nextState; 
  
  final int pupaSize = 12; 
  final color pupaColor = color ( 255,0,255);
  final int incubationTime = 200; 
  
  
  public PupalStage(String _previousState, String _nextState, float[] gene, float _x, float _y) {
    type = "Pupa";
    incubationCounter = incubationTime;
    genome = gene;
    previousState = _previousState; 
    nextState = _nextState;
    pos = new PVector(_x, _y);
    cor = pupaColor; 
    diameter = pupaSize;
    
  }
  
  public void update(){
    super.update();
    incubationCounter--; 
    println (incubationCounter);
    if (incubationCounter <= 0){
      switch(nextState){
        case "Drone":
          aliens.add(new Drone(pos.x, pos.y));
          aliens.remove(this);
        break; 
        case "Fighter":
          aliens.add(new Fighter(pos.x,pos.y));
          aliens.remove(this);
        break; 
      }
    }
  }
  
}