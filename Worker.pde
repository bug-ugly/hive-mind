public class Worker extends Alien {
  NeuralNetwork net; 
  
  final float worker_size = 7; 
  final float worker_speed = 0.8; 
  final color workerColor = color(0, 0, 0);

  final float workerRange = 100; //will try to stay close to the other workers within that range
  final float workerMinRange = 20;
  final float fighterRange = 50; //keep this distance from a fighter

  //initialization model for a neural network to be used by DeepQNetwork
  float []directionsPI;
  float [] directionalValues;
  

  public Worker(float _x, float _y) {
   
    
    directionsPI = new float [] {0,QUARTER_PI, PI/2, PI/2 + QUARTER_PI, PI, PI + QUARTER_PI, PI + PI/2, PI*2 - QUARTER_PI, PI};
    directionalValues = new float [directionsPI.length];
    for ( int i = 0; i < directionalValues.length; i++){
      directionalValues [i] = 0;
    }
   
    _layers = new int[] {5, 30, 16, directionalValues.length};
    net = new NeuralNetwork ( _layers);
    type = "Worker";
    diameter = worker_size;
    pos = new PVector (_x, _y);
    speed = worker_speed;
    cor = workerColor;
    hearing_distance = 100;
    controls = new String[] {"Evolve Fighter"};
    out = minim.getLineOut();
    // create a sine wave Oscil, set to 440 Hz, at 0.5 amplitude
    wave = new Oscil( 200, 0.5f, Waves.SINE );
    fftLinA = new FFT (out.bufferSize(), out.sampleRate());
    fftLinA.linAverages(30);
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
     
     
     directionalValues = new float [directionsPI.length];
     for ( int i = 0; i< aliens.size(); i++){
       Alien a = aliens.get(i);
       if ( a != this && a.soundPlaying && dist(a.pos.x, a.pos.y, pos.x, pos.y) < hearing_distance){
         for ( int j = 0; j<directionalValues.length; j++){
             directionalValues[j] =  directionalValues[j] + net.FeedForward (readSound(a))[j];
         }
       }
     }
     act(directionalValues);
     
     intervalCounter ++; 
    if ( intervalCounter > soundInterval){
     triggerNoise = true;
     intervalCounter = 0; 
    }
    
    
  }
  
  void avaluateFitness(){
    for(Alien a: aliens){
      if ( a instanceof Worker && a != this){
        if ( dist(a.pos.x, a.pos.y, pos.x, pos.y) < workerRange ){
          fitness ++;
        }
      }
    }

  }

  void act ( float []values ) {
   float maxVal = 0;
   int top = values.length-1;
   for ( int i = 0; i < values.length; i++){
     if ( values[i] > maxVal){
       maxVal = values[i]; 
       top = i;
     }
   }
   if ( top != values.length-1){
    
          direction = directionsPI[top];
          float newX = cos(direction) * speed + pos.x;
          float newY = sin(direction) * speed + pos.y;
          pos.set(newX, newY, 0.);
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