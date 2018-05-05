public class Obstacle {
  PVector pos1; 
  PVector pos2;
  float lineLength; 


  public Obstacle(float _x1, float _y1, float _x2, float _y2) {
    pos1 = new PVector(_x1, _y1);
    pos2 = new PVector (_x2, _y2);
    lineLength = lineLengthCalc();
  }


  float lineLengthCalc() { //calculating the length of the line using pythagoras' theorem
    float a; 
    float b; 
    a = pos1.x - pos2.x;
    b = pos1.y - pos2.y;

    return sqrt(sq(a)+sq(b));
  }

  void update() {
  }

  void render() {
    stroke (0); 
    line ( pos1.x, pos1.y, pos2.x, pos2.y);
  }
  //boolean checkObstacleCollision(Alien a){
  //  float distancesSum = (dist(a.pos.x, a.pos.y, pos1.x, pos1.y) + dist(a.pos.x, a.pos.y, pos2.x, pos2.y));
  //  println ("dsum: "+ distancesSum + " linelength: " +lineLength);
  //  if (distancesSum <= lineLength+ 0.5){
  //    return true;
  //  }
  //  return false;
  //}

  boolean checkObstacleCollision(Alien a) {

    float distancesSum = (dist(a.pos.x, a.pos.y, pos1.x, pos1.y) + dist(a.pos.x, a.pos.y, pos2.x, pos2.y));
    //println ("dsum: "+ distancesSum + " linelength: " +lineLength);
    float intersectionX = 0; 
    float intersectionY = 0; 
    if (pos1.x != pos2.x && pos1.y != pos2.y) {
      float obstacleSlope = (pos2.y - pos1.y) / (pos2.x - pos1.x);
      float alienSlope = 1.0/ (-obstacleSlope);
      float alienB = a.pos.y + (-alienSlope) * a.pos.x;
      float obstacleB = pos1.y + (-obstacleSlope)* pos1.x;

      intersectionX = (obstacleB - alienB) / (alienSlope - obstacleSlope);
      intersectionY = obstacleSlope * intersectionX + obstacleB;


      println ("intersectionX: " + intersectionX + " intersectionY: " + intersectionY);
    } else if (pos1.x == pos2.x) {
      intersectionX = pos1.x; 
      intersectionY = a.pos.y;
    } else if (pos1.y == pos2.y) {
      intersectionX = a.pos.x; 
      intersectionY = pos1.y;
    }

    float perpendicularLineLength = dist(a.pos.x, a.pos.y, intersectionX, intersectionY);
    //stroke (255,0,0); 
    //line ( intersectionX, intersectionY, a.pos.x, a.pos.y);

    if ( perpendicularLineLength<= a.diameter/2 && distancesSum <= lineLength + a.diameter/2) {

      return true;
    }

    //if (distancesSum <= lineLength+ 0.5){
    //  return true;
    //}
    return false;
  }
}