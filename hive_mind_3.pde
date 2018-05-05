import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.effects.*;
import ddf.minim.signals.*;
import ddf.minim.spi.*;
import ddf.minim.ugens.*;
import ddf.minim.analysis.FFT;
import controlP5.*;

ArrayList <Alien> aliens; 
ArrayList <Obstacle> obstacles;

Selection selector;
AlienManager aManager;
ControlP5 cp5;
ControlP5 queenControls;
ControlP5 workerControls;
Minim minim;
AudioInput in; //sound from mic
AudioOutput out; //sound from soundcard
FFT fftLin;
FFT fftLinOut;
HiveMind player;
Hud hud; 
Swiper swipeController;
GameLevel level;
Tutorial tutorial;


// breeding , feeding , herding, focus on basic behaviours 
//focus on basic behaviours before making it more complex 
//important to make various levels and implement a good tutorial so the application would be more "complete"

//prevents rewards before the action is done
boolean rewardsActive = false;

boolean godMode = false;

//minimum sound level of the mic to be perceived by the aliens
float minimum_s_level = 0.09;

String gameState = "startScreen";

void setup() {
  size ( 1280, 720);
  cp5 = new ControlP5(this);

  tutorial = new Tutorial();
  player = new HiveMind();
  level = new GameLevel(); 
  //placing initial aliens
  aliens = new ArrayList <Alien>(); 

  aManager = new AlienManager();

  //selected alien manager
  selector = new Selection();
  swipeController = new Swiper();
  //setup sound input from player
  minim = new Minim(this);
  in = minim.getLineIn(); //mic
  out = minim.getLineOut(); // soundcard
  fftLin = new FFT (in.bufferSize(), in.sampleRate());
  fftLin.linAverages(30);

  fftLinOut = new FFT (out.bufferSize(), out.sampleRate());
  fftLinOut.linAverages(30);

  hud = new Hud();
}

void draw() {
  background(255);
  //game loop
  aManager.updateAliens();
  level. update();
  player.update();
  selector.update();
  hud.update();
  swipeController.update();
  tutorial.playTutorial();
  level.render();
}

//function to get a row of an array
//arguments are a 2D array and the row number
//returns the selected row as a 1D array
float [] getaRow (float[][] array, int i) {
  float myRow []= new float [array[i].length];
  for (int l = 0; l< array[i].length; l++) {
    myRow[l] = array[i][l];
  }
  return myRow;
}