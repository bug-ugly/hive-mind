class HiveMind{
  public int commandTimer = 0;
  public int commandTimerMax = 100;
  int playerReward = 50;

  HiveMind() {
   
  }
  
  void checkKeys(){
    if (keyPressed){
       if( key == 'Y' || key == 'y'){
                 sayYes();
    
          }
         else if( key == 'N' || key == 'n'){
                  sayNo();
          }
    }
  }
  
  void update(){
    checkKeys();
     if (commandTimer < commandTimerMax) {
    commandTimer++;
    }
  }
  
  void sayYes(){
     if(rewardsActive && commandTimer >= commandTimerMax){
      for ( int i = 0; i< aliens.size(); i++){
        if ( aliens.get(i) instanceof Fighter){
          //aliens.get(i).backP(playerReward);
          aliens.get(i).reward = aliens.get(i).reward + playerReward;
          rewardsActive = false;
          //println("yes");
        }
      }
      commandTimer = 0;
    }
  }
  
  void  sayNo(){
     if(rewardsActive  && commandTimer >= commandTimerMax){
      for ( int i = 0; i< aliens.size(); i++){
        if ( aliens.get(i) instanceof Fighter){
         aliens.get(i).backP(-playerReward);
          
         rewardsActive = false;
        // gameObjects.get(i).backP(new float [] {-1,1,1,1,1});
        //println("no");
        }
      }
       commandTimer = 0;
     }
  }
  
  void sayDirection ( String dir){
    if ( rewardsActive ){
      for ( int i = 0; i< aliens.size(); i++){
        if ( aliens.get(i) instanceof Fighter){
          aliens.get(i). backP (dir);
        }
      }
    }
  }
  
 
}