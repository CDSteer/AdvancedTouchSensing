Graph MyArduinoGraph = new Graph(150, 80, 500, 300, color (200, 20, 20));
float[] gestureOne=null;
float[] gestureTwo = null;
float[] gestureThree = null;
float[] gestureFour = null;
float[] gestureFive = null;

float[][] gesturePoints = new float[5][2];
float[] gestureDist = new float[5];
String[] names = {"Nothing", "1 Leaf", "2 Leaf", "Soil", "new"};

void setup() {
  size(1000, 1000); 
  MyArduinoGraph.xLabel="Readnumber";
  MyArduinoGraph.yLabel="Amp";
  MyArduinoGraph.Title="Plant Gesture";  
  noLoop();
  PortSelected=1;
  SerialPortSetup(); // speed of 115200 bps etc.
}

void draw() {
  background(255);
  // Print the graph
  if ( DataRecieved3 ) {
    pushMatrix();
    pushStyle();
    MyArduinoGraph.yMax=1000;      
    MyArduinoGraph.yMin=-200;      
    MyArduinoGraph.xMax=int (max(Time3));
    MyArduinoGraph.DrawAxis();    
    MyArduinoGraph.smoothLine(Time3, Voltage3);
    popStyle();
    popMatrix();

    float gestureOneDiff =0;
    float gestureTwoDiff =0;
    float gestureThreeDiff =0;
    
    //Gesture compare
    float totalDist = 0;
    int currentMax = 0;
    float currentMaxValue = -1;
    for (int i = 0; i < 5;i++) {
      //  gesturePoints[i][0] = 
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
    
    totalDist=totalDist /3;

    for (int i = 0; i < 5;i++){
      float currentAmmount = 0;
      currentAmmount = 1-gestureDist[i]/totalDist;
      if(currentMax == i) {
         fill(0,0,0);
         text(names[i], 50, 500);
         fill(currentAmmount*255.0f, 0, 0);
         System.out.println(currentMax);
      } else {
        fill(255,255,255);
      }
      stroke(0, 0, 0);
      rect(750, 100 * (i+1), 50, 50);
      fill(0,0,0);
      textSize(30);
      text(names[i],810,100 * (i+1)+25);
      fill(255, 0, 0);
      //rect(800,100* (i+1), max(0,currentAmmount*50),50);
    }
  }
}

void stop(){
  myPort.stop();
  super.stop();
}
