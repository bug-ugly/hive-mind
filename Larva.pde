//state of an alien when hatched
public class Larva extends Alien {
  final float larvaDiameter = 4;
  final float larvaSpeed = 0.2;
  final color larvaColor = color ( 255, 0, 0);

  int growthTimer;

  public Larva (float _x, float _y ) {
    pos = new PVector(_x, _y);
    speed = larvaSpeed;
    diameter = larvaDiameter;
    type = "Larva";
    cor = larvaColor;

    growthTimer = 200;
  }

  public void render() {
    super.render();
    noFill(); 
    stroke(0);
    ellipse(pos.x, pos.y, diameter, diameter);
  }

  public void update() {
    super.update();
    growthTimer --; 
    if ( growthTimer <= 0) {
      grow();
    }
  }

  public void grow() {
    aliens.add(new Worker(pos.x, pos.y));
    dead = true;
  }
}