import fisica.FBox; //<>//
import fisica.*;

import ddf.minim.*;
Minim minim;
AudioPlayer backplayer, coinplayer, dieplayer, jumpplayer, stompplayer;

int INTRO = 0;
int PLAYING = 1;
int PAUSED = 2;
int GAMEOVER = 3;
int mode = INTRO;

int size = 25;

FWorld world;

PImage map;
PImage logo, stone, stoneTop, brick, ice, mario, dounut, Rdounut, qblock, block, spring, door, lava, lavaTop, Tread, TreadL, TreadR, hammer, thwomp, lblock, rblock, flagTop, flag, flagBottom;
PImage[] runR, jump, idle, currentAction, goomba, koopa, shell, broWalk, broThrow, swim;
int spriteN = 0;

boolean rightDown, leftDown, upReleased;

ArrayList<FBody> oddBodies;
ArrayList<FBox> Doors, treads, thwomps, dblocks, strips;
ArrayList<Enemy> enemies;

boolean grounded = false;
boolean icy = false;
boolean wet = false;
int treadD = 1;
int coins = 0;

FBox player;

void setup() {
  fullScreen(FX2D);

  minim = new Minim(this);
  backplayer = minim.loadFile("theme.mp3");
  dieplayer = minim.loadFile("die.mp3");
  coinplayer = minim.loadFile("coin.mp3");
  jumpplayer = minim.loadFile("jump.mp3");
  stompplayer = minim.loadFile("stomp.mp3");

  logo = loadImage ("logo.PNG");
  map = loadImage ("level1.png");
  stone = loadImage("stone.png");
  stoneTop = loadImage("stone top.png");
  brick = loadImage("brick.png");
  ice = loadImage("ice.png");
  mario = loadImage("mario.png");
  qblock = loadImage("qblock.png");
  block = loadImage("block.png");
  dounut = loadImage("dounut.png");
  Rdounut = loadImage("Rdounut.png");
  spring = loadImage("spring.png");
  door = loadImage("door.png");
  lava = loadImage("lava.png");
  lavaTop = loadImage("lava top.png");
  Tread = loadImage("Tread.png");
  TreadL = loadImage("TreadL.png");
  TreadR = loadImage("TreadR.png");
  hammer = loadImage("hammer.png");
  thwomp = loadImage("twomp.png");
  lblock = loadImage("lblock.png");
  rblock = loadImage("rblock.png");
  flagTop = loadImage("flagTop.png");
  flag = loadImage("flag.png");
  flagBottom = loadImage("flagBottom.png");

  runR = Sheet(3, "mario\\Run");
  idle = Sheet(1, "mario\\Idle");
  jump = Sheet(1, "mario\\Jump");
  swim = Sheet(3, "mario\\Swim");
  goomba = Sheet(16, "goomba\\goomba");
  koopa = Sheet(20, "koopa\\koopa");
  shell = Sheet(6, "shell\\shell");
  broWalk = Sheet(17, "broWalk\\broWalk");
  broThrow = Sheet(34, "broThrow\\broThrow");


  currentAction = idle;

  Fisica.init(this);
  world = new FWorld(0, 0, map.width * size, map.height * size);
  world.setGravity(0, 1200);

  rightDown = leftDown = false;
  makeWorld();
  
  textSize(50);
}

void draw() {
  background(255);
  pushMatrix();

  float tx = -player.getX() + width/2;
  float ty = -player.getY() + height/2;

  translate(tx, ty);

  if (mode == INTRO) {
    Intro();
  } else if (mode == PLAYING) {
    Playing();
  } else if (mode == PAUSED) {
    Paused();
  } else if (mode == GAMEOVER) {
    GameOver();
  } else {
    popMatrix();
    background(255, 0, 0);
  }
  if (mode != PLAYING) {
    backplayer.pause();
  }
  fill(0);
  text(coins,100,100);
}

