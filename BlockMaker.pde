void makeWorld() {
  oddBodies = new ArrayList<FBody>(100);
  enemies = new ArrayList<Enemy>(100);
  Doors = new ArrayList<FBox>(100);
  treads = new ArrayList<FBox>(100);
  thwomps = new ArrayList<FBox>(100);
  dblocks = new ArrayList<FBox>(100);
  strips = new ArrayList<FBox>(100);
  makePlayer();
  for (int y=0; y<map.height; y++) {
    for (int x=0; x<map.width; x++) {
      color c = map.get(x, y);
      if (c == color(0) && map.get(x, y-1) == color(0)) {
        if (map.get(x-1, y) != color(0) || map.get(x-1, y-1) != color(0)) {
          int i = 1;
          while (map.get(x+i, y) == color(0) && map.get(x+i, y-1) == color(0)) {
            i++;
          }
          makeStone(x*size, y*size, i, false);
        }
      } else if (c == color(0) && map.get(x, y-1) != color(0)) {
        if (map.get(x-1, y) != color(0) || map.get(x-1, y-1) == color(0)) {
          int i = 1;
          while (map.get(x+i, y) == color(0) && map.get(x, y-1) != color(0)) {
            i++;
          }
          makeStone(x*size, y*size, i, true);
        }
      } else if (c == color(255, 0, 0)) {
        makeBrick(x*size, y*size);
      } else if (c == color(0, 255, 255)) {
        if (map.get(x-1, y) != color(0, 255, 255)) {
          int i = 1;
          while (map.get(x+i, y) == color(0, 255, 255)) {
            i++;
          }
          makeIce(x*size, y*size, i);
        }
      } else if (c == color(127, 0, 0)) {
        makeDounut(x*size, y*size);
      } else if (c == color(150, 75, 0)) {
        makeGoomba(x*size, y*size);
      } else if (c == color(0, 255, 0)) {
        makeKoopa(x*size, y*size);
      } else if (c == color(127, 255, 0)) {
        makeBro(x*size, y*size);
      } else if (c == color(255, 255, 0)) {
        makeQblock(x*size, y*size);
      } else if (c == color(255, 255, 127)) {
        makeDblock(x*size, y*size);
      } else if (c == color(255, 127, 0)) {
        if (map.get(x, y-1) == color(255, 127, 0)) {
          makeLava(x*size, y*size, false);
        } else {
          makeLava(x*size, y*size, true);
        }
      } else if (c == color(127, 127, 0)) {
        makeSpring(x*size, y*size);
      } else if (c == color(0, 0, 127)) {
        if (map.get(x-1, y) != color(0, 0, 127)) {
          makeTread(x*size, y*size, 1);
        } else if (map.get(x+1, y) != color(0, 0, 127)) {
          makeTread(x*size, y*size, 3);
        } else {
          makeTread(x*size, y*size, 2);
        }
      } else if (c == color(127, 127, 127)) {
        makeTwomp(x*size, y*size);
      } else if (c == color(127, 0, 255)) {
        if (map.get(x, y-1) == color(127, 0, 255) && map.get(x, y+1) == color(127, 0, 255)) {
          makeFlag(x*size, y*size, 1);
        } else if (map.get(x, y-1) == color(127, 0, 255)) {
          makeFlag(x*size, y*size, 2);
        } else if (map.get(x, y+1) == color(127, 0, 255)) {
          makeFlag(x*size, y*size, 0);
        }
      } else if (c == color(0, 0, 255)) {
        if (map.get(x-1, y) != color(0, 0, 255)) {
          int i = 1;
          while (map.get(x+i, y) == color(0, 0, 255)) {
            i++;
          }
          makeWater(x*size, y*size, i);
        }
      } else if (c == color(255, 255, 255)) {
      } else {
        makeDoor(x*size, y*size, c);
      }
    }
  }
}

void makePlayer() {
  player = new FBox(size, size);
  player.setPosition(2*size, 5*size); 

  mario.resize(round(size), round(size));
  player.attachImage(mario);

  player.setName("player");

  player.setStatic(false);
  player.setGrabbable(false);
  player.setFriction(5);
  player.setRotatable(false);

  world.add(player);
}

void makeStone(int x, int y, int l, boolean top) {
  FBox b = new FBox(size*l, size);
  b.setPosition(x + size*(l-1)/2, y);

  b.setName("ground");

  stone.resize(round(size), round(size));

  if (top) {
    stoneTop.resize(round(size), round(size));
    b.setName("groundTop");
  }

  b.setStatic(true);
  b.setGrabbable(false);
  b.setFriction(2);

  world.add(b);
  strips.add(b);
}

void makeIce(int x, int y, int l) {
  FBox b = new FBox(size*l, size);
  b.setPosition(x + size*(l-1)/2, y);

  b.setName("ice");
  ice.resize(round(size), round(size));

  b.setStatic(true);
  b.setGrabbable(false);
  b.setFriction(0);

  world.add(b);
  strips.add(b);
}

