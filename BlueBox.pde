import g4p_controls.*;
import processing.sound.*; //please make sure you have this library downloaded before running code!

String answer;
int q, t, f, v;
int phase = 1;
SoundFile sfile;

//Algorithm Arrays
String[] file, descFile, questions;
Item[] Original;
ArrayList<Item> Iindex, prevIndex, newI;

//Graphics
Bin[] bins = new Bin[8];
PImage schattman, logo;
PImage[] binPics = new PImage[5];

void setup() {
  size(800, 500);
  createGUI();
  textAlign(CENTER);
  imageMode(CENTER);
  rectMode(CENTER);
  textSize(20);
  noStroke();

  //loading pictures
  logo = loadImage("logo.png");
  schattman = loadImage("schattman.png");
  binPics[0] = loadImage("recycle.png");
  binPics[1] = loadImage("trashcan.png");
  binPics[2] = loadImage("compost.png");
  binPics[3] = loadImage("depot.png");
  binPics[4] = loadImage("yard.png");

  //loading sound
  sfile = new SoundFile(this, "pbm.mp3");
  sfile.loop();

  //creating background animation
  for (int i = 0; i < 8; i++) {
    bins[i] = new Bin(i, random(2, 4));
  }

  //loading algorithm arrays
  file = loadStrings("testCases.txt");
  descFile = loadStrings("descriptions.txt");
  questions = file[0].split(","); //first line in testCases are the questions
  Original = new Item[file.length-1]; //the reference array of Item objects, to be initialized in the next for loop
  for (int i = 0; i < file.length-1; i++) {
    Original[i] = new Item(file[i+1], descFile[i]); //skips past first line in file when loading, because first line is questions
  }
  reGen();
}

void reGen() { //recallable function for restart purposes
  Iindex = new ArrayList<Item>(); //since we didn't like the idea of creating more objects when the game restarts, we reload the Iindex arraylist from the Original array
  for (int i = 0; i < Original.length; i++) {
    Original[i].setTfArray(file[i+1]); //the reason this happens every restart is because the question catch code changes the true-false array- see selectQ()
    Iindex.add(Original[i]);
  }
  prevIndex = new ArrayList<Item>(); //for undo purposes
  questions = file[0].split(","); //again, because of the question catch code - see selectQ()
  textAlign(CENTER); //see answerPath(), must be reset
  rectMode(CENTER); //see answerPath, must be reset
  restart.moveTo(500, 350); //move button back to where it needs to be
  selectQ();
}

void draw() {
  background(111, 151, 216);
  if (phase == 1) { //start screen
    drawBins();
    image(logo, 400, 220);
  } else if (phase == 2) { // game screen
    drawBins();
    fill(0, 180);
    rect(400, 270, 500, 300);
    fill(255);
    text(questions[q], 400, 200);
  } else { //results
    image(schattman, 70, 250);
    Iindex.get(0).display();
  }
}

void drawBins() { //see Bin class
  for (Bin bin : bins) {
    bin.collide();
    bin.move();
    bin.display();
  }
}

void answerPath() { //called when the yes/no button is clicked
  undo.setVisible(true); 
  removeItems();
  if (Iindex.size() > 1) selectQ(); //if there's still items to be eliminated
  else { //move to end screen, modify all required settings/buttons for that
    phase++; 
    yes.setVisible(false);
    no.setVisible(false);
    undo.setVisible(false);
    savePic.setVisible(true);
    restart.moveTo(450, 440);
    textAlign(LEFT, TOP);
    rectMode(CORNER);
  }
}

void selectQ() {
  int min = Iindex.size(); //set to the maximum difference between #trues and #falses
  int maxv = Iindex.size(); //set to the maximum number of voids possible 
  q = -1; 
  for (int i = 0; i < questions.length; i++) { // for each question
    t = 0; //number of trues
    f = 0; //number of falses
    v = 0; //number of voids 
    for (int j = 0; j < Iindex.size(); j++) { //for each Item
      Iindex.get(j).count(i); //see Items class
    }
    if (t != 0 && f != 0 && (abs(t-f) < min || abs(t-f) == min && v < maxv)) { //if there's at least 1 true and at least 1 false, and the question has a better t/f ratio or less voids
      min = abs(t-f); //set current benchmark t/f ratio and #voids
      maxv = v;
      q = i; //set question to current
    }
  }
  if (q == -1) { //if there is no question that can eliminate either of the Items (these situations have mostly been debugged out, but just in case)
    q = questions.length-1; //set q to the last question 
    questions[q] = "Is it "+ Iindex.get(0).name + "?"; //make the last question asking about one of the remaining Items
    Iindex.get(0).tf[q] = "TRUE"; //set that item's answer for that question to true
    for (int i = 1; i < Iindex.size(); i++) { //set everything else's to false
      Iindex.get(i).tf[q] = "FALSE"; 
    } //this piece of code is the reason we had to do so much regenerating for restart
  }
}

void removeItems () {
  newI = new ArrayList<Item>(); 
  for (int j = 0; j < Iindex.size(); j++) {
    Iindex.get(j).addItem(); 
  }
  prevIndex = Iindex; //for undo purposes
  Iindex = newI;
}

//unfinished wishlist (if we had more time to develop our program):
//1. If the program got it wrong, user can make changes to the array (what item were you aiming for? which question did I get wrong? what should the answer be?)
      //we had all the catch code for it too! and a drop-down menu! it's a real shame we couldn't implement this
//2. Animation at the end, of Mr. Schattman throwing the item into the bin
//3. More items to choose from and an improved database of questions