PImage[] Sheet(int Length, String name) {
  PImage[] p = new PImage[Length];
  for (int i = 0; i < Length; i++) {
    String n = String.format("%02d", i+1);
    p[i] = loadImage(name+n+".png");
    p[i].resize(round(size), round(size));
  }
  return(p);
}

void Intro() {
  world.draw();
  popMatrix();
  imageMode(CENTER);
  image(logo, width/2, height/2);
  imageMode(CORNER);
}

void Playing() {
  backplayer.play();
  if (backplayer.position() > backplayer.length()-100) {
    backplayer.play(0);
  }
  if (frameCount % 10 == 0) {
    spriteN++;
    if (spriteN == currentAction.length) {
      spriteN = 0;
    }
    player.attachImage(currentAction[spriteN]);
  }

  if (leftDown) {
    if (grounded) {
      if (currentAction != runR && !wet) {
        currentAction = runR;
        spriteN = 0;
        player.attachImage(currentAction[spriteN]);
      }
      if (icy) {
        player.adjustVelocity(-7, 0);
      } else if (wet) {
        player.adjustVelocity(-52, 0);
      } else {
        if (player.getVelocityX() > -10) {
          player.adjustVelocity(-270, 0);
        } else {
          player.adjustVelocity(-70, 0);
        }
      }
    } else {
      player.adjustVelocity(-7, 0);
    }
  } else if (rightDown) {
    if (grounded) {
      if (currentAction != runR && !wet) {
        currentAction = runR;
        spriteN = 0;
        player.attachImage(currentAction[spriteN]);
      }
      if (icy) {
        player.adjustVelocity(7, 0);
      } else if (wet) {
        player.adjustVelocity(52, 0);
      } else {
        if (player.getVelocityX() < 10) {
          player.adjustVelocity(270, 0);
        } else {
          player.adjustVelocity(70, 0);
        }
      }
    } else {
      player.adjustVelocity(7, 0);
    }
  } else if (grounded) {
    if (currentAction != idle) {
      currentAction=idle;
      spriteN = 0;
      player.attachImage(currentAction[spriteN]);
    }
  } 
  if (currentAction != jump && !grounded && !wet) {
    currentAction = jump;
    spriteN = 0;
    player.attachImage(currentAction[spriteN]);
  }

  if (wet) {
    player.setVelocity(player.getVelocityX()*0.9, player.getVelocityY()*0.9);
    if (currentAction != swim) {
      currentAction = swim;
      spriteN = 0;
      player.attachImage(currentAction[spriteN]);
    }
  }

  handleGround();
  handleEnemies();
  world.draw();
  drawStrips();
  world.step();
  handleOddBodies();
  handleDoors();
  handletreads();
  handleThwomps();
  upReleased = false;
  //world.drawDebug();
  popMatrix();
}

void Paused() {
  world.draw();
  drawStrips();
  popMatrix();
  fill(0, 100);
  rect(0, 0, width, height);
  fill(255);
  text("PAUSED", width/2, height/2);
}
void GameOver() {
  world.draw();
  drawStrips();
  popMatrix();
  fill(0, 100);
  rect(0, 0, width, height);
  fill(255, 0, 0);
  text("GAMEOVER", width/2, height/2);
}

void contactStarted(FContact contact) {
  if (contact.contains("player")) {
  }
}

void contactEnded(FContact contact) {
  FBody other;
  if (contact.contains("player")) {
    if (contact.getBody1().getName() == "player") {
      other = contact.getBody2();
    } else {
      other = contact.getBody1();
    }
    if (player.getY() < other.getY()-size/2) {
      if (contact.contains("dounut")) {
        ((DelayBox)other).timeDroping = false;
        ((DelayBox)other).timeLeft = 60;
      }
    }
  }
}

