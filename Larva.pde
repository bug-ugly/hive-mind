public class Larva extends Alien {
  final int larvaDiameter = 5;
  final int larvaSpeed = 1;
  
  public Larva (int _x, int _y ) {
    pos.x = _x; 
    pos.y = _y;
    speed = larvaSpeed;
    diameter = larvaDiameter;
    type = "Larva";
  }
  
  public void render(){
    super.render();
    noFill(); 
    stroke(0);
    ellipse(pos.x, pos.y, diameter, diameter);
    
  }
  
  
    
}