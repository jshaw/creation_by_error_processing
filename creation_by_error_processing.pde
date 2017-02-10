import com.pubnub.api.*;
import processing.serial.*;
import peasy.*;

PeasyCam cam;
ParticleSystem ps;

PFont    axisLabelFont;
PVector  axisXHud;
PVector  axisYHud;
PVector  axisZHud;
PVector  axisOrgHud;

boolean showOriginBox = true;
boolean autoCameraZoom = true;

float a = 0.0;
//float inc = TWO_PI/25.0;
float inc = TWO_PI / 5;

int systemIndex = 0;
int maxSystemIndex = 50;
int systemIndexMultiplier = 10;
float camRotateSpeed = 0.5;
Pubnub pubnub = new Pubnub("pub-c-70a0789e-af5a-4f4f-8c1b-8e6eb6db7bf2", "sub-c-6bac1e5a-e5c4-11e6-a504-02ee2ddab7fe");

void settings() {
  size(800, 600, P3D);
  //fullScreen(P3D);
}

void setup()
{
  frameRate(24);
  lights();
  
  cam = new PeasyCam(this, 1000);
  cam.setMinimumDistance(100);
  cam.setMaximumDistance(1500);
  
  axisLabelFont = createFont( "Arial", 14 );
  axisXHud      = new PVector();
  axisYHud      = new PVector();
  axisZHud      = new PVector();
  axisOrgHud    = new PVector();
  
  //ps = new ParticleSystem(new PVector((maxSystemIndex * systemIndexMultiplier / 2) * -1, 50));
  ps = new ParticleSystem(new PVector(width/2, 50), maxSystemIndex, systemIndexMultiplier);
  
  try {
    pubnub.subscribe("feather_creation_by_error", new Callback() {
      @Override
      public void connectCallback(String channel, Object message) {
        //JSON obj = JSON.createObject();
        //org.json.JSONObject json;
        //String str = "{ \"name\": \"Alice\", \"age\": 20 }";
        //JSONObject obj = JSONObject.createObject();
        
        //obj.setInt("myint", 5);
        //obj.setFloat("myfloat", 5.5);
        //try {
        //  json = new org.json.JSONObject(str);
        //}
        //catch (JSONException e) {
        //  System.err.println(e);
        //  exit();
        //}
        //println(json, ENTER);
        
        //println( obj );
        //pubnub.publish("thesis_test", "Hello from the PubNub Java SDK", new Callback() {});
        //pubnub.publish("thesis_test", obj, new Callback() {});
        //if(publish == true){
        //  pubnub.publish("thesis_test", json, new Callback() {});
        //}
        
        //if(publish == true){
        //  for (int i = 0; i < 500; i++) {
        //      pubnub.publish("history_channel", "---message# " + i, new Callback() {});
        //  }
        //}
      }

      @Override
      public void disconnectCallback(String channel, Object message) {
        System.out.println("SUBSCRIBE : DISCONNECT on channel:" + channel
          + " : " + message.getClass() + " : "
          + message.toString());
      }

      public void reconnectCallback(String channel, Object message) {
        System.out.println("SUBSCRIBE : RECONNECT on channel:" + channel
          + " : " + message.getClass() + " : "
          + message.toString());
      }

      @Override
      public void successCallback(String channel, Object message) {
        System.out.println("SUBSCRIBE : " + channel + " : "
          + message.getClass() + " : " + message.toString());
          printString(message.toString());
          parseString(message.toString());
      }

      @Override
      public void errorCallback(String channel, PubnubError error) {
        System.out.println("SUBSCRIBE : ERROR on channel " + channel
          + " : " + error.toString());
      }
    });
    
    // Commented out to test Monday
    //pubnub.subscribe("history_channel", new Callback() {});
    
    //Callback callback = new Callback() {
    //  public void successCallback(String channel, Object response) {
    //    System.out.println("In Setup");
    //    System.out.println(response.toString());
    //  }
    //  public void errorCallback(String channel, PubnubError error) {
    //    System.out.println(error.toString());
    //  }
    //};
    
    //pubnub.history("feather_creation_by_error", 100, false, callback);
    //pubnub.history("thesis_test", 100, false, callback);
    
  
  } 
  catch (PubnubException e) {
    System.out.println(e.toString());
  }

  delay(1000);
  println("done");
}

void printString(String data){
  println("--- " + data);
}

void setSystemIndex(){
  if(systemIndex < maxSystemIndex){
    systemIndex++;
  } else {
    systemIndex = 0;
  }
}

void parseString(String str)
{
  
  setSystemIndex();
  
  String[] list = split(str, '/');
  int i;
  int lst_lngth = list.length;
  for (i = 0; i < lst_lngth; i++) {
    String[] reading = split(list[i], ':');
    int rdnglngth = reading.length;
    println(rdnglngth);
    
    if(rdnglngth < 2 || rdnglngth > 3){
      return;
    }

    if(reading.length>3){
      print("Weird shit happens... string to long");
    }
    
    // only bring values greater then 0
    if(int(reading[2]) > 0){
      ps.origin.set(0, 0, systemIndex * systemIndexMultiplier);
      ps.addParticle(int(reading[0]), int(reading[1]), int(reading[2]));
    }
    
    println("=============");
  }
}

void draw()
{
  background(255);
  
  cam.rotateY(radians(camRotateSpeed));
  
  if(autoCameraZoom){
    cam.setDistance(sin(a/100)*200 + 400);
    a = a + inc;
  }

  // run the Realtime Particle System
  ps.run();

  //Callback callback = new Callback() {
  //  public void successCallback(String channel, Object response) {
  //    System.out.println("In Draw");
  //    System.out.println(response.toString());
  //  }
  //  public void errorCallback(String channel, PubnubError error) {
  //    System.out.println(error.toString());
  //  }
  //};
  
  if(showOriginBox){
    box(10,10,10);
    calculateAxis(50);
    
    cam.beginHUD();
      drawAxis( 2 );
    cam.endHUD();
  }

}

void keyPressed() {
  println("---");
  if (key == CODED) {
    
  } else if (key == 'o'){
    showOriginBox = !showOriginBox;
  } else if(key == 'd'){
    autoCameraZoom = !autoCameraZoom;
  }
}

// ------------------------------------------------------------------------ //
void calculateAxis( float length )
{
   // Store the screen positions for the X, Y, Z and origin
   axisXHud.set( screenX(length,0,0), screenY(length,0,0), 0 );
   axisYHud.set( screenX(0,length,0), screenY(0,length,0), 0 );     
   axisZHud.set( screenX(0,0,length), screenY(0,0,length), 0 );
   axisOrgHud.set( screenX(0,0,0), screenY(0,0,0), 0 );
}

// ------------------------------------------------------------------------ //
void drawAxis( float weight )
{
   pushStyle();   // Store the current style information

      strokeWeight( weight );      // Line width
      stroke( 255,   0,   0 );     // X axis color (Red)
      line( axisOrgHud.x, axisOrgHud.y, axisXHud.x, axisXHud.y );
       
      stroke(   0, 255,   0 );
      line( axisOrgHud.x, axisOrgHud.y, axisYHud.x, axisYHud.y );
      
      stroke(   0,   0, 255 );
      line( axisOrgHud.x, axisOrgHud.y, axisZHud.x, axisZHud.y );
          
      fill(255);                   // Text color
      textFont( axisLabelFont );   // Set the text font
      
      text( "X", axisXHud.x, axisXHud.y );
      text( "Y", axisYHud.x, axisYHud.y );
      text( "Z", axisZHud.x, axisZHud.y );

   popStyle();    // Recall the previously stored style information
}