void makeBrick(int x, int y) {
  FBox b = new FBox(size, size);
  b.setPosition(x, y);

  b.setName("brick");

  brick.resize(round(size), round(size));
  b.attachImage(brick);

  b.setDensity(100);

  b.setGrabbable(false);
  b.setFriction(2);

  world.add(b);
}

void makeDounut(int x, int y) {
  DelayBox b = new DelayBox(size, size);
  b.setPosition(x, y);

  b.timeLeft = 60;
  b.setName("dounut");
  dounut.resize(round(size), round(size));
  b.attachImage(dounut);

  b.setDensity(100);

  b.setStatic(true);
  b.setGrabbable(false);
  b.setFriction(2);

  world.add(b);
  oddBodies.add(b);
}

void makeGoomba(int x, int y) {
  Enemy b = new Enemy(size, size);
  b.setPosition(x, y);

  b.setName("goomba");
  b.currentActionE = goomba;

  world.add(b);
  enemies.add(b);
}

void makeKoopa(int x, int y) {
  Enemy b = new Enemy(size, size);
  b.setPosition(x, y);

  b.setName("koopa");
  b.currentActionE = koopa;

  world.add(b);
  enemies.add(b);
}

void makeBro(int x, int y) {
  Enemy b = new Enemy(size, size);
  b.setPosition(x, y);

  b.setName("bro");
  hammer.resize(round(size), round(size));
  b.currentActionE = broWalk;


  world.add(b);
  enemies.add(b);
}

void makeTwomp(int x, int y) {
  FBox b = new FBox(size, size);
  b.setPosition(x, y);

  b.setName("twomp");

  thwomp.resize(round(size), round(size));
  b.attachImage(thwomp);

  b.setStatic(true);
  b.setGrabbable(false);
  b.setFriction(2);

  world.add(b);
  thwomps.add(b);
}


void makeLava(int x, int y, boolean top) {
  FBox b = new FBox(size, size);
  b.setPosition(x, y);

  b.setName("lava");
  lava.resize(round(size), round(size));
  b.attachImage(lava);

  if (top) {
    lavaTop.resize(round(size), round(size));
    b.attachImage(lavaTop);
  }

  b.setDensity(100);

  b.setStatic(true);
  b.setGrabbable(false);
  b.setFriction(2);

  world.add(b);
}

void makeTread(int x, int y, int v) {
  FBox b = new FBox(size, size);
  b.setPosition(x, y);

  b.setName("tread");
  Tread.resize(round(size), round(size));
  b.attachImage(Tread);

  if (v==1) {
    TreadL.resize(round(size), round(size));
    b.attachImage(TreadL);
  }
  if (v==3) {
    TreadR.resize(round(size), round(size));
    b.attachImage(TreadR);
  }

  b.setDensity(100);

  b.setStatic(true);
  b.setGrabbable(false);
  b.setFriction(2);

  world.add(b);
  treads.add(b);
}

void makeQblock(int x, int y) {
  FBox b = new FBox(size, size);
  b.setPosition(x, y);

  b.setName("Qblock");

  qblock.resize(round(size), round(size));
  b.attachImage(qblock);

  b.setStatic(true);
  b.setGrabbable(false);
  b.setFriction(2);

  world.add(b);
}

void makeDblock(int x, int y) {
  FBox b = new FBox(size, size);
  b.setPosition(x, y);

  b.setName("Dblock");

  lblock.resize(round(size), round(size));
  rblock.resize(round(size), round(size));
  b.attachImage(rblock);

  b.setStatic(true);
  b.setGrabbable(false);
  b.setFriction(2);

  world.add(b);
  dblocks.add(b);
}

void makeDoor(int x, int y, color c) {
  FBox b = new FBox(size, size);
  b.setPosition(x, y);
  String s = hex(c);
  b.setName(s);

  door.resize(round(size), round(size));
  b.attachImage(door);

  b.setSensor(true);
  b.setStatic(true);

  world.add(b);
  Doors.add(b);
}

void makeSpring(int x, int y) {
  FBox b = new FBox(size, size);
  b.setPosition(x, y);

  b.setName("spring");

  spring.resize(round(size), round(size));
  b.attachImage(spring);

  b.setDensity(100);
  b.setRestitution(0.75);

  b.setGrabbable(false);
  b.setFriction(2);

  world.add(b);
}

void makeWater(int x, int y, int l) {
  FBox b = new FBox(size*l, size);
  b.setPosition(x + size*(l-1)/2, y);
  b.setName("water");

  b.setFill(0, 0, 255, 100);
  b.setNoStroke();
  b.setSensor(true);
  b.setStatic(true);

  world.add(b);
}

void makeFlag(int x, int y, int position) {
  FBox b = new FBox(size, size);
  b.setPosition(x, y);

  b.setName("flag");

  if (position == 0) {
    flagTop.resize(round(size), round(size));
    b.attachImage(flagTop);
  } else if (position == 1) {
    flag.resize(round(size), round(size));
    b.attachImage(flag);
  } else if (position == 2) {
    flagBottom.resize(round(size), round(size));
    b.attachImage(flagBottom);
  }

  b.setDensity(100);

  b.setStatic(true);
  b.setGrabbable(false);
  b.setFriction(2);

  world.add(b);
}