void handleGround() {
  grounded = false;
  icy = false;
  wet = false;
  FBody b;
  for (int i = 0; i<player.getTouching().size(); i++) {

    b = ((FBody)player.getTouching().get(i));
    if ((b.getName().equals("goomba") || b.getName().equals("koopa") || b.getName().equals("shellM") || b.getName().equals("bro")|| b.getName().equals("hammer")) && player.getY() > b.getY()-size/2) {
      mode = GAMEOVER;
      dieplayer.play(0);
    }
    if (b.getName().equals("lava")||b.getName().equals("twomp")) {
      mode = GAMEOVER;
    }
    if (b.getName().equals("Qblock") && player.getY() > b.getY()+size/2) {
      b.setName("block");
      block.resize(round(size), round(size));
      b.attachImage(block);
      coinplayer.play(0);
      coins++;
    }
    if (b.getName().equals("Dblock") && player.getY() > b.getY()+size/2) {
      treadD *= -1;
      handleDblocks();
      player.adjustPosition(0, -1);
    }
    if (player.getY() < b.getY()-size/2) {
      if (b.getName().equals("dounut")) {
        ((DelayBox)b).timeDroping = true;
      }
    }
    if (b.getName().equals("water")) {
      wet = true;
    }

    if (player.getY() < b.getY()-size/2) {
      grounded = true;
      if (b.getName().equals("ice")) {
        icy = true;
      }
      if (b.getName().equals("goomba") || b.getName().equals("bro")) {
        world.remove(b);
        b.setPosition(0, 0);
        player.adjustVelocity(0, -300);
        player.adjustPosition(0, -1);
        stompplayer.play(0);
      }
      if (b.getName().equals("koopa")||b.getName().equals("shellM")) {
        ((Enemy)b).spriteNE = 0;
        ((Enemy)b).speed = 0;
        b.setName("shellS");
        ((Enemy)b).currentActionE = shell;
        player.setVelocity(0, -300);
        player.adjustPosition(0, -1);
        stompplayer.play(0);
      } else if (b.getName().equals("shellS")) {
        ((Enemy)b).spriteNE = 0;
        ((Enemy)b).speed = size/10;
        b.setName("shellM");
        ((Enemy)b).currentActionE = shell;
        player.setVelocity(0, -300);
        player.adjustPosition(0, -1);
        stompplayer.play(0);
      }
    }
  }
}

void handleOddBodies() {
  for (int i = 0; i<oddBodies.size(); i++) {

    if (oddBodies.get(i) instanceof DelayBox) {

      DelayBox b = ((DelayBox)oddBodies.get(i));
      b.setFill(b.timeLeft * 4);
      if (b.timeDroping) {
        b.timeLeft--;
      }
      if (b.timeLeft<20) {
        Rdounut.resize(round(size), round(size));
        b.attachImage(Rdounut);
      } else {
        dounut.resize(round(size), round(size));
        b.attachImage(dounut);
      }
      if (b.timeLeft<0) {
        b.setStatic(false);
        b.adjustVelocity(0, 100);
      }
    }
  }
}
void handleEnemies() {
  for (int i = 0; i<enemies.size(); i++) {
    boolean done = false;
    Enemy b = enemies.get(i);
    //printgoomba(frameCount + "a",i);
    b.move();
    if (b.getName().equals("bro") &&  frameCount%60 == 0) {
      b.Throw();
    }
    //printgoomba(frameCount + "b",i);
    if (!done) {
      for (int j = 0; j<b.getTouching().size(); j++) {
        FBody other = ((FBody)b.getTouching().get(j));
         //print(other.getName());
        if (b.getName().equals("shellM") && other instanceof Enemy) {
          world.remove(other);
          other.setPosition(-1, -1);
        }
        if (abs(b.getY()-other.getY())<size/5 && other instanceof Enemy){
          b.direction *= -1;
          b.adjustPosition(5*b.direction, 0);
          ((Enemy)other).direction *= -1;
          other.adjustPosition(5*((Enemy)other).direction,0);
          j = 100;
        }
        else if (abs(b.getY()-other.getY())<size/5 && !other.isSensor()) {
          b.direction *= -1;
          b.adjustPosition(5*b.direction, 0);
          j = 100;
        }
      }
    }
    //if (b.getName() == "DEAD") {
    //  b.removeFromWorld();
    //  b.setPosition(0, 0);
    //}
    //printgoomba(frameCount + "c",i);
  }
}
void handleThwomps() {
  for (int i = 0; i<thwomps.size(); i++) {
    FBox b = thwomps.get(i);

    if (abs(b.getX()-player.getX())<size*4) {
      b.setStatic(false);
    }
  }
}
void handletreads() {
  FBody p = new FBox(size, size);
  for (int i = 0; i<treads.size(); i++) {
    FBox t = treads.get(i);
    FBody b = new FBox(size, size);
    for (int j = 0; j<t.getContacts().size(); j++) {
      if (((FContact)t.getContacts().get(j)).getBody1().getName().equals("tread")) {
        b = ((FContact)t.getContacts().get(j)).getBody2();
      } else {
        b = ((FContact)t.getContacts().get(j)).getBody1();
      }
      if (b.getY() < t.getY()-size/2 && p != b) {
        b.adjustPosition(size/20*treadD, 0);
      }
      p=b;
    }
  }
}

