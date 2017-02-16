class Particle {
  PVector location;
  PVector velocity;
  PVector acceleration;
  float lifespan;
  
  Particle(PVector l){
    //acceleration = new PVector(0,0.05);
    //velocity = new PVector(random(-1, 1), random(-2, 0));
    location = l.get();
    lifespan = 250.0;
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
    stroke(255, lifespan);
    strokeWeight(2);
    fill(255,lifespan);
    // playing with pshapes instead of spheres
    //beginShape(POINTS);
      //stroke(255,255,255);
      //vertex(location.x, location.y, location.z);
    //  sphere(1);
    //endShape();
    
    pushMatrix();
      stroke(255,255,255);
      translate(location.x, location.y, location.z);
      sphere(1);
    popMatrix();
  }
  
  boolean isDead(){
    if(lifespan < 0.0){
      return true;
    } else {
      return false;
    }
  }

}