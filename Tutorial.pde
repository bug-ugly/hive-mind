class Tutorial implements Observer{
  int tutorialPart;
  
  int larvaCounter;
  
  int lastStepTimer;
  
  String tutorialText;
  
  public Tutorial(){
    tutorialPart = 0;
    larvaCounter = 0;
    lastStepTimer = 0;
  }
  
   @Override 
   public void update(String event){ //gets events from Subjects and plays the sounds according to them
     switch(event) {
        case "EVENT_QUEEN_SELECTED": 
        if ( tutorialPart == 0){
           tutorialPart = 1;
        }
          break;
        case "EVENT_ALIEN_DESELECTED": 
          if(tutorialPart == 1){
              tutorialPart = 2;
          }
          break;
        case "EVENT_PRODUCE_LARVAE":
          if (tutorialPart == 2){
              larvaCounter ++;
              if ( larvaCounter>=3){
                tutorialPart = 3;
              }
          }
          break;
         case "EVENT_EVOLVE_W_INTO_F":
          if (tutorialPart == 3){
              tutorialPart = 4;
          }
          break;
          case "EVENT_FIGHTER_HATCHED":
          if (tutorialPart == 4){
              tutorialPart = 5;
          }
          break;
          
          case "EVENT_SWIPE_RIGHT":
          if (tutorialPart == 5){
              tutorialPart = 6;
          }
          break;
      }
      
   }
   
   public void playTutorial(){
     switch (tutorialPart){
       case 0:
       //select the queen
       tutorialText ="select the queen";
       break; 
       
       case 1:
       //deselect by right clicking
        tutorialText ="deselect by right clicking";
       break; 
       case 2:
       //produce larvae
        tutorialText ="select the queen and click the button on the top left to produce larvae. Create 3 of them. They will grow rapidly to become Workers. ";
       break;
       case 3:
       //select one of the workers and evolve it into a fighter
        tutorialText ="select one of the workers and evolve it into a fighter by pressing a button on the top left";
       break;
       
       case 4:
        //wait for the fighter to hatch
         tutorialText ="Fighter is hatching";
       break; 
       case 5:
        //Fighter responds to the sounds from the mic and also mouse drags. Hold left mouse button and drag to the right. 
         tutorialText ="We now have a Fighter. Fighter responds to the sounds from the mic and also mouse drags. Hold left mouse button and drag to the right. ";
       break; 
        case 6:
        //Dragging the mouse changes reaction of an alien to the previous sounds. Mouse drags show alien the direction you wanted it to go in response to a sound. Producing a sound and dragging a mouse afterwards will show the alien where you wanted it to go. Like this, it is possible to teach aliens to move around.  
       tutorialText ="Dragging the mouse changes reaction of an alien to the previous sounds. Mouse drags show alien the direction you wanted it to go in response to a sound. Producing a sound and dragging a mouse afterwards will show the alien where you wanted it to go. Like this, it is possible to teach aliens to move around.";
      lastStepTimer ++; 
      if(lastStepTimer > 500){
        tutorialText ="";
      }
       break; 
       
     }
     fill(0);
     stroke(0);
     text(tutorialText, width-200, 50, 150, 150);
   }
}