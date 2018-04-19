public class Alien {
  float [] genome; //all stats of an alien, in order to implement genetics
  DeepQNetwork RLNet; //neural net

  //stats variables, perhaps to be replaces by genome
  float speed;
  float velocity; 
  float direction; 
  float diameter; 
  color cor; 
  PVector pos;
  String type;

  int hearing_distance; //how wide is the hearing range of an individual
  
  boolean dead;
  
  float reward;   //current reward
   ArrayList <float []> lastOutputs; // an array to store a number of last world states that are to be rated
  float ratedActionsNum = 50; //number of the last actions that are going to be rated by the player, there needs to be many actions (10) for the neural network precision
  final int InputLength = 513; //the size of the input that the agent receives. the sound spectrum is the total of 513 numbers
  final int NumActions = 5; //total number of actions that the agent can perform: move right, left,up, etc.
  final String [] actions = new String [] {"up", "down", "left", "right", "nothing"};
  //initialization model for a neural network to be used by DeepQNetwork
  final int [] _layers = new int[] {InputLength, 50, 25, 10, NumActions};
 
  

//function to produce sound, currently it just draws an indicator whnever alien is to produce a sound
  void produceSound() {
    noFill(); 
    stroke ( 0);
    ellipse (pos.x, pos.y, diameter + 5, diameter + 5);
  }

  
  void listenToSound() {
  }

  //each alien can evolve into another type going through pupal phase
  void evolve ( String nextState, String currentState) {
    aliens.add( new PupalStage(currentState, nextState , genome, pos.x, pos.y));
    aliens.remove(this);
  }

//draws an alien according to specifications
  void render() {
    fill (cor); 
    noStroke();
    ellipse (pos.x, pos.y, diameter, diameter);
  }

  void update() {
    checkWallCollision();
    collisionMove();
    
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
    }
  }

  //shows the weights of the neural net in a form of a grid
  void visualiseNeuralNet(){
    int gridSize = 2;
    
    for (int i = 0; i < _layers.length-1; i++){
      for ( int j = 0 ; j < RLNet.DeepQ.layers[i].weights.length; j++){
        for ( int k = 0 ; k < RLNet.DeepQ.layers[i].weights[j].length; k++){
          noStroke(); 
          fill(0,0,0,map(RLNet.DeepQ.layers[i].weights[j][k], -1,1, 0,255));
           
            rect(100 + 110 * i + gridSize*j, 100 + gridSize+ gridSize*k, gridSize,gridSize);
            }
        }
      }
    
  }
  
  
   void produceLarva() {
    aliens.add(new Larva(pos.x, pos.y));
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
  void collisionMove(){
     //get pushed away if there is collision
    if ( checkCollision() !=null){
      float invertion = PI;
       if (checkCollision().pos.y == pos.y && checkCollision().pos.x == pos.x){
        invertion = PI + random(0,2*PI); //random vector direction in case if the agents are positioned at the same coordinate
       }
         //calculate a vector pointing away from the target
         float angle = atan2(checkCollision().pos.y - pos.y, checkCollision().pos.x - pos.x);
         //update positions
         float newX = cos(angle + invertion) * speed + pos.x;
         float newY = sin(angle + invertion) * speed + pos.y;
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
  
  float [] getSoundSpectrum(AudioOutput in) {
    fftLin.forward(in.mix);
    float [] spectrum = new float [fftLin.specSize()];
    for ( int i = 0; i< fftLin.specSize(); i++) {
      spectrum[i] = fftLin.getBand(i);
    }
    return spectrum;
  }
  
  
  //returns the alien which is colliding with the current alien
  Alien checkCollision(){
    for (Alien a : aliens){
      if ( a != this){
        if (dist(pos.x, pos.y, a.pos.x, a.pos.y) < diameter/2 + a.diameter/2){
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
    rewardPrevious();
    reward = 0;
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
  void rewardPrevious() {
    for ( int i = 0; i < lastOutputs.size(); i++) {
      RLNet.ObserveReward(reward, lastOutputs.get(i), GetActionMask());
    }
  }

  
  //actions to be selected by the output of the neural network
  void moveUp() {
    pos.y = pos.y - speed;
  }

  void moveLeft() {
    pos.x = pos.x - speed;
  }

  void moveRight() {
    pos.x = pos.x+speed;
  }

  void moveDown() {
    pos.y  = pos.y + speed;
  }
}