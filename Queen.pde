//queen that spawns larvae
public class Queen extends Alien {
  
  ArrayList <NeuralNetwork> geneSeed;
  int geneSeedNumber = 5; 
  
  int biomassCount; //defines how many nutrients the queen has
  
  final int queenDiameter = 15;
  final color queenColor = color(0, 0, 0);

  Queen (int _x, int _y, int bioCount) {
    
    
    pos = new PVector( _x, _y);
    diameter = queenDiameter;
    cor = queenColor;
    biomassCount = bioCount;
    type = "Queen";
    controls = new String[] {"Spawn Larvae"};
    this.registerObserver(tutorial);
    collidable = true;
    selectable = true;
    geneSeed = new ArrayList <NeuralNetwork>();
      _layers = new int[] {8, 30, 16, 9};
      
    for ( int i = 0; i< geneSeedNumber; i++){
    geneSeed.add(new NeuralNetwork ( _layers));
    geneSeed.get(i).fitness = 0;
    }
  }

  void executeFunction(int functionId) {
    super.executeFunction(functionId);
    switch(controls[functionId]) {
      case ("Spawn Larvae"):
      produceLarva();
      setEvent("EVENT_PRODUCE_LARVAE");
      break;
    }
  }
  
  void compareFitnessAndAdd(NeuralNetwork _n, int fit){
    super.compareFitnessAndAdd(_n, fit);
    boolean accepted = false;
    for ( int i = 0; i < geneSeed.size(); i++){
      NeuralNetwork n = geneSeed.get(i);
      if ( fit > n.fitness){
        accepted = true;
      }
    }
    if ( accepted == true){
      _n.fitness = fit;
      addGeneSeed (_n);
    }
  }
  
  void addGeneSeed(NeuralNetwork _n){
    geneSeed.add(_n);
    if ( geneSeed.size() >= geneSeedNumber){
      geneSeed.remove(0);
    }
  }
  
  int getRandomGeneSeed(){
    return int(random(geneSeed.size()));
  }
  
  void produceLarva(){
    super.produceLarva();
     aliens.add(new Larva(pos.x, pos.y, geneSeed.get(getRandomGeneSeed())));
  }
}
