/*
Abby Floyd
11/1/2020
Final Project - 2020 themed classic video games
*/
 
int mainMenu = 0;
boolean resetButton = false;

 // Pacman variables
final int NUM_POSITIONS=361;
final int NUM_VIRUSES=8;
final int NUM_VACCINES=5;
ArrayList<Pos> positions = new ArrayList<Pos>();
ArrayList<Integer> type = new ArrayList<Integer>();
ArrayList<Pos> virusPositions = new ArrayList<Pos>();
ArrayList<Integer> directions = new ArrayList<Integer>();
boolean immunity = false;
int immunityCounter = 0;
int x = 40;
int y = 40;
int points = 0;
boolean collide = false;
 
 // Space Invaders variables
final int NUM_FIRE_COLUMNS=20;
final int NUM_FIRE_ROWS=15;
ArrayList<Pos> firePositions = new ArrayList<Pos>();
ArrayList<Pos> shoot = new ArrayList<Pos>();
ArrayList <Pos> water = new ArrayList<Pos>();
int x2=380;
int y2=700;
int code = 0;
boolean waterDone=false;
boolean waterGo=false;
ArrayList<Pos> lastRow = new ArrayList<Pos>();
boolean noFire = false;
int speed = 2;
int speed2 = 5;
int side1 = 50;
int side2 = 750;
int health = 5;
int waterPoints=0;
boolean gameOver = false;
 
 // Pong variables
float bidenX = 100;
float trumpX = 630;
float bidenY = 350;
float trumpY = 350;
float ballX = 400;
float ballY = 400;
int ballSpeedX=2;
int ballSpeedY=0;
int trumpPoints=0;
int bidenPoints=0; 
int code2 = 0;
int code3 = 0;
boolean pongOver=false;
color ballColor;

