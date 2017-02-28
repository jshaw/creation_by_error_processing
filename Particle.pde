class Particle {
  PVector location;
  PVector velocity;
  PVector acceleration;
  float lifespan;
  boolean transparent;
  
  Particle(PVector l){
    //acceleration = new PVector(0,0.05);
    //velocity = new PVector(random(-1, 1), random(-2, 0));
    location = l.get();
    lifespan = 250.0;
    transparent = true;
  }
  
  void run(){
    update();
    display();
  }
  
  PVector getLocation(){
    return location;
  }
  
  void update(){
    //velocity.add(acceleration);
    //location.add(velocity);
    //lifespan -= 2.0;
    lifespan -= 0.05;
  }
  
  void display(){
    if(transparent == false){
      stroke(255, lifespan);
      strokeWeight(2);
      fill(255, lifespan);
    } else {
      noStroke();
      noFill();
    }
    // playing with pshapes instead of spheres
    //beginShape(POINTS);
      //stroke(255,255,255);
      //vertex(location.x, location.y, location.z);
    //  sphere(1);
    //endShape();
    
    pushMatrix();
    if(transparent == false){
      stroke(255, lifespan);
    } else {
      noStroke();
    }
      // println("location: ");
      // println(location);
      translate(location.x, location.y, location.z);
      sphere(1);
    popMatrix();
  }

  void updateVector(int x, int y){
    float z = location.z;
    location.set(x, y, z);
  }
  
  void updateTransparent(){
    transparent = false;
  }
  
  boolean isDead(){
    if(lifespan < 0.0){
      return true;
    } else {
      return false;
    }
  }

}