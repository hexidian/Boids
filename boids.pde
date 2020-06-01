int curBoidCount = 0;
int viewDist = 100;
boid[] allBoids = new boid[boid.totalBoids];

void setup(){
  size(1920,1000);
  boolean tracked = true;//if true, one of the boids will have its fov tracked
  for (int i = 0; i < boid.totalBoids; i++){
    new boid(random(width),random(height),tracked);
    tracked = false;
  }
}

void draw(){
  background(255);
  for (boid i : allBoids){
    i.update();
  }
}
