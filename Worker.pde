public class Worker extends Alien {
  final float worker_size = 7; 
  final float worker_speed = 0.8; 
  final color workerColor = color(0,0,0);
  
  final float fighterRange = 50;

  //initialization model for a neural network to be used by DeepQNetwork
  final int [] _layers = new int[] {InputLength, 50, 25, 10, NumActions};
  final String [] actions = new String [] {"up", "down", "left", "right", "nothing"};
  
  
  public Worker(float _x, float _y){
    type = "Worker";
    diameter = worker_size;
    pos = new PVector (_x, _y);
    speed = worker_speed;
    cor = workerColor;
    controls = new String[] {"Evolve Fighter", "Evolve Drone"};
    this.registerObserver(tutorial);
  }
  
  void update(){
    super.update();
      avoidFighter();
    
  }
  
  void executeFunction(int functionId){
    super.executeFunction(functionId);
    switch(controls[functionId]){
      case ("Evolve Fighter"):
        setEvent("EVENT_EVOLVE_W_INTO_F");
        evolve("Fighter", type);
      break;
      case ("Evolve Drone"):
        evolve("Drone", type);
      break;
      
    }
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