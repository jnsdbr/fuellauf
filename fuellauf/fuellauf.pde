import processing.serial.*;

Serial myPort;  // The serial port

int fluidlevel = 0;
int finishPoint;
int fluidlevelMax = 158;
PFont font;
float startTime;
float endTime;

boolean finished;
boolean restart;
boolean firstRun;

void setup()
{
  size(400, 632);
  noStroke();
  noFill();
  smooth();

  myPort = new Serial(this, Serial.list()[4], 9600);
  myPort.write(65);
  
  font = loadFont("font.vlw");
  startTime = millis();
  endTime = 0;
  finishPoint = (int)random(0, 140);
  finished = false;
  firstRun = true;
}

void draw()
{ 
  if(firstRun)
  {
    finishPoint = fluidlevelMax - ((int)random(1, fluidlevelMax * 4) / 4) / 4;
    firstRun = false;
  }
  
  background(#ffffff);
  
  float seconds = (millis() - startTime) / 1000;
  
  if(!finished)
    endTime = seconds;
  
  while (myPort.available () > 0)
  {
    int lf = 10;
    byte[] inBuffer = new byte[7];
    myPort.readBytesUntil(lf, inBuffer);
    if (inBuffer != null)
    {
      String myString = new String(inBuffer);
      String newString = new String();
      
      for (int i = 0; i < myString.length(); i++)
      {
        if(myString.charAt(i) >= 48 && myString.charAt(i) <= 57)
        {
          newString += myString.charAt(i);
        }
      }
      
      fluidlevel = int(newString);
  
      if(fluidlevel <= fluidlevelMax && fluidlevel > 0)
      {
        fluidlevelMax = fluidlevel;
      }
    }
  }
  
  // tolleranz +- 2
 
  fill(0, 100);
  rect(0, finishPoint * 4, width, height);  
  
  fill(#4169E1);
  textFont(font, 48);
  
  if(!finished)
    text(seconds, 10, fluidlevelMax * 4);
  else
    text(endTime, 10, fluidlevelMax * 4);
  
  rect(0, fluidlevelMax * 4, width, height); 
  
  if(fluidlevelMax * 4 == finishPoint * 4)
  {
    // win win win win win win
    fill(0, 255, 0, 135);
    rect(0, 0, width, height);
  
    fill(255);
    textFont(font, 70);
    text("WIN", 10, height / 3);
    
    finished = true;
  }
  
  if(fluidlevelMax * 4 < finishPoint * 4)
  {
    fill(255, 0, 0, 200);
    rect(0, 0, width, height);
    finished = true;
    
    fill(255);
    textFont(font, 70);
    text("GAME", 10, height / 3);
    text("OVER", 10, height / 2.3);
  }
  
  if(restart)
  {
    finishPoint = fluidlevelMax - ((int)random(1, fluidlevelMax * 4) / 4) / 2;
    restart = false;
    finished = false;
    startTime = millis();
  }
}

boolean sketchFullScreen()
{
  return true;
  //return false;
}

void mouseClicked()
{
  restart = true;
}
