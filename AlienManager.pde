//class that manages all of the aliens
class AlienManager {
  public AlienManager() {
    aliens.add(new Queen(width/2, height/2, 10));
    //aliens.add(new Fighter(width/2, height/2));
    //for (int i = 0; i< 1000; i++){
    //aliens.add(new Worker(width/2, height/2));
    //}
  }

//update all aliens
  void updateAliens() {
    for ( int i = 0; i< aliens.size(); i++) {
      Alien a = aliens.get(i);
      a.update(); 
      a.render();
      clearDead();
    }
  }
  
  //remove the dead aliens
  void clearDead(){
    for (int i = 0; i< aliens.size(); i++) {
      Alien a = aliens.get(i);
      if (a.dead){
        aliens.remove(a);
      }
    }
  }
  
}