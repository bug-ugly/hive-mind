//queen that spawns larvae
public class Queen extends Alien {
  int biomassCount; //defines how many nutrients the queen has

  float [] breedingGene; 

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
}