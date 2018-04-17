public class Worker extends Alien {
  final float worker_size = 5; 
  final float worker_speed = 0.8; 
  final color workerColor = color(0,0,0);
  
  final float fighterRange = 50;
  
  public Worker(int _x, int _y){
    type = "Worker";
    diameter = worker_size;
    pos = new PVector (_x, _y);
    speed = worker_speed;
    cor = workerColor;
  }
  
  void update(){
    super.update();
      avoidFighter();
    
  }
  
  
  void avoidFighter(){
    for (Alien a : aliens){
      if (a instanceof Fighter){
        if ( dist (a.pos.x, a.pos.y, pos.x, pos.y) <= fighterRange &&  dist (a.pos.x, a.pos.y, pos.x, pos.y) > a.diameter/2 + diameter/2){
         float invertion = PI;
         //calculate an angle of a vector pointing towads the target
         float angle = atan2(a.pos.y - pos.y, a.pos.x - pos.x);
         //update positions adding PI to the angle inverting it
         float newX = cos(angle + invertion) * speed + pos.x;
         float newY = sin(angle + invertion) * speed + pos.y;
         pos.set(newX, newY, 0.);
        }
      }
    }
  }
}