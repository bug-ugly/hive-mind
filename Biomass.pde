class Biomass extends Alien{ //biomass is dropped on alien's death, biomass are nutrients or corpses
    float biomassSize = 2; 
  public Biomass(float _x, float _y){
    pos = new PVector(_x, _y);
    diameter = biomassSize; 
  }
  
  void render () {
    fill ( 255,0,0); 
    ellipse (pos.x, pos.y, diameter, diameter);
  }
  
}