void handleDoors() {
  boolean done = false;
  if (upReleased) {
    for (int i = 0; i<Doors.size() && !done; i++) {
      FBox s = Doors.get(i);
      for (int j = 0; j<s.getContacts().size(); j++) {
        if (((FContact)s.getContacts().get(j)).contains(player)) {
          int k = i+1;
          while (!done) {
            if (k >= Doors.size()) {
              k = 0;
            }
            FBox e = Doors.get(k);
            if (s.getName().equals(e.getName())) {
              player.setPosition(e.getX(), e.getY());
              done = true;
            }
            k++;
          }
        }
      }
    }
  }
}

void handleDblocks() {
  for (int i = 0; i<dblocks.size(); i++) {
    if (treadD == 1) {
      dblocks.get(i).attachImage(rblock);
    }
    if (treadD == -1) {
      dblocks.get(i).attachImage(lblock);
    }
  }
}

void drawStrips() {
  for (int i = 0; i<strips.size(); i++) {
    FBox b = strips.get(i);
    if (b.getName().equals("ice")) {
      for (int j = 0; j<b.getWidth(); j+=size) {
        image(ice, (b.getX()-b.getWidth()/2+j), b.getY()-size/2);
      }
    }
    if (b.getName().equals("ground")) {
      for (int j = 0; j<b.getWidth(); j+=size) {
        image(stone, (b.getX()-b.getWidth()/2+j), b.getY()-size/2);
      }
    }
    if (b.getName().equals("groundTop")) {
      for (int j = 0; j<b.getWidth(); j+=size) {
        image(stoneTop, (b.getX()-b.getWidth()/2+j), b.getY()-size/2);
      }
    }
  }
}

void keyPressed() {
  if (keyCode == RIGHT) {
    rightDown = true;
  }
  if (keyCode == LEFT) {
    leftDown = true;
  }
  if (key == ' ') {
    if (grounded) {
      player.adjustVelocity(0, -600);
      jumpplayer.play(0);
      player.adjustPosition(0,-2);
    }
  }
}

void keyReleased() {
  if (keyCode == RIGHT) {
    rightDown = false;
  }
  if (keyCode == LEFT) {
    leftDown = false;
  }
  if (keyCode == UP) {
    upReleased = true;
  }
  if (key == ' ') {
    if (wet) {
      player.adjustVelocity(0, -1000);
    }
  }
}

void mouseReleased() {
  if (mode == PLAYING) {
    mode = PAUSED;
  } else if (mode == PAUSED) {
    mode = PLAYING;
  } else {
    world.clear();
    makeWorld();
    mode = PLAYING;
  }
}
