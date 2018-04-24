class Swiper{
  ArrayList <PVector> mouseCoordinates;
  boolean swiping;

  public Swiper(){
    mouseCoordinates = new ArrayList <PVector> ();
    swiping  = false;

  }
  
  
  void update(){
    if ( mouseCoordinates!= null){
      for (int i = 1; i < mouseCoordinates.size(); i++){
        PVector p = mouseCoordinates.get(i); 
        PVector p2 = mouseCoordinates.get(i-1); 
        strokeWeight( 0.5);
        stroke ( 255,0,0);
        line ( p.x, p.y, p2.x,p2.y);
          
        
      }
    }
  }
  
 void swipeEvent(){
    if (swiping == false){
     mouseCoordinates = new ArrayList <PVector>();
  }
  swiping = true;
  mouseCoordinates.add( new PVector ( mouseX, mouseY));
 }
 
 void swipeFinished(){
   if (swiping){
    determineSwipe(mouseCoordinates);
    swiping = false;
    mouseCoordinates = new ArrayList <PVector>();
  }
 }
  
  void determineSwipe(ArrayList <PVector> coordinates){
    String swipe = "";
    if ( coordinates != null){
      int xDiff = int (coordinates.get(coordinates.size()-1).x - coordinates.get(0).x);
      int yDiff = int (coordinates.get(coordinates.size()-1).y - coordinates.get(0).y); 
      //using square to compare because we want to compare the positive values only
      if (sq(yDiff) > sq(xDiff)){
        if ( coordinates.get(coordinates.size()-1).y > coordinates.get(0).y){
          swipe = "Down";
        }
        else  {
          swipe = "Up";
        }
      }
      else if( sq(xDiff) > sq(yDiff)){
          if ( coordinates.get(coordinates.size()-1).x > coordinates.get(0).x){
          swipe = "Right";
        }
        else  {
          swipe = "Left";
        }
      }
    }
    sendSwipe(swipe);
  }
  
  void sendSwipe(String swipe){
    println(swipe);
    player.sayDirection(swipe);
  }
}

void mouseDragged(){
 swipeController.swipeEvent();
}

void mouseReleased(){
 swipeController.swipeFinished();
}