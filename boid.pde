class boid{

  static final float comWeight = .01;
  static final float velWeight = .04;
  static final float colWeight = .005;
  static final float wallWeight = 100.0;
  
  static final int totalBoids = 200;
  
  static final float maxSpeed = 5.0;
    
  PVector pos;
  PVector vel;
  
  boolean tracked;
  
  public boid(float startX, float startY, boolean drawV){
    
    allBoids[curBoidCount] = this;
    curBoidCount++;
    
    tracked = drawV;
    
    pos = new PVector(startX,startY);
    vel = new PVector(0,0);
  }
  
  public void update(){
  
    float distance; //for the distance to a given other boid
    
    //CENTER OF MASS BASED
    
    PVector com = new PVector (0,0); //center of mass of the flock
    
    int inRange = 0;//the number of boids within the view range
    for (boid i : allBoids){
      if (i.pos.dist(this.pos) > viewDist) continue;
      inRange++;
      com.add(i.pos);
    }
    com.div(inRange);
    
    PVector comDisplacement = com.sub(this.pos);//gets the vector pointing towards the center of mass
   
    //VELOCITY BASED
    
    PVector avgVel = new PVector(0,0);
    
    PVector workingVel = new PVector(0,0);//for use in calculations
    
    for (boid i : allBoids){
      if (i.pos.dist(this.pos) > viewDist){
        avgVel.add(this.vel);
        continue;
      }
      if (i==this) continue;
      workingVel.x = i.vel.x; workingVel.y = i.vel.y;
      //workingVel.div(i.pos.dist(this.pos))/*.div(i.pos.dist(this.pos))*/;//divides by the distance
      avgVel.add(workingVel);
    }
    avgVel.div(inRange);
    
    //COLISION BASED
    
    PVector totalCollisionAvoidance = new PVector(0,0);
    PVector collisionAvoidance;
    for (boid i : allBoids){
      distance = i.pos.dist(this.pos);
      if (distance > viewDist || distance == 0) continue;
      
      collisionAvoidance = new PVector(this.pos.x - i.pos.x, this.pos.y - i.pos.y); //adds a vector pointing away from the other boid
      collisionAvoidance.mult( 1 - (distance/viewDist) );
      
      totalCollisionAvoidance.add(collisionAvoidance);

    }
    
    //WALL AVOIDANCE
    
    PVector avoidWall = new PVector(0,0);
    float xDist = width - this.pos.x; //be careful, a value of zero means touching the right wall, but a value of width means touching left wall
    float yDist = height - this.pos.y;
    if (xDist < viewDist && this.vel.x > 0) avoidWall.add(-1/xDist,0);
    else if (this.pos.x < viewDist && this.vel.x < 0) avoidWall.add(1/this.pos.x,0);
    if (yDist < viewDist && this.vel.y > 0) avoidWall.add(0,-1/yDist);
    else if (this.pos.y < viewDist && this.vel.y < 0) avoidWall.add(0,1/this.pos.y);
 
    //FINAL STEPS
    
    PVector acc = new PVector (0,0);
    acc.add(comDisplacement.mult(comWeight));
    acc.add(avgVel.mult(velWeight));
    acc.add(totalCollisionAvoidance.mult(colWeight));
    acc.add(avoidWall.mult(wallWeight));
    
    this.vel.add(acc);
    
    if (this.vel.mag() > boid.maxSpeed) {
      this.vel.mult(boid.maxSpeed/this.vel.mag());
      //println(this.vel);
    }
    
    this.pos.add(this.vel.x, this.vel.y);

    
    //finally, we need to check for colision with the wall
    if (this.pos.x >= width) this.pos.x = 10;
    if (this.pos.x <= 0) this.pos.x = width-10;
    if (this.pos.y >= height) this.pos.y = 10;
    if (this.pos.y <= 0) this.pos.y = height - 10;
    
    drawMe(acc);
    
  }
  
  public void drawMe(PVector acc){
  
    noStroke();
    if (tracked){
      fill (150);
      ellipse(this.pos.x,this.pos.y,2*viewDist,2*viewDist);
    }
    if (tracked) fill(0,200,0);
    else fill(0);
    ellipse(this.pos.x,this.pos.y,10,10);
    stroke(255,0,0);
    line(this.pos.x,this.pos.y,this.pos.x+this.vel.x * 5,this.pos.y+this.vel.y * 5);
    stroke(0,0,255);
    //line(this.pos.x,this.pos.y,this.pos.x+ acc.x*10,this.pos.y + acc.y*10);
    
  }

}
