public class Pupil extends Alien {
  int incubationCounter;
  String previousState; 
  String nextState; 
  
  public Pupil(String _previousState, String _nextState) {
    type = "Pupil";
  }
}