//class that manages all of the aliens
class AlienManager {
  public AlienManager() {
    aliens.add(new Queen(width/2, height/2, 10));
    aliens.add(new Fighter(width/2, height/2));
    for (int i = 0; i< 1000; i++){
    aliens.add(new Worker(width/2, height/2));
    }
  }

//update all aliens
  void updateAliens() {
    for ( Alien a : aliens) {
      clearDead();
      a.update(); 
      a.render();
    }
  }
  
  
  //remove the dead aliens
  void clearDead(){
    for ( Alien a : aliens) {
      if (a.dead){
        aliens.remove(a);
      }
    }
  }
  
  
}