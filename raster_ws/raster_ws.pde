import frames.timing.*;
import frames.primitives.*;
import frames.processing.*;

// 1. Frames' objects
Scene scene;
Frame frame;
Vector v1, v2, v3;
// timing
TimingTask spinningTask;
boolean yDirection;
// scaling is a power of 2
int n = 4;

// 2. Hints
boolean triangleHint = true;
boolean gridHint = true;
boolean debug = true;

// 3. Use FX2D, JAVA2D, P2D or P3D
String renderer = P3D;

void setup() {
  //use 2^n to change the dimensions
  size(1024, 1024, renderer);
  scene = new Scene(this);
  if (scene.is3D())
    scene.setType(Scene.Type.ORTHOGRAPHIC);
  scene.setRadius(width/2);
  scene.fitBallInterpolation();

  // not really needed here but create a spinning task
  // just to illustrate some frames.timing features. For
  // example, to see how 3D spinning from the horizon
  // (no bias from above nor from below) induces movement
  // on the frame instance (the one used to represent
  // onscreen pixels): upwards or backwards (or to the left
  // vs to the right)?
  // Press ' ' to play it :)
  // Press 'y' to change the spinning axes defined in the
  // world system.
  spinningTask = new TimingTask() {
    public void execute() {
      spin();
    }
  };
  scene.registerTask(spinningTask);

  frame = new Frame();
  frame.setScaling(width/pow(2, n));

  // init the triangle that's gonna be rasterized
  randomizeTriangle();
}

void draw() {
  background(0);
  stroke(0, 255, 0);
  if (gridHint)
    scene.drawGrid(scene.radius(), (int)pow( 2, n));
  if (triangleHint)
    drawTriangleHint();
  pushMatrix();
  pushStyle();
  scene.applyTransformation(frame);
  triangleRaster();
  popStyle();
  popMatrix();
}

// Implement this function to rasterize the triangle.
// Coordinates are given in the frame system which has a dimension of 2^n
void triangleRaster() {
  // frame.coordinatesOf converts from world to frame
  // here we convert v1 to illustrate the idea
  
  // Determinates rasterization area
  int minX = floor(min(v1.x(), v2.x(), v3.x()));
  int minY = floor(min(v1.y(), v2.y(), v3.y()));
  
  int maxX = floor(max(v1.x(), v2.x(), v3.x()));
  int maxY = floor(max(v1.y(), v2.y(), v3.y()));
  
  Vector min = new Vector(minX, minY);
  Vector max = new Vector(maxX, maxY);
  
  Vector sv1 = new Vector(frame.coordinatesOf(v1).x(), frame.coordinatesOf(v1).y());
  Vector sv2 = new Vector(frame.coordinatesOf(v2).x(), frame.coordinatesOf(v2).y());
  Vector sv3 = new Vector(frame.coordinatesOf(v3).x(), frame.coordinatesOf(v3).y());
  
  int minSysX = round(frame.coordinatesOf(min).x());
  int minSysY = round(frame.coordinatesOf(min).y());
  
  int maxSysX = round(frame.coordinatesOf(max).x());
  int maxSysY = round(frame.coordinatesOf(max).y());
  
  float det = 0.5 * f_ab(sv3.x(), sv3.y(), sv1, sv2),
    alpha, theta, gamma;
  
  for(int i = minSysX; i<maxSysX; i++){
    for(int j = minSysY; j<maxSysY; j++){
      
      if(det > 0){
        alpha = f_ab(i, j, sv2, sv3) / f_ab(sv1.x(), sv1.y(), sv2, sv3);
        theta = f_ab(i, j, sv3, sv1) / f_ab(sv2.x(), sv2.y(), sv3, sv1);
        gamma = f_ab(i, j, sv1, sv2) / f_ab(sv3.x(), sv3.y(), sv1, sv2);
      } else {
        alpha = f_ab(i, j, sv2, sv1) / f_ab(sv3.x(), sv3.y(), sv2, sv1);
        theta = f_ab(i, j, sv3, sv2) / f_ab(sv1.x(), sv1.y(), sv3, sv2);
        gamma = f_ab(i, j, sv1, sv3) / f_ab(sv2.x(), sv2.y(), sv1, sv3);        
      }
      
      if(alpha >= 0 &&  alpha <= 1 && theta >= 0 &&  theta <= 1 && gamma >= 0 &&  gamma <= 1){
        //Vector temp = new Vector(i, j);
        pushStyle();
        //set(i, j, color(255));
        //stroke(255);
        noStroke();
        fill(255, 255, 255);
        //point(i, j);
        rect(i, j, 1, 1);
        popStyle();
      }
      //println(i+" "+j);
      
    }
  }
  
  if (debug) {
    pushStyle();
    stroke(255, 255, 0, 125);
    point(round(frame.coordinatesOf(v1).x()), round(frame.coordinatesOf(v1).y()));
    popStyle();
  }
}

float f_ab(float a, float b, Vector pa, Vector pb){
  return (pa.y() - pb.y()) * a + (pb.x() - pa.x()) * b + pa.x()*pb.y() - pb.x()*pa.y();
}

void randomizeTriangle() {
  int low = -width/2;
  int high = width/2;
  v1 = new Vector(random(low, high), random(low, high));
  v2 = new Vector(random(low, high), random(low, high));
  v3 = new Vector(random(low, high), random(low, high));
}

void drawTriangleHint() {
  pushStyle();
  noFill();
  strokeWeight(2);
  stroke(255, 0, 0);
  triangle(v1.x(), v1.y(), v2.x(), v2.y(), v3.x(), v3.y());
  strokeWeight(5);
  stroke(0, 255, 255);
  point(v1.x(), v1.y());
  point(v2.x(), v2.y());
  point(v3.x(), v3.y());
  popStyle();
}

void spin() {
  if (scene.is2D())
    scene.eye().rotate(new Quaternion(new Vector(0, 0, 1), PI / 100), scene.anchor());
  else
    scene.eye().rotate(new Quaternion(yDirection ? new Vector(0, 1, 0) : new Vector(1, 0, 0), PI / 100), scene.anchor());
}

void keyPressed() {
  if (key == 'g')
    gridHint = !gridHint;
  if (key == 't')
    triangleHint = !triangleHint;
  if (key == 'd')
    debug = !debug;
  if (key == '+') {
    n = n < 8 ? n+1 : 2;
    frame.setScaling(width/pow( 2, n));
  }
  if (key == '-') {
    n = n >2 ? n-1 : 8;
    frame.setScaling(width/pow( 2, n));
  }
  if (key == 'r')
    randomizeTriangle();
  if (key == ' ')
    if (spinningTask.isActive())
      spinningTask.stop();
    else
      spinningTask.run(20);
  if (key == 'y')
    yDirection = !yDirection;
}