void setup()
{
  // Setup intial positions for PacMan and Space Invaders
  size(800, 800);
  for (int i=1; i<20; i++)
  {
    for (int j=1; j<20; j++)
    {
      Pos position = new Pos(i*40, j*40);
      positions.add(position);
    }
  }
  for (int i=0; i<NUM_POSITIONS; i++)
  {
    int a = (int)random(3);
    type.add(a);
  }
  for (int i=0; i<NUM_VIRUSES; i++)
  {
    int virusX = (int)random(1, 20);
    int virusY = (int)random(1, 20);
    virusX *= 40;
    virusY *= 40;
    Pos virus = new Pos(virusX, virusY);
    virusPositions.add(virus);
    int direction = (int)random(4);
    directions.add(direction);
  }
  for (int i=0; i<NUM_VACCINES; i++)
  {
    int position = (int)random(NUM_POSITIONS);
    type.remove(positions);
    type.add(position, 4);
  }
  for (int i=100; i<700; i+=30)
  {
    for (int j=30; j<480; j+=30)
    {
      Pos position = new Pos(i,j);
      firePositions.add(position);
    }
  }
  ballColor=color((#0061E5));
}

void draw()
{
  background(0);
  // if no menu choice, show menu
  if (mainMenu==0)
  {
    showMenu();
    showInstructions();
    //if menu choice is 1, play Pac-Man
  } else if (mainMenu==1)
  {
    drawBoard();
    drawPacman(x, y);
    if (collide)
    {
      showFinalScore();
      showResetButton();
    } else
    {
      if (keyCode == UP)
      {
        y--;
        if (y<=0)
        {
          keyCode=DOWN;
        }
      } else if (keyCode == DOWN)
      {
        y++;
        if (y>=height)
        {
          keyCode=UP;
        }
      } else if (keyCode == RIGHT)
      {
        x++;
        if (x>=width)
        {
          keyCode=LEFT;
        }
      } else if (keyCode == LEFT)
      {
        x--;
        if (x<=0)
        {
          keyCode=RIGHT;
        }
      }
      collect();
    }
    showPoints();
    drawViruses();
    if (immunity)
    {
      immunityCounter++;
      if (immunityCounter==600)
      {
        immunity=false;
        immunityCounter=0;
      }
    }
    // if menu choice is 2, play Space Invaders
  } else if (mainMenu==2)
  {
    fireBoard();
    drawFireMan(x2, y2);
    if (keyCode==LEFT)
    {
      x2-=4;
      code=1;
    } else if (keyCode==RIGHT)
    {
      x2+=4;
      code=2;
    } else if (key==' ')
    { 
      Pos currentPos = new Pos(x2+26, y2);
      water.add(currentPos);
      if (code==1)
      {
        keyCode = LEFT;
      } else if (code==2)
      {
        keyCode = RIGHT;
      }
      key='x';
    }
    if (x2<=0)
    {
      keyCode=RIGHT;
    } else if (x2>=width-60)
    {
      keyCode=LEFT;
    }
    shootWater(x2, y2);
    int ran1 = (int)random(10);
    if (ran1==1)
    {
      int ran2 = (int)random(firePositions.size());
      Pos position = firePositions.get(ran2);
      shoot.add(position);
    }
    for (int i=0; i<shoot.size(); i++)
    {
      float xPos = shoot.get(i).getX();
      float yPos = shoot.get(i).getY();
      drawFireBall(xPos, yPos);
      boolean healthDown=false;
      if (xPos>=x2+6 && xPos<=x2+46 && yPos>=y2+6 && yPos<=y2+46)
      {
        health--;
        if (health==-1)
        {
          gameOver=true;
        }
        healthDown=true;
      }
      if (yPos<800 && healthDown==false)
      {
        yPos+=10;
        Pos newPosition = new Pos(xPos, yPos);
        shoot.remove(i);
        shoot.add(i, newPosition);
      } else if (healthDown)
      {
        shoot.remove(i);
      }
    }
    move(y2, x2);
    showHealth();
    showWaterPoints();
    if (gameOver)
    {
      gameOver();
      showResetButton();
    }
    // if menu choice is 3, play Pong
  } else if (mainMenu==3)
  {
    drawMiddleLine();
    drawBiden(bidenX, bidenY);
    drawTrump(trumpX, trumpY);
    ballMove();
    hitTrump();
    hitBiden();
    hitWalls();
    showPongPoints();
    if (pongOver)
    {
      showResetButton();
    }
    if (keyCode==UP)
    {
      trumpY-=2;
      if (trumpY==0)
      {
        keyCode=DOWN;
      }
    } else if (keyCode==DOWN)
    {
      trumpY+=2;
      if (trumpY==height)
      {
        keyCode=UP;
      }
    }
    if (key=='w')
    {
      bidenY-=2;
      if (bidenY==0)
      {
        key='s';
      }
    } else if (key=='s')
    {
      bidenY+=2;
      if (bidenY==height)
      {
        key='w';
      }
    }
  }
}

void showMenu()
{
  strokeWeight(1);
  rectMode(CORNER);
  PFont mono;
  mono = createFont("ARCADECLASSIC.TTF", 40);
  textFont(mono);
  fill(#FF0004);
  text("WELCOME    TO    2020    GAMES", 180, 100); 
  fill(255);
  mono = createFont("ARCADECLASSIC.TTF", 25);
  textFont(mono);
  text("PICK    A    GAME", 315, 130); 
  stroke(#FF0004);
  fill(0);
  rect(250,150,280,50);
  fill(#FF0004);
  mono = createFont("ARCADECLASSIC.TTF", 35);
  textFont(mono);
  text("COVID    PACMAN", 278, 185); 
  stroke(#FF0004);
  fill(0);
  rect(220,230,344,50);
  fill(#FF0004);
  mono = createFont("ARCADECLASSIC.TTF", 35);
  textFont(mono);
  text("WILDFIRE    INVADERS", 232, 265); 
  stroke(#FF0004);
  fill(0);
  rect(251,310,280,50);
  fill(#FF0004);
  text("ELECTION    PONG", 267, 345); 
}

void mouseClicked()
{
  if (mainMenu==0)
  {
    // If user picks Pac-Man
    if (mouseX>=250 && mouseX<=520 && mouseY>=150 && mouseY<=200)
    {
      mainMenu=1;
      // If user picks Fire Invaders
    } else if (mouseX>=220 && mouseX<=564 && mouseY>=230 && mouseY<=280)
    {
      mainMenu=2;
      // If user picks Pong
    } else if (mouseX>=251  && mouseX<=531 && mouseY>=310 && mouseY<=360)
    {
      mainMenu=3;
    }
  }
  // If user clicks reset after a game, take them back to home screen
  if (resetButton)
  {
    if (mouseX>=200 & mouseX<=600 & mouseY>=600 & mouseY<=645)
    {
      mainMenu=0;
      reset();
      resetButton=false;
    }
  }
}

// Show instructions for games when hovered over titles
void showInstructions()
{
  if (mouseX>=250 && mouseX<=520 && mouseY>=150 && mouseY<=200)
  {
    fill(#FF0004);
    PFont mono = createFont("ARCADECLASSIC.TTF", 20);
    textFont(mono);
    text("Control    the    COVID    PacMan    using    the    arrow    keys", 150, 500); 
    text("Avoid    the    viruses   and    eat    to    gain    points", 173, 540); 
    text("Toilet     paper    is    5    points", 250, 580);
    text("Hand     sanitizer    is    10    points", 240, 620); 
    text("Lysol     wipes    are    15    points", 250, 660); 
    text("Collect     a     vaccine     for     10     seconds     of     virus     immunity", 120, 700); 
  } else if (mouseX>=220 && mouseX<=564 && mouseY>=230 && mouseY<=280)
  {
    fill(#FF0004);
    PFont mono = createFont("ARCADECLASSIC.TTF", 20);
    textFont(mono);
    text("Avoid      the     shooting     fire", 260, 500); 
    text("Move     fireman     using     left     right     arrows", 190, 540); 
    text("Shoot     water     using     space     bar", 240, 580);
    text("You     begin     with     5     lives", 265, 620); 
    text("Minus     one     life     each     time     you     get     hit", 193, 660); 
  } else if (mouseX>=251  && mouseX<=531 && mouseY>=310 && mouseY<=360)
  {
    fill(#FF0004);
    PFont mono = createFont("ARCADECLASSIC.TTF", 20);
    textFont(mono);
    text("Control      Joe      Biden      using      W      and      S      keys", 185, 500); 
    text("Control      Donald      Trump      using      up      and      down      arrows", 140, 540); 
    text("Move      ball      past      opponent      to      gain      1      vote", 180, 580);
    text("First      candidate      to      reach      5      votes      wins", 187, 620); 
  }
  
}

// Reset all the games
void reset()
{
  // Pacman variables
  positions.clear();
  type.clear();
  virusPositions.clear();
  directions.clear();
  immunity = false;
  immunityCounter = 0;
  x = 40;
  y = 40;
  points = 0;
  collide = false;
   
  // Space Invaders variables
  firePositions.clear();
  shoot.clear();
  water.clear();
  x2=380;
  y2=700;
  code = 0;
  waterDone=false;
  waterGo=false;
  lastRow.clear();
  noFire = false;
  speed = 2;
  speed2 = 5;
  side1 = 50;
  side2 = 750;
  health = 5;
  waterPoints=0;
  gameOver = false;
   
  // Pong variables
  bidenX = 100;
  trumpX = 630;
  bidenY = 350;
  trumpY = 350;
  ballX = 400;
  ballY = 400;
  ballSpeedX=2;
  ballSpeedY=0;
  trumpPoints=0;
  bidenPoints=0; 
  code2 = 0;
  code3 = 0;
  pongOver=false;
  
  // Re-setup Pac-Man and Fire Invaders initial positions 
  for (int i=1; i<20; i++)
  {
    for (int j=1; j<20; j++)
    {
      Pos position = new Pos(i*40, j*40);
      positions.add(position);
    }
  }
  for (int i=0; i<NUM_POSITIONS; i++)
  {
    int a = (int)random(3);
    type.add(a);
  }
  for (int i=0; i<NUM_VIRUSES; i++)
  {
    int virusX = (int)random(1, 20);
    int virusY = (int)random(1, 20);
    virusX *= 40;
    virusY *= 40;
    Pos virus = new Pos(virusX, virusY);
    virusPositions.add(virus);
    int direction = (int)random(4);
    directions.add(direction);
  }
  for (int i=0; i<NUM_VACCINES; i++)
  {
    int position = (int)random(NUM_POSITIONS);
    type.remove(positions);
    type.add(position, 4);
  }
  for (int i=100; i<700; i+=30)
  {
    for (int j=30; j<480; j+=30)
    {
      Pos position = new Pos(i,j);
      firePositions.add(position);
    }
  }
}

// Show reset button when game is over
void showResetButton()
{
  fill(0);
  stroke(#FF0004);
  rectMode(CORNER);
  rect(200,600,400,45);
  fill(#FF0004);
  PFont mono = createFont("ARCADECLASSIC.TTF", 35);
  textFont(mono);
  text("BACK    TO    MAIN     MENU", 235, 633);
  resetButton=true;
}

//PONG FUNCTIONS: 

// Show number of pong points, show winner if either candidate gets to 5
void showPongPoints()
{
  int x1 = 310;
  int x2 = 450;
  for (int i=0; i<bidenPoints; i++)
  {
    PImage img1 = loadImage("ballot2.png");
    image(img1, x1, 30, 40, 40);
    x1-=50;
  }
  if (bidenPoints==5)
  {
    fill(0);
    stroke(#FF0004);
    rect(290,370,220,45);
    fill(#FF0004);
    PFont mono = createFont("ARCADECLASSIC.TTF", 35);
    textFont(mono);
    text("BIDEN    WINS", 307, 405); 
    ballSpeedX=0;
    ballSpeedY=0;
    pongOver=true;
    
  } else if (trumpPoints==5)
  {
    fill(0);
    stroke(#FF0004);
    rect(290,370,220,45);
    fill(#FF0004);
    PFont mono = createFont("ARCADECLASSIC.TTF", 35);
    textFont(mono);
    text("TRUMP    WINS", 307, 405); 
    ballSpeedX=0;
    ballSpeedY=0;
    pongOver=true;
  }
  for (int i=0; i<trumpPoints; i++)
  {
    PImage img1 = loadImage("ballot2.png");
    image(img1, x2, 30, 40, 40);
    x2+=50;
  }
}

// Reverse speed of ball if it hits ceiling or floor, give points if it hits either side
void hitWalls()
{
  if (ballY<=0 || ballY>=height)
  {
    ballSpeedY*=-1;
  }
  if (ballX<=10)
  {
    trumpPoints+=1;
    ballColor = color(#E51300);
    ballX=400;
    ballY=400;
    ballSpeedX=2;
    ballSpeedY=0;
    ballMove();
  } else if (ballX>=width)
  {
    bidenPoints+=1;
    ballColor=color(#0061E5);
    ballX=400;
    ballY=400;
    ballSpeedX=-2;
    ballSpeedY=0;
    ballMove();
  }
}

// If the ball hits Trump, reverse the x speed and change the y speed depending on where it hit
void hitTrump()
{
  if (ballX==trumpX+20 && ballY>=trumpY && ballY<=trumpY+78)
  {
    ballSpeedX*=-1;
    ballColor = color(#E51300);
    float dist = trumpY-ballY; 
    dist*=-1;
    if (dist>37.5)
    {
      if (dist>=18.75)
      {
        if (dist>=28.45)
        {
          ballSpeedY-=1;
        } else
        {
          ballSpeedY-=.75;
        }
      } else
      { 
        if (dist>=9.05)
        {
          ballSpeedY-=.5;
        } else 
        {
          ballSpeedY-=.25;
        }
      }
    } else if(dist<35.7)
    {
      if (dist<=18.75)
      {
        if (dist<=9.7)
        {
          ballSpeedY+=.25;
        } else 
        {
          ballSpeedY+=.5;
        }
      } else 
      {
        if (dist <= 28.45)
        {
          ballSpeedY+=.75;
        } else
        {
          ballSpeedY+=1;
        }
      }
    }
  }
}

// If the ball hits Biden, reverse the x speed and change the y speed depending on where it hit
void hitBiden()
{
  if (ballX==bidenX+40 && ballY>=bidenY && ballY<=bidenY+80)
  {
    ballSpeedX*=-1;
    ballColor = color(#0061E5);
    float dist = bidenY-ballY; 
    dist*=-1;
    if (dist>37.5)
    {
      if (dist>=18.75)
      {
        if (dist>=28.45)
        {
          ballSpeedY-=1;
        } else
        {
          ballSpeedY-=.75;
        }
      } else
      { 
        if (dist>=9.05)
        {
          ballSpeedY-=.5;
        } else 
        {
          ballSpeedY-=.25;
        }
      }
    } else if(dist<35.7)
    {
      if (dist<=18.75)
      {
        if (dist<=9.7)
        {
          ballSpeedY+=.25;
        } else 
        {
          ballSpeedY+=.5;
        }
      } else 
      {
        if (dist <= 28.45)
        {
          ballSpeedY+=.75;
        } else
        {
          ballSpeedY+=1;
        }
      }
    }
  }
}

// Move the ball 
void ballMove()
{
  float x  = ballX+=ballSpeedX;
  float y  = ballY+=ballSpeedY;
  drawBall(x,y,ballColor);
}

// Draw the ball 
void drawBall(float x, float y, color c)
{
  stroke(c);
  fill(c);
  circle(x,y,30);
}

// Draw middle line
void drawMiddleLine()
{
  stroke(#0F55DB);
  line(width/2,0,width/2,height);
}

// Draw Biden
void drawBiden(float x, float y)
{
  PImage img1 = loadImage("joe.png");
  image(img1, x, y, 60, 80);
}

// Draw Trump
void drawTrump(float x, float y)
{
  PImage img1 = loadImage("trump.png");
  image(img1, x, y, 78, 78);
}

// FIRE INVADERS FUNCTIONS:

// Shoot water from fireman, add new water drop to array of current water drops and draw each one at curernt position
void shootWater(float x, float y)
{
  for (int i=0; i<water.size(); i++)
  {
    float xPos = water.get(i).getX();
    float yPos = water.get(i).getY();
    drawWater(xPos, yPos);
    if (yPos>=0)
    {
      yPos -= 10;
      Pos newPos = new Pos(xPos, yPos);
      water.remove(i);
      water.add(i, newPos);
    } else 
    {
      water.remove(i);
    }
    if (collide(xPos,yPos))
    {
      water.remove(i);
    }
  }
}

// Show points when game is over
void gameOver()
{
  fill(0);
  stroke(#FF0004);
  rect(290,300,220,90);
  fill(#FF0004);
  PFont mono = createFont("ARCADECLASSIC.TTF", 35);
  textFont(mono);
  text("GAME    OVER", 314, 340); 
  String points = waterPoints + "     POINTS";
  text(points, 310, 370); 
}

// Show current points
void showWaterPoints()
{
  PFont mono = createFont("ARCADECLASSIC.TTF", 30);
  textFont(mono);
  text("POINTS",660,760); 
  text(waterPoints,660,785); 
}

// Show current health
void showHealth()
{
  PFont mono = createFont("ARCADECLASSIC.TTF", 30);
  textFont(mono);
  text("HEALTH", 20,760); 
  int x=20;
  for (int i=0; i<health; i++)
  {
    PImage img1 = loadImage("heart.png");
    image(img1, x, 770, 20, 20);
    x+=25;
  }
}

// Move the fireman
void move(float y, float x)
{
  for (int i=0; i<firePositions.size(); i++)
   {
     float xPos = firePositions.get(i).getX();
     float yPos = firePositions.get(i).getY();
     xPos+=speed;
     Pos newPos = new Pos(xPos, yPos);
     firePositions.remove(i);
     firePositions.add(i, newPos);
     if (yPos>=y && xPos==x)
     {
       gameOver=true;
     }
   }
   side1+=speed;
   side2+=speed;
   if (side2>=800 || side1<=0)
   {
     speed*=-1;
     goDown();
   }
}

// Consistently move fires down the screen throughout the game
void goDown()
{
  for (int i=0; i<firePositions.size(); i++)
  {
    float xPos = firePositions.get(i).getX();
    float yPos = firePositions.get(i).getY();
    yPos+=speed2;
    Pos newPosition = new Pos(xPos,yPos);
    firePositions.remove(i);
    firePositions.add(i, newPosition);
  }
}

// Shoot fireball from random fires
void fireShoot()
{
  lastRow.clear();
  for (int i=0; i<firePositions.size(); i++)
  {
    int randomInt = (int)random(10);
    if (randomInt==1)
    {
      lastRow.add(firePositions.get(i));
    }
  }
}

// Tests to see if water has hit a fire, returns true if collision is detected, false otherwise
boolean collide(float x, float y)
{
  for (int i=0; i<firePositions.size(); i++)
  {
    Pos position = firePositions.get(i);
    float xPos = position.getX();
    float yPos = position.getY();
    if (x>=xPos-10 && x<=xPos+10 && y>=yPos-10 && y<=yPos+10 && gameOver==false)
    {
      firePositions.remove(i);
      waterPoints+=5;
      return true;
    }
  }
  return false;
}

// Draw the fires
void drawFire(float x, float y)
{
  PImage img1 = loadImage("fire.png");
  image(img1, x, y, 20, 20);
}

// Draw the fireman
void drawFireMan(float x, float y)
{
   PImage img1 = loadImage("firehat.png");
   image(img1, x, y, 70, 70);
}

// Draw a fireball
void drawFireBall(float x, float y)
{
  PImage img1 = loadImage("fireball.png");
  image(img1, x, y, 20, 20);
}

// Draw a water droplet
void drawWater(float x, float y)
{
  PImage img1 = loadImage("water.png");
  image(img1, x, y, 15, 20);
}

// draw rows of fire
void fireBoard()
{
  for (int i=0; i<firePositions.size(); i++)
  {
    Pos position = firePositions.get(i);
    float xPos = position.getX();
    float yPos = position.getY();
    drawFire(xPos, yPos);
  }
}

// PAC-MAN FUNCTIONS

// Show final score once game is over
void showFinalScore()
{
  fill(0);
  rectMode(CENTER);
  rect(400, 400, 200, 80);
  fill(#F50000);
  PFont mono;
  PFont mono2;
  mono = createFont("PAC-FONT.TTF", 20);
  mono2 = createFont("crackman.ttf", 40);
  textFont(mono);
  text("FINAL SCORE:", 305, 390); 
  textFont(mono2);
  String pointLine = "" + points;
  text(pointLine, 375, 430);
}

// Draw the viruses, test if the viruses have collided with pac-man, randomize directiosn of viruses, and reverse speed when they hit walls
void drawViruses()
{
  for (int i=0; i<NUM_VIRUSES; i++)
  {
    Pos virus = virusPositions.get(i);
    float virusX = virus.getX();
    float virusY = virus.getY();
    drawVirus(virusX, virusY);
    if (x>=virusX-5 && x<=virusX+5 && y>=virusY-5 && y<=virusY+5 && immunity==false)
    {
      collide=true;
    }
    int direction = directions.get(i);
    if (direction==0)
    {
      virusX+=2; 
    } else if (direction==1)
    {
      virusX-=2;
    } else if (direction==2)
    {
      virusY-=2;
    } else if (direction==3)
    {
      virusY+=2;
    }
    int newDirection = (int)random(16);
    if ((newDirection==0 || newDirection==1 || newDirection==2 || newDirection==3) && virusX%40==0 && virusY%40==0)
    {
      directions.remove(i);
      directions.add(i,newDirection);
    }
    Pos newPosition = new Pos(virusX,virusY);
    virusPositions.remove(i);
    virusPositions.add(i, newPosition);
    if (virusX==0)
    {
      directions.remove(i);
      directions.add(i,0);
    } else if (virusX==width)
    {
      directions.remove(i);
      directions.add(i,1);
    } else if (virusY==0)
    {
      directions.remove(i);
      directions.add(i,3);
    } else if (virusY==height)
    {
      directions.remove(i);
      directions.add(i,2);
    }
  }
}

// Show current points 
void showPoints()
{
  fill(0);
  rectMode(CORNER);
  rect(580, 20, 200, 35);
  fill(#F50000);
  PFont mono;
  PFont mono2;
  mono = createFont("PAC-FONT.TTF", 20);
  mono2 = createFont("crackman.ttf", 30);
  textFont(mono);
  text("POINTS:", 592, 44); 
  textFont(mono2);
  String pointLine = "" + points;
  text(pointLine, 705, 46);
}

// Check if Pac-Man has collided with items, adjust points if it has, remove eaten items
void collect()
{
  for (int i=0; i<NUM_POSITIONS; i++)
  {
    Pos position = positions.get(i);
    float a = position.getX();
    float b = position.getY();
    if (x>=a-5 && x<=a+5 && y>=b-5 && y<=b+5)
    {
      if (type.get(i)==0)
      {
        points+=1;
      } else if (type.get(i)==1)
      {
        points+=10;
      } else if (type.get(i)==2)
      {
        points+=5;
      } else if (type.get(i)==4)
      {
        immunity=true;
      }
      type.remove(i);
      type.add(i, 3);
    }
  }
}

// Draw board of food items
void drawBoard()
{
  for (int i=0; i<NUM_POSITIONS; i++)
  {
    Pos position = positions.get(i);
    float x = position.getX();
    float y = position.getY();
    int a = type.get(i);
    if (a==0)
    {
      drawToiletPaper(x, y);
    } else if (a==1)
    {
      drawClorox(x, y);
    } else if (a==2)
    {
      drawHandSanitizer(x, y);
    } else if (a==4)
    {
      drawVaccine(x,y);
    }
  }
}

// Draw a virus
void drawVirus(float x, float y)
{
  fill(#45A705);
  noStroke();
  circle(x, y-2, 25);
  stroke(#45A705);
  strokeWeight(4);
  line(x-25, y-2, x+25, y-2);
  line(x, y-27, x, y+27);
  line(x-15, y+13, x+15, y-13);
  line(x+15, y+13, x-15, y-13);
}

// Draw a toilet paper
void drawToiletPaper(float x, float y)
{
  noStroke();
  fill(255);
  rectMode(CENTER);
  square(x, y, 15);
  ellipseMode(CENTER);
  ellipse(x, y-11, 15, 4);
  fill(0);
  ellipse(x, y-11, 9, 2);
}

// Draw a Clorox tub
void drawClorox(float x, float y)
{
  noStroke();
  rectMode(CENTER);
  fill(255);
  rect(x, y, 10, 20, 3);
  fill(#E0D129);
  rect(x, y, 10, 14, 3);
  rect(x, y-12, 10, 3, 3);
}

// Draw hand sanitizer
void drawHandSanitizer(float x, float y)
{
  noStroke();
  rectMode(CORNER);
  fill(#B5C5D8);
  rect(x-5, y-7, 8, 17, 3);
  rect(x-4, y-10, 6, 3);
  rect(x-2, y-15, 2, 5, 3);
  rect(x-2, y-15, 5, 1, 3);
}

// Draw a vaccine
void drawVaccine(float x, float y)
{
  fill(175);
  rectMode(CENTER);
  noStroke();
  rect(x, y, 7, 23, 1);
  fill(#1F904D);
  rect(x, y-5, 7, 18, 10);
  fill(175);
  rect(x, y+16, 4, 10, 1);
  fill(#004BAA);
  rect(x, y+22, 10, 4, 3);
  rect(x, y+12, 15, 4, 3);
  rect(x, y-12, 7, 4, 3);
  strokeWeight(1);
  stroke(255);
  line(x, y-16, x, y-28);
}

// Draw the pac-man
void drawPacman(int x, int y)
{
  noStroke();
  fill(#F0D435);
  if (immunity)
  {
    fill(#3AA517);
  }
  circle(x, y, 30);
  fill(0);
  circle(x+6, y-7, 4);
  fill(#A3F5F0);
  ellipse(x+9, y+5, 13, 15);
  stroke(#A3F5F0);
  strokeWeight(1);
  line(x+9, y, x-14, y-7);
  line(x+9, y+5, x-13, y+7);
}

// class to hold X and Y positions of balls at any given time
class Pos 
{
  float xPos, yPos;

  Pos(float x, float y)
  {
    xPos = x;
    yPos = y;
  }
  float getX()
  {
    return xPos;
  }
  float getY()
  {
    return yPos;
  }
}
