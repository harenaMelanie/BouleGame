Box[] boxes;
float playerX, playerY, speedX, speedY, speed;
String mode, loseCause;
PFont font;
float score, highscore;
//vitesse de mouvement spécifique à la direction gauche et à droite
float leftDirectionSpeed =2; 
float rightDirectionSpeed =2; 


void setup() {
  size(400, 400, P3D);
  playerX = width / 2;
  playerY = height / 1.4f;
  speedX = 0;
  speedY = 0;
  speed = 5;
  mode = "gameMode";
  //Font
  font = createFont("LoveYaLikeASister-Regular.ttf", 32);
  loseCause = null;
  score = 0;
  boxes = new Box[4];
  highscore = 0;
  for (int j = 0; j < 4; j++) {
    boxes[j] = new Box();
  }
}

void draw() {
  background(60);
  textFont(font);
  translate(width / 2, height / 2);
  if (mode.equals("gameMode")) {
    player();
    platforms();
    for (int i = 0; i < boxes.length; i++) {
      boxes[i].show();
      boxes[i].update();
    }
  } else if (mode.equals("loseMode")) {
    loseScreen(loseCause);
  }
}

void keyPressed() {
  if (key == 'a' || key == 'A') {
    speedX = -speed;
  } else if (key == 'd' || key == 'D') {
    speedX = speed;
  } else if (keyCode == LEFT) {
    speedX = -leftDirectionSpeed;
  } else if (keyCode == RIGHT) {
    speedX = rightDirectionSpeed; 
  }
}

void keyReleased() {
  if (key == 'a' || key == 'A') {
    if (keyCode == LEFT) {
      // Réinitialisez speedX à 0 lorsque la touche gauche est relâchée
      speedX = 0; 
    }
  } else if (key == 'd' || key == 'D') {
    if (keyCode == RIGHT) {
      speedX = 0; // Réinitialisez speedX à 0 lorsque la touche droite est relâchée
    }
  }
}


void platforms() {
  pushMatrix();
  translate(0, height - 250, 0);
  fill(0, 255, 0);
  box(width, height / 6, 1000000);
  popMatrix();

  pushMatrix();
  translate(0, 0);
  fill(0, 255, 0);
  textSize(50);
  text(int(score), -10, -(height / 4));
  popMatrix();
  score += 0.01;
}

void player() {
  pushMatrix();
  translate(-(width / 2), -(height / 2));
  translate(playerX, playerY);
  fill(255, 255, 0);
  rotateX(frameCount * 0.1f);
  sphere(30);
  popMatrix();
  playerX += speedX;
  playerY += speedY;
  if (playerX < 0 || playerX > width) {
    mode = "loseMode";
    loseCause = "You fell off the edge.";
    playerX = width / 2;
    playerY = height / 1.4f;
  }
}

void loseScreen(String label) {
  if (score >= highscore) {
    highscore = score;
  }

  float y = -(height / 2);
  pushMatrix();
  fill(0);
  rect(-(width / 2), y, width, height);
  fill(255, 0, 0);
  textSize(50);
  textAlign(CENTER, CENTER);
  text("You Lose!", 0, y + 100);
  textSize(25);
  text(label, 0, y + 150);
  text("Your score was " + int(score) + ".", 0, y + 180);
  text("Your highscore is " + int(highscore) + ".", 0, y + 210);
  text("Click to try again", 0, y + 240);
  popMatrix();
  if (mousePressed) {
    mode = "gameMode";
    for (int i = 0; i < boxes.length; i++) {
      boxes[i].reset();
    }
    score = 0;
  }
}

class Box {
  float boxX, boxY, boxZ;
  float speedY, speedZ;
  String boxType;
  int clr;

  Box() {
    reset();
  }

  void show() {
    pushMatrix();
    translate(boxX, boxY, boxZ);
    fill(clr);
    box(50);
    popMatrix();
  }

  void update() {
    boxY += speedY;
    boxZ += speedZ;
    if (boxZ > 500) {
      reset();
      return;
    }
    boolean playerHitPlat = rectRect(
      boxX - 25,
      height - 330,
      50,
      50,
      -(width / 2) + playerX - 30,
      -(width / 2) + playerY - 30,
      60,
      60
    );

    if (boxZ >= 0 && playerHitPlat) {
      switch (boxType) {
        case "bad":
          mode = "loseMode";
          loseCause = "You hit an obstacle.";
          playerX = width / 2;
          playerY = height / 1.4f;
          break;
        case "good":
          speedY -= 10;
          score += 1;
          break;
      }
    }
  }

  void reset() {
    boxX = random(-(width / 2), width / 2);
    boxZ = -10000;
    boxY = height - 300;
    speedY = 0;
    speedZ = random(50, 150);
    boxType = random(5) > 3 ? "good" : "bad";
    clr = boxType.equals("good") ? color(0, 0, 255) : color(255, 0, 0);
  }
}

boolean rectRect(float r1x, float r1y, float r1w, float r1h, float r2x, float r2y, float r2w, float r2h) {
  return (
    r1x + r1w >= r2x && r1x <= r2x + r2w && r1y + r1h >= r2y && r1y <= r2y + r2h
  );
}
