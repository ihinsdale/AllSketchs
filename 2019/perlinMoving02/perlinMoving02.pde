ArrayList<PVector> particles;
int seed = int(random(9999999));



float minAngle = (TWO_PI/6)*3.5;//PI*1.5;
float maxAngle = (TWO_PI/6)*8.5;//PI*2.5;
int resolution = 5;

float det = random(0.01);

PShader blur;

void setup() {  
  size(1280, 720, P2D);
  smooth(4);
  background(0);
  blur = loadShader("blur.glsl");
  reset();
}

void draw() {  

  if (frameCount%20 == 0) blur = loadShader("blur.glsl");

  float time = millis()*0.01;

  noiseSeed(seed);

  noStroke();
  fill(0, 4);
  rect(0, 0, width, height);

  noTint();
  float blurAmp = map(cos(time*1), -1, 1, 0.001, 0.005)*0.04;
  blur.set("time", time);//nt+random(1000));
  for (int i = 0; i < 3; i++) {
    blur.set("direction", blurAmp, 0);
    filter(blur); 
    blur.set("direction", 0, blurAmp);
    filter(blur);
  }

  stroke(50, 80*2*cos(time), 250);
  strokeWeight(3);
  noiseDetail(2);
  for (int i = 0; i < particles.size(); i++) {
    PVector p = particles.get(i);



    float px = p.x;
    float py = p.y;

    float a = getAngle(px, py);

    //float v = pow(abs((ma/HALF_PI)*2-1), 4);

    //float na = lerp(a-ma, a-ma+HALF_PI, 1-v);
    //float ma = ((a*8)%1);
    //ma = abs(ma-0.5)*2;

    p.x += cos(a);
    p.y += sin(a);
  }

  beginShape(POINTS);
  for (int i = 0; i < particles.size(); i++) {
    PVector p = particles.get(i); 
    vertex(p.x, p.y);
  }
  endShape();
}

float getAngle(float x, float y) {
  float dr = 1./resolution;
  float noi = noise(x*det, y*det)*(1)+dr*0.7;
  noi -= noi%dr;
  float aux = map(noi, 0, 1, minAngle, maxAngle);
  return aux;
}

void keyPressed() {
  seed = int(random(9999999));
  reset();
}

void reset() {
  particles = new ArrayList<PVector>();
  for (int i = 0; i < 1000; i++) {
    particles.add(new PVector(random(width), random(height)));
  }
}
