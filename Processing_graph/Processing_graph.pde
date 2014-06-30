Graph MyArduinoGraph = new Graph(150, 80, 500, 300, color (200, 20, 20));
float[][] gesturePoints = new float[5][2];
float[] gestureDist = new float[5];
String[] names = {"Nothing", "Touch", "Hold", "Squeeze", "Soil"};

float totalDist = 0;
int currentMax = 0;
float currentMaxValue = -1;

void setup() {
  size(1000, 800);
  MyArduinoGraph.xLabel="Readnumber";
  MyArduinoGraph.yLabel="Amp";
  MyArduinoGraph.Title="Plant Gesture";
  PortSelected=1;
  SerialPortSetup(); // speed of 115200 bps etc.

  //nothing
  gesturePoints[0][0] = 55.0;
  gesturePoints[0][1] = 1023.0;

  //Touch: 61.0, 1023.0
  gesturePoints[1][0] = 61.0;
  gesturePoints[1][1] = 1023.0;

  //Hold: 92.0, 997.0
  gesturePoints[2][0] = 92.0;
  gesturePoints[2][1] = 997.0;

  //Squeeze: 105.0, 900.0
  gesturePoints[3][0] = 105.0;
  gesturePoints[3][1] = 900.0;

  //Soil: 143.0, 726.0
  gesturePoints[4][0] = 143.0;
  gesturePoints[4][1] = 726.0;
}

void draw() {
  background(255);
  //Print the graph
  if (DataRecieved3) {
    pushMatrix();
    pushStyle();
    MyArduinoGraph.yMax=1400;
    MyArduinoGraph.yMin=-200;
    MyArduinoGraph.xMax=int (max(Time3));
    MyArduinoGraph.DrawAxis();
    MyArduinoGraph.smoothLine(Time3, Voltage3);
    popStyle();
    popMatrix();

    //Gesture compare
    for (int i = 0; i < 5;i++) {
      //setting the gesture points
      if (mousePressed && mouseX > 750 && mouseX<800 && mouseY > 100*(i+1) && mouseY < 100*(i+1) + 50) {
        fill(255, 0, 0);
        gesturePoints[i][0] = Time3[MyArduinoGraph.maxI];
        gesturePoints[i][1] = Voltage3[MyArduinoGraph.maxI];
      } else {
        fill(255, 255, 255);
      }

      //calucalte individual dist
      gestureDist[i] = dist(Time3[MyArduinoGraph.maxI], Voltage3[MyArduinoGraph.maxI], gesturePoints[i][0], gesturePoints[i][1]);
      totalDist = totalDist + gestureDist[i];
      if(gestureDist[i] < currentMaxValue || i == 0) {
        currentMax = i;
        currentMaxValue = gestureDist[i];
      }
    }
    totalDist = totalDist/3;

    //set colour rectangle for current gesture
    for (int i = 0; i < 5;i++){
      float currentAmmount = 0;
      currentAmmount = 1-gestureDist[i]/totalDist;
      if(currentMax == i) {
        fill(0,0,0);
        text(names[i], 50, 500);
        fill(currentAmmount*255.0f, 0, 0);
      } else {
        fill(255,255,255);
      }
      stroke(0, 0, 0);
      rect(750, 100 * (i+1), 50, 50);
      fill(0,0,0);
      textSize(30);
      text(names[i],810,100 * (i+1)+25);
      fill(255, 0, 0);

      //print gesture points
      int wordHeight = 550;
      for (int n = 0; n < 5; n++) {
        System.out.println(names[n]+ ": "+gesturePoints[n][0]+ ", " +gesturePoints[n][1]);
        fill(0, 0, 255);
        text((names[n]+ ": "+gesturePoints[n][0]+ ", " +gesturePoints[n][1]), 50, (wordHeight));
        wordHeight = wordHeight + 40;
      }
    }
  }
}

void stop(){
  myPort.stop();
  super.stop();
}
