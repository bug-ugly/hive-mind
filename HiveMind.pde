class HiveMind {
  //player commands class

  public int commandTimer = 0;
  public int commandTimerMax = 100;
  int playerReward = 50;

  HiveMind() {
  }

  void checkKeys() {
    if (keyPressed) {
      if ( key == 'Y' || key == 'y') {
        sayYes();
      } else if ( key == 'N' || key == 'n') {
        sayNo();
      }
      if ( key== 'G' || key == 'g'){
        godMode = !godMode;
        if ( godMode){
          println("GOD MODE ON");
        }
        else {
          println("GOD MOFE OFF");
          
        }
      }
    }
  }

  void update() {
    checkKeys();
    if (commandTimer < commandTimerMax) {
      commandTimer++;
    }
  }

  void sayYes() {
    if (rewardsActive && commandTimer >= commandTimerMax) {
      for ( int i = 0; i< aliens.size(); i++) {
        if ( aliens.get(i) instanceof Fighter) {
          //aliens.get(i).backP(playerReward);
          aliens.get(i).reward = aliens.get(i).reward + playerReward;
          rewardsActive = false;
          //println("yes");
        }
      }
      commandTimer = 0;
    }
  }
  
  void  sayNo() {
    if (rewardsActive  && commandTimer >= commandTimerMax) {
      for ( int i = 0; i< aliens.size(); i++) {
        if ( aliens.get(i) instanceof Fighter) {
          aliens.get(i).backP(-playerReward);

          rewardsActive = false;
          // gameObjects.get(i).backP(new float [] {-1,1,1,1,1});
          //println("no");
        }
      }
      commandTimer = 0;
    }
  }

  //report direction of a swipe to the fighter
  void sayDirection ( String dir) {
    if ( rewardsActive ) {
      for ( int i = 0; i< aliens.size(); i++) {
        if ( aliens.get(i) instanceof Fighter) {
          aliens.get(i). backP (dir);
        }
      }
    }
  }
}
