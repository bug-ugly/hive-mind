
//class to manage selection and highlight on mouse hover/click
public class Selection {
  Alien selectedAlien; //index of a selected alien
  Alien highlightedAlien; //index of a highlighted alien

  final color selectionColor = color (255, 255, 255); 
  final color highlightColor = color (255, 255, 255);

  //boolean values to check if something was selected/hughlighted

  Selection() {
  }

  void update() {
    
    //println ("Selected = " + (selectedAlien));
    //println ("Highlghted = " + (highlightedAlien));
    
    resetSelection();
    
    for ( int i = 0; i< aliens.size(); i++) {
      Alien a = aliens.get(i);
      //check if something new was selected or highlighted
      checkSelection(a);
      
      //visual effects of selection and highlight
      if ( a == selectedAlien) {
        noFill(); 
        stroke ( selectionColor);
        ellipse (a.pos.x, a.pos.y,a.diameter - 2, a.diameter - 2);
        if ( a instanceof Fighter){
           a.visualiseNeuralNet();
        }
        
        
      }
      if ( a == highlightedAlien) {
        noFill(); 
        stroke ( highlightColor);
        ellipse (a.pos.x, a.pos.y, 2, 2);
      }

     }
  }
  
  void resetSelection(){
    highlightedAlien = null;
    if (mousePressed){
      if ( mouseX > 80 && mouseX <300 && mouseY > 80 && mouseX < 300){ //ignore the interface bit
      }
      else{
      selectedAlien = null;
      hud.removeControls();
      }
    }
  }
  
  void executeSelectedAlienFunction(int functionId){
     for ( int i = 0; i< aliens.size(); i++) {
      Alien a = aliens.get(i);
      if ( a == selectedAlien) {
        a.executeFunction(functionId);
      }
     }
  }

  void checkSelection(Alien _a) {
    
    if ( dist(mouseX, mouseY, _a.pos.x, _a.pos.y) <= _a.diameter/2 ) {
      highlightedAlien = _a;
    } 

    if (mousePressed) {
      if (highlightedAlien == _a) {
        selectedAlien = _a;
        if ( _a instanceof Worker){
          
           hud.createControls(_a);
        }
        
        if ( _a instanceof Queen){
           
           hud.createControls(_a);
        }
      } 
    }
  }
}