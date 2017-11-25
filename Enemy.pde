class Enemy extends FBox {
  int speed, direction, spriteNE;
  PImage[] currentActionE;

  Enemy(int x, int y) {
    super(x, y);
    speed = size/20;
    direction = -1;

    setDensity(100);
    setStatic(false);
    setGrabbable(false);
    setRotatable(false);
    setFriction(2);

    spriteNE = 0;
    currentActionE = idle;
  }
  void move() {
    adjustPosition(speed*direction, 0);
    if (frameCount % 3 == 0) {
      spriteNE++;
      if (spriteNE == currentActionE.length) {
        spriteNE = 0;
      }
      if (direction == 1) {
        attachImage(reverse(currentActionE[spriteNE]));
      } else {
        attachImage(currentActionE[spriteNE]);
      }
    }
  }
  void Throw() {
    FBox b = new FBox(size/2, size/2);
    b.setPosition(getX(), getY());

    b.setName("hammer");
    hammer.resize(round(size/2), round(size/2));
    b.attachImage(hammer);

    b.setVelocity(400*direction, -400);
    b.setAngularVelocity(75);

    b.setStatic(false);
    b.setGrabbable(false);
    b.setSensor(true);
    b.setFriction(2);

    world.add(b);
  }
}