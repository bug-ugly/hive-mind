public class PupalStage extends Alien {
  int incubationCounter;
  String previousState; 
  String nextState; 
  
  public PupalStage(String _previousState, String _nextState) {
    type = "Pupa";
  }
}