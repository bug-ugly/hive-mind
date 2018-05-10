//class that manages all of the aliens
class AlienManager {
  final float elitesPercent = 20;
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
  void clearDead() {
    for (int i = aliens.size()-1; i>= 0; i--) {
      Alien a = aliens.get(i);
      if (a.dead) {
        aliens.remove(i);
        a.removeObserver(tutorial); //important to remove the observers in order to preserve framerate
        a = null;
      }
    }
  }

  ArrayList <Alien> returnFit() {
    ArrayList <Alien> workers = new ArrayList <Alien>();
    ArrayList <Alien> elites = new ArrayList <Alien>();
    elites = new ArrayList();
    workers = new ArrayList();
    for ( int i = 0; i < aliens.size(); i++) {
      Alien m = aliens.get(i);
      if ( m instanceof Worker) {
        workers.add(m);
      }
    }
      
    
    Collections.sort(workers, new Sortbyfitness());
    for (int i = workers.size()-1; i >= workers.size()-1 - int(workers.size()* elitesPercent/100); i --) {
      elites.add(workers.get(i));
    }
   
    workers = null;
    return elites;
  }

  void quickEvolveWorkers() {
    int j = 0;

    for ( int i = 0; i< aliens.size(); i++) {
      if ( aliens.get(i) instanceof Worker) {
        aliens.get(i).dead = true;
      }
    }
     ArrayList <Alien> elites = new ArrayList <Alien>();
     elites = returnFit();
    for ( int i = 0; i< 20; i++) {
      aliens.add(new Worker(width/2, height/2, elites.get(j).net));
       //slowing down here... wut
      j++;
      if (j >= elites.size()) {
        j = 0;
      }
    }
  
  }
  
}



class Sortbyfitness implements Comparator<Alien>
{
  // Used for sorting in ascending order of
  // roll number

  public int compare(Alien a, Alien b)
  {
    return a.fitness - b.fitness;
  }
}
