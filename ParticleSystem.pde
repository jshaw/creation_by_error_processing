class ParticleSystem{
  ArrayList<Particle> particles;
  PVector origin;
  //PShape star;
  
  ParticleSystem(PVector location, int msi, int sim){
    origin = location.get();
    particles = new ArrayList<Particle>();
    maxSystemIndex = msi;
    systemIndexMultiplier = sim;
  }
  
  void addParticle(int idx, int angle, int distance){
    int angle_tmp = 0;
    if(int(angle) > 90){
      angle_tmp = angle - 90;
    } else {
      angle_tmp = angle;
    }
    
    float rad_conversion = radians(angle_tmp);
    float sin_rad_90 = sin(radians(90)); 
    
    //// http://cossincalc.com/#angle_a=52&side_a=&angle_b=&side_b=&angle_c=90&side_c=124&angle_unit=degree
    //int answr = int(obj_height/cos(rad_conversion));
    float b = 180 - angle_tmp - 90;
    float answr = (sin(rad_conversion) * distance) / sin_rad_90;
    float answr_length = (sin(radians(b)) * distance ) / sin_rad_90;
    
    //if(int(angle) > 90){
    //  answr = answr * -1;
    //}
    float zpos = (origin.z - ((maxSystemIndex * systemIndexMultiplier) / 2)) * -1;
    particles.add(new Particle(new PVector(answr_length, answr, zpos)));
  }
  
  void run(){
    int i = 0;
    int psize = particles.size()-1;
    // also testing pshapes vs. spheres for partlices
    // =========
    //star = createShape();
    //star.beginShape();
    //star.fill(102);
    //star.stroke(255);
    //star.strokeWeight(2);
    
      for(i = psize; i>=0; i--){
        Particle p = particles.get(i);
        p.run();
        if(p.isDead()){
          particles.remove(i);
        }
        
        //PVector location = p.getLocation();
        //println(location);
        //if(p.isDead()){
        //  particles.remove(i);
        //} else {
        //  star.vertex(location.x, location.y, location.z);
        //}
        
      }
    //star.endShape(CLOSE);
  }
}