//Hud elements on the screen
class Hud{
  Slider levels;
  final int levelsX = 100; 
  final int levelsY = height-50;
  final int levelsWidth = 500; 
  
  final int selectedX = 100; 
  final int highlightedX = 100; 
  final int selectedY = 50; 
  final int highlightedY = 70; 
  final int selectedTextSize = 10; 
  final int highlightedTextSize = 10; 
  
  
  final int controlsY = 200;

  public Hud(){
    createSoundLevelControl();
  }
  
  void update(){
    showMicSoundLevels();
    showSelectedText(); 
    showHighlightedText();
  }
  
  
  //control the sensitivity of the microphone in order to remove the unnecessary noise
  void showSelectedText(){
    fill (0);
    stroke(0);
    textSize(selectedTextSize);
    text("" + selector.selectedAlien,selectedX, selectedY);
  }
  
  void showHighlightedText(){
    fill (0);
    stroke(0);
    textSize(highlightedTextSize);
    text ("" + selector.highlightedAlien,highlightedX,highlightedY);
  }
  void showMicSoundLevels(){
   float current_level = ((in.left.level() + in.right.level()) /2);
   float endLineX = map( current_level, 0,1, levelsX,levelsX + levelsWidth ); //position of the tip of the line indicator
   if (current_level > minimum_s_level){
   stroke(0);
   fill (200,200,200);
   }
   else if(endLineX > levelsX + levelsWidth){
   fill ( 255,0,0);
   stroke(255,0,0);
   }
   else {
    noFill();
   stroke(100,100,100);
   }
   line( levelsX,levelsY+10, endLineX, levelsY+10);
   noStroke();
   ellipse(levelsX + 5, levelsY + 20, 10,10);
   //text ( "levels: " + current_level,levelsX, levelsY + 30);
  }
  

  
  void createSoundLevelControl(){
    cp5.addSlider("minimum_s_level")
     .setPosition(levelsX,levelsY)
     .setRange(0,1)
     .setWidth(levelsWidth);
     
     ;
  }
  
  void slider(float level) {
  minimum_s_level = level;
}

  void createControls ( Alien a){
    String [] controlsNum = a.controls;
    removeControls();
    Group g1 = cp5.addGroup("Controls")
                .setPosition(100,100)
                .setBackgroundHeight(100)
                .setBackgroundColor(color(255,50))
                ;
    
    for (int i = 0; i< controlsNum.length; i++){
        cp5.addButton(controlsNum[i])
       .setPosition(0, 0 + i * 20)
       .setId(i)
       .setGroup(g1);
    }
  
 
  }
  
  void removeControls(){
    try{
    cp5.remove("Controls");
    } catch (NullPointerException e) {
    e.printStackTrace();
    }
  }
  
  void buttonPressed(int id){
    selector.executeSelectedAlienFunction(id);
  }
}

void controlEvent(ControlEvent theEvent) {
    //theEvent.getController().getParent().getName();
    if(theEvent.isController()) { 
      if(theEvent.getController() instanceof Button) {
        hud.buttonPressed(theEvent.getController().getId());
      }
    }
}