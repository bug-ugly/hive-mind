public class Alien implements Subject {
  AudioOutput out;
  Oscil wave;
  private ArrayList <Observer> observers = new ArrayList <Observer>();
  private String event; 
  boolean collidable;
  boolean selectable;
  
  DeepQNetwork RLNet; //neural net
  NeuralNetwork net; 
  int fitness;
  
  //stats variables, perhaps to be replaces by genome
  float speed; //speed of an agent
  float velocity;  //velocity at which the agent is moving
  float direction;  // movement direction of the agent
  float diameter;  // size
  color cor;  //color
  PVector pos; //current position
  String type; //type of an agent: Queen, Worker, Fighter, etc.
  int biomassValue; //how much biomass is going to be dropped on agent death

  int hearing_distance; //how wide is the hearing range of an individual

  boolean dead; //checking the dead aliens and preparing them for cleanup

  float reward;   //current reward
  ArrayList <float []> lastOutputs; // an array to store a number of last world states that are to be rated
  float ratedActionsNum = 50; //number of the last actions that are going to be rated by the player, there needs to be many actions (10) for the neural network precision
  final int InputLength = 513; //the size of the input that the agent receives. the sound spectrum is the total of 513 numbers
  int NumActions; //total number of actions that the agent can perform: move right, left,up, etc.
  String [] actions;
  //initialization model for a neural network to be used by DeepQNetwork
  int [] _layers;

  String []controls; //options which will appear as buttons on the top left when the agent is selected, view the child classes for reference

  boolean triggerNoise = false;
  boolean soundPlaying = false;
  int soundCounter; 
  int soundTimer = 1;
  
  int soundInterval;
  int intervalCounter;
  
  //function to produce sound, currently it just draws an indicator whnever alien is to produce a sound
  void produceSound() {
   
    wave.unpatch( out );
   // patch the Oscil to the output
    wave.patch( out );
  }
  void stopSound() {
    wave.unpatch(out);
  }


  //executes the function when one of the control buttons is pressed
  void executeFunction(int functionId) {
  }

  void compareFitnessAndAdd(NeuralNetwork _n, int f){};

//analyse the sounds produced by other aliens
  float [] readSound (){
    float [] directionalMatrix = new float [8]; 
    for ( int i = 0; i< directionalMatrix.length; i++){
      directionalMatrix[i] = 1;
    }
    for (int i = 0; i < aliens.size(); i++){
      Alien a  = aliens.get(i);
      if ( a != this && a.soundPlaying &&dist( a.pos.x, a.pos.y, pos.x, pos.y) < hearing_distance ){
        float d = atan2(a.pos.x - pos.y, a.pos.y - pos.x);
            for (int j = 0; j<directionalMatrix.length; j++){
              if ( d > TWO_PI / directionalMatrix.length * j && d < TWO_PI/directionalMatrix.length * j + TWO_PI/directionalMatrix.length){
                directionalMatrix[j] = a.wave.frequency.getLastValue();
            }
          }
      }
    }
    return directionalMatrix;
  }

  //each alien can evolve into another type going through pupal phase
  void evolve ( String nextState, String currentState) {
    aliens.add( new PupalStage(currentState, nextState, pos.x, pos.y));
    aliens.remove(this);
    this.removeObserver(tutorial);
  }

  //draws an alien according to specifications
  void render() {
    fill (cor); 
    noStroke();
    ellipse (pos.x, pos.y, diameter, diameter);
     if (soundPlaying){
        noFill(); 
        stroke ( 0);
        ellipse (pos.x, pos.y, diameter + 5, diameter + 5);
     }
  }

  void update() {
    checkWallCollision();
    collisionMove();
    checkObstacleCollision();
    if (triggerNoise){
      produceSound(); 
      triggerNoise = false;
      soundPlaying = true;
      soundCounter = 0; 
    }
    soundCounter++;
    if ( soundCounter > soundTimer && soundPlaying) {
      stopSound();
      soundPlaying = false;
    }
  }

  void performAction(int t) {
    switch (actions[t]) {
    case "up": 
      moveUp();
      break; 
    case "down": 
      moveDown();
      break; 
    case "left": 
      moveLeft();
      break; 
    case "right": 
      moveRight();
      break; 
    case "nothing": 
      //do nothing
      break;
     case "produceSound": 
      triggerNoise = true;
      break;
    }
  }

  //shows the weights of the neural net in a form of a grid
  void visualiseNeuralNet() {
    int gridSize = 2;

    for (int i = 0; i < _layers.length-1; i++) {
      for ( int j = 0; j < RLNet.DeepQ.layers[i].weights.length; j++) {
        for ( int k = 0; k < RLNet.DeepQ.layers[i].weights[j].length; k++) {
          noStroke(); 
          fill(0, 0, 0, map(RLNet.DeepQ.layers[i].weights[j][k], -1, 1, 0, 255));

          rect(100 + 110 * i + gridSize*j, 100 + gridSize+ gridSize*k, gridSize, gridSize);
        }
      }
    }
  }


  void produceLarva() {
   
  }

  //makes sure that the alien doesnt leave the screen borders
  void checkWallCollision() {
    if ( pos.x < 0) {
      pos.x = 0;
    }
    if ( pos.x > width) {
      pos.x = width;
    }
    if ( pos.y > height ) {
      pos.y = height;
    }
    if ( pos.y< 0) {
      pos.y = 0;
    }
  }

  //move away if there is collision with another alien
  void collisionMove() {
    //get pushed away if there is collision
    if ( checkCollision() !=null) {
      float invertion = PI;
      if (checkCollision().pos.y == pos.y && checkCollision().pos.x == pos.x) {
        invertion = PI + random(0, 2*PI); //random vector direction in case if the agents are positioned at the same coordinate
      }
      //calculate a vector pointing away from the target
      float angle = atan2(checkCollision().pos.y - pos.y, checkCollision().pos.x - pos.x);
      //update positions
      direction = angle + invertion;
      float newX = cos(direction) * speed + pos.x;
      float newY = sin(direction) * speed + pos.y;
      pos.set(newX, newY, 0.);
    }
  }

  float [] getSoundSpectrum(AudioInput in) {
    fftLin.forward(in.mix);
    float [] spectrum = new float [fftLin.specSize()];
    for ( int i = 0; i< fftLin.specSize(); i++) {
      spectrum[i] = fftLin.getBand(i);
    }
    return spectrum;
  }
  

  float [] getSoundSpectrum(AudioOutput out) {
    fftLin.forward(out.mix);
    float [] spectrum = new float [fftLin.specSize()];
    for ( int i = 0; i< fftLin.specSize(); i++) {
      spectrum[i] = fftLin.getBand(i);
    }
    return spectrum;
  }


  //returns the alien which is colliding with the current alien
  Alien checkCollision() {
    for (Alien a : aliens) {
      if ( a != this && a.collidable) {
        if (dist(pos.x, pos.y, a.pos.x, a.pos.y) < diameter/2 + a.diameter/2) {
          return a;
        }
      }
    }
    return null;
  }

  void backP( float score) {
    reward = reward + score;
    println("REWARD: " + reward);
    //RLNet.ObserveReward(reward, getSoundSpectrum() , GetActionMask());
    rewardPrevious(reward);
    reward = 0;
  }

  void backP( String dir) {
    rewardPrevious(dir);
  }

  //needed in case if the grid system will be implemented which would limit the actions available at certain times
  int[] GetActionMask() {
    int retVal[] = new int[NumActions]; 
    for (int i = 0; i< NumActions; i++) {
      retVal[i] = 1;
    }
    return retVal ;
  }


  //rewards the last outputs
  void rewardPrevious(float rew) {
    for ( int i = 0; i < lastOutputs.size(); i++) {
      RLNet.ObserveReward(rew, lastOutputs.get(i), GetActionMask());
    }
  }

  //reward in case if the correct action is given by the player
  void rewardPrevious(String dir) {
    int act = 4; 
    if ( dir.equals ("Up")) {
      act = 0;
      setEvent("EVENT_SWIPE_UP");
    }
    if ( dir.equals ("Down")) {
      act = 1;
      setEvent("EVENT_SWIPE_DOWN");
    }
    if ( dir.equals ("Left")) {
      act = 2;
      setEvent("EVENT_SWIPE_LEFT");
    }
    if ( dir.equals ("Right")) {
      act = 3;
      setEvent("EVENT_SWIPE_RIGHT");
    }
    for ( int i = 0; i < lastOutputs.size(); i++) {
      RLNet.correctAction(act, lastOutputs.get(i), GetActionMask());
    }
  }


  //actions to be selected by the output of the neural network
  void moveUp() {
    direction = PI + PI/2;
    float newX = cos(direction) * speed + pos.x;
    float newY = sin(direction) * speed + pos.y;
    pos.set(newX, newY, 0.);
  }

  void moveLeft() {
    direction = PI;
    float newX = cos( direction) * speed + pos.x;
    float newY = sin( direction) * speed + pos.y;
    pos.set(newX, newY, 0.);
  }

  void moveRight() {
    direction = 0;
    float newX = cos(direction) * speed + pos.x;
    float newY = sin(direction) * speed + pos.y;
    pos.set(newX, newY, 0.);
  }

  void moveDown() {
    direction = PI/2; 

    float newX = cos(direction) * speed + pos.x;
    float newY = sin(direction) * speed + pos.y;
    pos.set(newX, newY, 0.);
  }

  //events for the observers
  public void setEvent(String event) {
    this.event = event;
    notifyObservers();
  }

  void checkObstacleCollision() {
    //reverse movement when colliding with obstacles
    for ( int i = 0; i < obstacles.size(); i++) {
      Obstacle o = obstacles.get(i); 
      if ( o.checkObstacleCollision(this)) {
        float invertion = PI;
        direction = direction + invertion;
        float newX = cos(direction) * speed + pos.x;
        float newY = sin(direction) * speed + pos.y;
        pos.set(newX, newY, 0.);
      }
    }
  }
  
  void die(){
    //death which happens as an ingame event rather than simple object removal
    if ( this instanceof Fighter || this instanceof Worker || this instanceof Drone){
      for ( int i = 0; i < 5; i++){
      aliens.add(new Biomass(pos.x + random(-3,3), pos.y + random(-3,3)));
      }
    }
    dead = true; 

  }


  @Override 
    public void registerObserver(Observer observer) {
    observers.add(observer);
  }

  @Override 
    public void removeObserver(Observer observer) {
    observers.remove(observer);
  }

  @Override 
    public void notifyObservers () {
    for (Observer ob : observers) {
      ob.update(this.event);
    }
  }
}
