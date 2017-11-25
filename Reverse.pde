PImage reverse( PImage image ) {
  PImage reverse;
  reverse = createImage(image.width, image.height, ARGB );

  for ( int i=0; i < image.width; i++ ) {
    for (int j=0; j < image.height; j++) {
      int xPixel, yPixel;
      xPixel = image.width - 1 - i;
      yPixel = j;
      reverse.pixels[yPixel*image.width+xPixel]=image.pixels[j*image.width+i] ;
    }
  }
  return reverse;
}

//void printgoomba(String start, int i){
//  println(start);
//  Enemy e = enemies.get(i);
//    if (e.getName().equals("goomba")){
//      println("#" + i + " x=" + e.getX() + " y=" + e.getY() + " d=" + e.direction);
//    }
//}