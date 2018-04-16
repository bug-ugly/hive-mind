import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.effects.*;
import ddf.minim.signals.*;
import ddf.minim.spi.*;
import ddf.minim.ugens.*;
import ddf.minim.analysis.FFT;
import controlP5.*;

ArrayList <Alien> aliens; 
Selection selector;
AlienManager aManager;
ControlP5 cp5;
Minim minim;
AudioInput in;
FFT fftLin;
HiveMind player;
Hud hud;

boolean rewardsActive = false; //prevents rewards before the action is done

//minimum sound level of the mic to be perceived by the aliens
float minimum_s_level = 0.09;

// select an alien to select evolution 
// evolve 


void setup() {
  size ( 1280, 720);
  cp5 = new ControlP5(this);
  player = new HiveMind();

  //placing initial aliens
  aliens = new ArrayList <Alien>(); 
  aManager = new AlienManager();

  //selected alien manager
  selector = new Selection();

  //setup sound input from player
  minim = new Minim(this);
  in = minim.getLineIn();
  fftLin = new FFT (in.bufferSize(), in.sampleRate());
  fftLin.linAverages(30);

  hud = new Hud();
}

void draw() {
  background(255);
  //game loop
  aManager.updateAliens();
  player.update();
  selector.update();
  hud.update();
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