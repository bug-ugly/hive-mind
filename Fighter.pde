public class Fighter extends Alien {
  
  
  final color fighterColor = color(0, 0, 0);
  final float fighter_size = 10; //visual size of the agent
  final float fighter_speed = 1; // locomotion speed of the agent
  
  int nn_update_frequency = 20;

  int replayMemoryCapacity = 12;
  float discount = .99f;
  double epsilon = 1d;
  int batchSize = 12;
  int updateFreq = 1;
  int replayStartSize = 12;

 

  public Fighter(float _x, float _y) {
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
       fighterListen();
       
      
  
  }
  
  void fighterListen(){
     if ((in.left.level() + in.right.level()) /2 >minimum_s_level) {
      rewardsActive = true;
      int top = RLNet.GetAction(getSoundSpectrum(in), GetActionMask()); //get the action from nn
      lastOutputs.add(getSoundSpectrum(in)); //add the action to the list of last outputs
      while (lastOutputs.size() > ratedActionsNum) { //check if number of last outputs is past the limit and remove the excess actions
        lastOutputs.remove(0);
      }
      performAction(top); //perform the top selected action
    }
  }

  void render() {
    super.render();
    ellipse(pos.x, pos.y, diameter, diameter);
    stroke(0); 
    for ( float i = 0; i<= TWO_PI; i = i + QUARTER_PI/2){
    line(pos.x,pos.y, pos.x + diameter*0.7*cos(i), pos.y + diameter*0.7*sin(i)); 
    }
  }
}