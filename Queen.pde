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
  }

  void produceLarva() {
    aliens.add(new Larva((int)pos.x, (int)pos.y));
  }
  
}