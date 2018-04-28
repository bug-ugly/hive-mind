public class Drone extends Alien {

   float droneSize = 10;
   color droneColor = color(0,100,100);
  public Drone (float _x, float _y) {
    speed = 2;
    type = "Drone";
    pos = new PVector(_x, _y);
    diameter = droneSize;
    cor = droneColor;
  }


}