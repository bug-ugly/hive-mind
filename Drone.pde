public class Drone extends Alien {

  float droneSize = 10;
  color droneColor = color(255, 0, 0);
  int droneSpeed = 10;
  int attackRange = 4;
  int lifetime = 500; 
  int lifetimeCounter= 0; 
  
  public Drone (float _x, float _y) {
    speed = 5;
    type = "Drone";
    pos = new PVector(_x, _y);
    diameter = droneSize;
    cor = droneColor;
    collidable = true;
    selectable = true;
  }
  
  void update(){
    super.update();
    trackWorkers();
    killWorkers();
    lifetimeCounter++; 
    if ( lifetimeCounter > lifetime){
      die();
    }
  }
  

  
  void trackWorkers(){
      float targetX = 99999; 
      float targetY = 99999;
    for ( int i = 0; i< aliens.size(); i++){
      Alien a = aliens.get(i); 
      if ( a instanceof Worker){
        if ( targetX == 99999){
          targetX = a.pos.x; 
          targetY = a.pos.y;
        }
         if ( dist(a.pos.x, a.pos.y, pos.x, pos.y) < dist(targetX, targetY, pos.x, pos.y)){
          targetX = a.pos.x; 
          targetY = a.pos.y;
         }
      }
    }
    
    if ( targetX != 99999){
    
     direction= atan2( targetY - pos.y, targetX - pos.x);
          float newX = cos(direction) * speed + pos.x;
          float newY = sin(direction) * speed + pos.y;
          pos.set(newX, newY, 0.);
    }
  }
  
  void killWorkers(){
    for ( int i = 0; i< aliens.size(); i++){
      Alien a = aliens.get(i); 
      if ( a instanceof Worker && dist(a.pos.x, a.pos.y, pos.x,pos.y)< attackRange + diameter/2){
         a.die();
      }
    }
  }
}
