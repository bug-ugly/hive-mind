class GameLevel {
  //class that contains obstacles and other scenery 

  public GameLevel() {
    obstacles = new ArrayList <Obstacle>();
    drawObstacles();
  }

  void drawObstacles() {
    //obstacles.add(new Obstacle ( width/2 - 100, 130,width/2+80,100));
    //obstacles.add(new Obstacle ( width/2 - 100, 130,width/2-100,500));
    //obstacles.add(new Obstacle ( width/2 + 80, 100,width/2+100,520));
    //obstacles.add(new Obstacle ( width/2 - 100, 500,width/2+100,520));

    obstacles.add(new Obstacle ( width/2 - 40, 300, width/2, 250));
  }

  void update() {
    for ( int i = 0; i < obstacles.size(); i++) {
      Obstacle o = obstacles.get(i); 
      o.update();
    }
  }

  void render() {
    for ( int i = 0; i < obstacles.size(); i++) {
      Obstacle o = obstacles.get(i); 
      o.render();
    }
  }
}