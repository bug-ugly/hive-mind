public class Worker extends Alien {

  final float worker_size = 7; 
  final float worker_speed = 3; 
  final color workerColor = color(0, 0, 0);

  final float workerRange = 100; //will try to stay close to the other workers within that range
  final float workerMinRange = 20;
  final float fighterRange = 50; //keep this distance from a fighter

  //initialization model for a neural network to be used by DeepQNetwork
  float []directionsPI;
  float mutation_chance = 0.5;

  int replayMemoryCapacity = 1024;
  float discount = .99f;
  double epsilon = 1d;
  int batchSize = 8;
  int updateFreq = 20;
  int replayStartSize = 8;
  
  int scoreFitness;  //temporary storage for real-time fitness evaluation
  
  public Worker(float _x, float _y, NeuralNetwork _net) {
    NeuralNetwork net = _net;
     float ran = random(1);
        if ( ran > mutation_chance){
          net.Mutate();
        }
        
    directionsPI = new float [] {0,QUARTER_PI, PI/2, PI/2 + QUARTER_PI, PI, PI + QUARTER_PI, PI + PI/2, PI*2 - QUARTER_PI, 1, 2};
    NumActions = directionsPI.length;
    _layers = new int[] {matrixLength,64, 20, 10};
    println(matrixLength);
    InputLength =  matrixLength;
    RLNet = new DeepQNetwork(_layers, net, replayMemoryCapacity, discount, epsilon, batchSize, updateFreq, replayStartSize, InputLength, NumActions);
    
    type = "Worker";
    diameter = worker_size;
    pos = new PVector (_x, _y);
    speed = worker_speed;
    cor = workerColor;
    
    controls = new String[] {"Evolve Fighter", "Evolve Drone"};  
    out = minim.getLineOut();
    // create a sine wave Oscil, set to 440 Hz, at 0.5 amplitude
    wave = new Oscil( 200, 0.5f, Waves.SINE );
    this.registerObserver(tutorial);
    collidable = true;
    selectable = true;
    soundInterval = 10;
    fitness = 0;
    
    
     
  }

  void update() {
     //stayClose();
     super.update();
     //avoidFighter();
    
     act(RLNet.GetAction(readSound(), GetActionMask(NumActions)));
 
     intervalCounter ++; 
    if ( intervalCounter > soundInterval){
     triggerNoise = true;
     intervalCounter = 0; 
    }
    
    evaluateFitness();
    println(scoreFitness);
    RLNet.ObserveReward(scoreFitness, readSound(), GetActionMask(NumActions)); 
    scoreFitness = 0;
    
    
  }
  
  void evaluateFitness(){
    for(Alien a: aliens){
      if ( a instanceof Worker && a != this){
        if ( dist(a.pos.x, a.pos.y, pos.x, pos.y) < workerRange ){
          fitness = fitness + int(map(dist(a.pos.x,a.pos.y,pos.x,pos.y), workerRange, workerMinRange, 1, 100));
          scoreFitness = scoreFitness + int(map(dist(a.pos.x,a.pos.y,pos.x,pos.y), workerRange, workerMinRange, 1, 100));
        }
      }
      if ( a instanceof Fighter && a!= this){
         if ( dist(a.pos.x, a.pos.y, pos.x, pos.y) < fighterRange ){
           fitness = fitness - int(map(dist(a.pos.x,a.pos.y,pos.x,pos.y), fighterRange, 0, 2, 200));
          
          scoreFitness = scoreFitness - int(map(dist(a.pos.x,a.pos.y,pos.x,pos.y), fighterRange, 0, 2, 200));
        }
      }
    }

  }

  void act ( int value) {

   if ( value != directionsPI.length-1){
          direction = directionsPI[value];
          float newX = cos(direction) * speed + pos.x;
          float newY = sin(direction) * speed + pos.y;
          pos.set(newX, newY, 0.);
          fitness = fitness - 100;
          scoreFitness = scoreFitness - 100;
    }
     if ( value == directionsPI.length-2){
         if ( sensorState == 1){
           sensorState = 2;
         }
          if ( sensorState == 2){
           sensorState = 1;
         }
    }
   }
  
  
  void executeFunction(int functionId) {
    super.executeFunction(functionId);
    switch(controls[functionId]) {
      case ("Evolve Fighter"):
      setEvent("EVENT_EVOLVE_W_INTO_F");
      evolve("Fighter", type);
      break;
      case ("Evolve Drone"):
      evolve("Drone", type);
      break;
    }
  }

  
  void stayAway(){
    float closestX = 0; 
    float closestY = 0; 
    boolean active = false; 
    float minDistance = 9999;
    
    for(Alien a: aliens){
      if ( a instanceof Worker && a != this){
        if ( dist(a.pos.x, a.pos.y, pos.x, pos.y) <= workerMinRange  && dist(a.pos.x, a.pos.y, pos.x,pos.y) < workerRange ){
         float d = dist(a.pos.x, a.pos.y, pos.x, pos.y); 
         if ( d < minDistance) {
           minDistance = d; 
           closestX = a.pos.x; 
           closestY = a.pos.y; 
           active = true; 
         }
        }
      }
    }
    if (active){
           float invertion = PI;
          //calculate an angle of a vector pointing towads the target
          float angle = atan2(closestY - pos.y, closestX - pos.x);
          //update positions adding PI to the angle inverting it
          direction = angle + invertion;
          float newX = cos(direction) * speed + pos.x;
          float newY = sin(direction) * speed + pos.y;
          pos.set(newX, newY, 0.);
    }
  }
  
  void stayClose(){
    float mX = 0; 
    float mY = 0;
    int count = 0;
    boolean active = false;
    float totalArea = 0;
    for(Alien a: aliens){
      if ( a instanceof Worker && a != this){
        if ( dist(a.pos.x, a.pos.y, pos.x, pos.y) < workerRange ){
          mX = mX + a.pos.x; 
          mY = mY + a.pos.y; 
          count ++; 
          active = true;
          totalArea = totalArea + PI*sq(a.diameter/2);
        }
      }
    }
    mX = mX / count; 
    mY = mY/count;
    float totalRadius = sqrt(totalArea/PI);
    
    if ( active == true && dist( pos.x, pos.y, mX, mY) >totalRadius + diameter){
    
    direction = atan2(mY - pos.y, mX - pos.x); 
          float newX = cos(direction) * speed + pos.x;
          float newY = sin(direction) * speed + pos.y;
          pos.set(newX, newY, 0.);
    }
  }
  
  void die(){
    for (int i = 0; i < aliens.size(); i++){
      Alien a = aliens.get(i); 
      if ( a instanceof Queen){
        a.compareFitnessAndAdd(RLNet.DeepQ, fitness);
      }
    }
    super.die();
  }

  void avoidFighter() {
    for (Alien a : aliens) {
      if (a instanceof Fighter) {
        if ( dist (a.pos.x, a.pos.y, pos.x, pos.y) <= fighterRange ) {
          float invertion = PI;
          //calculate an angle of a vector pointing towads the target
          float angle = atan2(a.pos.y - pos.y, a.pos.x - pos.x);
          //update positions adding PI to the angle inverting it
          direction = angle + invertion;
          float newX = cos(direction) * speed + pos.x;
          float newY = sin(direction) * speed + pos.y;
          pos.set(newX, newY, 0.);
        }
      }
    }
  }
}
