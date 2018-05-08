public class Fighter extends Alien {


  final color fighterColor = color(0, 0, 0);
  final float fighter_size = 10; //visual size of the agent
  final float fighter_speed = 3; // locomotion speed of the agent

  int nn_update_frequency = 20;

  int replayMemoryCapacity = 12;
  float discount = .99f;
  double epsilon = 1d;
  int batchSize = 12;
  int updateFreq = 1;
  int replayStartSize = 12;

  


  public Fighter(float _x, float _y) {
    lastOutputs = new ArrayList<float []>();
   
    actions = new String [] {"up", "down", "left", "right", "nothing"};
    NumActions = actions.length;
     _layers = new int[] {InputLength, 50, 25, 10, NumActions};
    diameter = fighter_size;
    pos = new PVector (_x, _y);
    speed = fighter_speed;
    cor = fighterColor;
    type = "Fighter";
        RLNet = new DeepQNetwork(_layers, replayMemoryCapacity, discount, epsilon, batchSize, updateFreq, replayStartSize, InputLength, NumActions);

      out = minim.getLineOut();
    // create a sine wave Oscil, set to 440 Hz, at 0.5 amplitude
    wave = new Oscil( 100, 0.5f, Waves.SINE );
    fftLinA = new FFT (out.bufferSize(), out.sampleRate());
    fftLinA.linAverages(30);
    
    this.registerObserver(tutorial);

    controls = new String[] {};
    collidable = true;
    selectable = true;
    
    soundInterval = 5;
  }

  void update() {
    //println(in.left.level());
    super.update();
    if (godMode){
      godMode();
    }
    else{
      fighterListen();
    }
    intervalCounter ++; 
    if ( intervalCounter > soundInterval){
     triggerNoise = true;
     intervalCounter = 0; 
    }
  }

  void godMode() {
    if ( keyPressed){
      if ( keyCode == UP) {
        performAction(0) ; 
      }
      if ( keyCode == DOWN) {
        performAction(1) ; 
      }
      if ( keyCode == LEFT) {
        performAction(2) ; 
      }
      if ( keyCode == RIGHT) {
        performAction(3) ; 
      }
      
    }
  }
  //function to respond to sounds from player
  void fighterListen() {
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
    //stroke(0); 
    //for ( float i = 0; i<= TWO_PI; i = i + QUARTER_PI/2) {
    //  line(pos.x, pos.y, pos.x + diameter*0.7*cos(i), pos.y + diameter*0.7*sin(i));
    //}
  }
}