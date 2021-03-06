class Biomass extends Alien { //biomass is dropped on alien's death, biomass are nutrients or corpses
  float biomassSize = 2; 
  
  int removeTimer; 
  int removeTime = 30;
  
  public Biomass(float _x, float _y) {
    pos = new PVector(_x, _y);
    diameter = biomassSize;
    collidable = false; 
    selectable = false;
    removeTimer = 0; 
    dead = false;
  }

  void render () {
    fill ( 210, 0, 255); 
    ellipse (pos.x, pos.y, diameter, diameter);
  }
  
  void update(){
    removeTimer ++ ; 
    if ( removeTimer >= removeTime){
      dead = true;
    }
    
  }
}
