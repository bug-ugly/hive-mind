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

//function to produce sound, currently it just draws an indicator whnever alien is to produce a sound
  void produceSound() {
    noFill(); 
    stroke ( 0);
    ellipse (pos.x, pos.y, diameter + 5, diameter + 5);
  }

  
  void listenToSound() {
  }

  //each alien can evolve into another type going through pupal phase
  void evolve ( String evolution, String currentState) {
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

  void displayStats() {
  }

  void displayActions() {
  }

  void backP ( float score) {
  }
  void visualiseNeuralNet(){
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

  float [] getSoundSpectrum() {
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
}