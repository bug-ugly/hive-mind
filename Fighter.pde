public class Fighter extends Alien {

  final int InputLength = 513; //the size of the input that the agent receives. the sound spectrum is the total of 513 numbers
  final int NumActions = 5; //total number of actions that the agent can perform: move right, left,up, etc.

  //initialization model for a neural network to be used by DeepQNetwork
  final int [] _layers = new int[] {InputLength, 50, 25, 10, NumActions};
  final String [] actions = new String [] {"up", "down", "left", "right", "nothing"};
  final color fighterColor = color(0, 0, 0);
  final float fighter_size = 10; //visual size of the agent
  final float fighter_speed = 1; // locomotion speed of the agent

  int replayMemoryCapacity = 1024;
  float discount = .99f;
  double epsilon = 1d;
  int batchSize = 1024;
  int updateFreq = 1;
  int replayStartSize = 24;

  ArrayList <float []> lastOutputs; // an array to store a number of last actions that are to be rated
  float ratedActionsNum = 10; //number of the last actions that are going to be rated by the player, there needs to be many actions (10) for the neural network precision
  float reward;   //current reward

  public Fighter(int _x, int _y) {
    lastOutputs = new ArrayList<float []>();
    RLNet = new DeepQNetwork(_layers, replayMemoryCapacity, discount, epsilon, batchSize, updateFreq, replayStartSize, InputLength, NumActions);
    diameter = fighter_size;
    pos = new PVector (_x, _y);
    speed = fighter_speed;
    cor = fighterColor;
    type = "Fighter";
  }

  void update() {
    //println(in.left.level());
    super.update();
    if ((in.left.level() + in.right.level()) /2 >minimum_s_level) {
      rewardsActive = true;
      int top = RLNet.GetAction(getSoundSpectrum(), GetActionMask()); //get the action from nn
      lastOutputs.add(getSoundSpectrum()); //add the action to the list of last outputs
      while (lastOutputs.size() > ratedActionsNum) { //check if number of last outputs is past the limit and remove the excess actions
        lastOutputs.remove(0);
      }
      performAction(top); //perform the top selected action
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
    }
  }

  //shows the weights of the neural net in a form of a grid
  void visualiseNeuralNet(){
    super.visualiseNeuralNet();
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


  void backP( float score) {
    super.backP(score);
    reward = score;
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



  void render() {
    super.render();
    ellipse(pos.x, pos.y, diameter, diameter);
  }
}