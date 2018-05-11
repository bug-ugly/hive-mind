//part of observer pattern that was implemented in order to handle sounds
interface Subject {
  public void registerObserver( Observer observer); 
  public void removeObserver (Observer observer); 
  public void notifyObservers();
}
