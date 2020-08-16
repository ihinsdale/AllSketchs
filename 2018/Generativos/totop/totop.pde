import org.processing.wiki.triangulate.*;
import toxi.math.noise.SimplexNoise;

int seed = int(random(999999));

void setup() {
  size(960, 960, P3D);
  smooth(8);
  pixelDensity(2);
  generate();
}

void draw() {
}

void keyPressed() {
  if (key == 's') saveImage();
  else {
    seed = int(random(999999));
    generate();
  }
}

void generate() {

  //blendMode(ADD);


  randomSeed(seed);
  noiseSeed(seed);
  background(rcol());

  int cg = int(random(40, 120));
  stroke(0, 9);
  strokeWeight(0.5);
  for (int j = 0; j <= cg; j++) {
    float v = (j*1./cg);
    float x = width*lerp(0.01, 0.99, v);
    line(x, height*0.01, x, width*0.99);
    float y = height*lerp(0.01, 0.99, v);
    line(width*0.01, y, width*0.99, y);
  }


  desAng = random(1000);
  detAng = random(0.002, 0.006)*0.02;
  desDes = random(1000);
  detDes = random(0.002, 0.006)*0.8;

  noiseDetail(1);

  int cc = int(random(300, 360)*0.8);
  float bb = 80;
  float ss = (width-bb*2.)/cc;

  float ic = random(1);
  float dc = random(0.01, 0.02)*random(1)*random(1);
  noFill();
  for (int j = 0; j < 40; j++) {
    float x1 = random(bb, width-bb);
    float y1 = random(bb, width-bb);
    float x2 = random(bb, width-bb);
    float y2 = random(bb, width-bb); 
    strokeWeight(random(0.8, 1));
    stroke(getColor(ic+dc*j));
    nline(x1, y1, x2, y2);
  }
  dc = random(0.01, 0.02)*random(1)*random(1);
  strokeWeight(0.2);
  for (int j = 0; j <= cc; j++) {
    stroke(getColor(ic+dc*j), 140);
    nline(bb, bb+j*ss, width-bb, bb+j*ss);
  }
  for (int j = 0; j <= cc; j++) {
    stroke(getColor(ic+dc*j), 140);
    nline(bb+j*ss, bb, bb+j*ss, height-bb);
  }

  ArrayList<PVector> points = new ArrayList<PVector>();

  float det = random(0.01);
  float des = random(1000);
  /*
  int c = 300; 
  for (int j = 0; j < c; j++) {
    float v2 = map(j, 0, c-1, 0, 1);
    for (int i = 0; i < c; i++) {
      float v1 = map(i, 0, c-1, 0, 1);
      float x = width*lerp(0.1, 0.9, v1);
      float y = height*lerp(0.1, 0.9, v2);
      float s = (width*(random(1.8, 2)*noise(des+x*det, des+y*det)))/c;

      PVector p = new PVector(x, y, s);
      points.add(p);
      //circle(x, y, s);
    }
  }
  */

  for (int i = 0; i < 10000; i++) {
    float x = width*random(0.15, 0.85);
    float y = height*random(0.15, 0.85);
    float s = width*random(0.05, 0.25);

    PVector p = new PVector(x, y, s);

    boolean add = true;
    for (int j = 0; j < points.size(); j++) {
      PVector other = points.get(j);
      float dist = dist(p.x, p.y, other.x, other.y);
      if (dist < (p.z+other.z)*0.5) {
        add = false;
        break;
      }
    }
    if (add) points.add(p);
  }


  det = random(0.01);
  des = random(100);

  noStroke();
  for (int i = 0; i < points.size(); i++) {
    PVector p = points.get(i);
    fill(getColor(noise(des+p.x*det, des+p.y*det)*10));
    circle(p.x, p.y, p.z);
    fill(rcol());
    circle(p.x, p.y, p.z*0.4);
  }
}

void circle(float x, float y, float s) {
  float r = s*0.5;
  int cc = int(max(8, r*PI));
  float da = TAU/cc;
  PVector p1 = new PVector();
  PVector p2 = new PVector();
  PVector c = desform(x, y);
  beginShape(TRIANGLE);
  for (int i = 0; i <= cc; i++) {
    p1 = desform(x+cos(da*i)*r, y+sin(da*i)*r);
    if (i > 0) {
      vertex(p1.x, p1.y);
      vertex(p2.x, p2.y);
      vertex(c.x, c.y);
    }
    p2.set(p1);
  }
  endShape(CLOSE);
}

void nline(float x1, float y1, float x2, float y2) {
  int cc = int(dist(x1, y1, x2, y2));
  beginShape();
  for (int i = 0; i < cc; i++) {
    float v = map(i, 0, cc-1, 0, 1);
    PVector p = desform(lerp(x1, x2, v), lerp(y1, y2, v));
    vertex(p.x, p.y);
  }
  endShape();
}

float desAng = random(1000);
float detAng = random(0.006);
float desDes = random(1000);
float detDes = random(0.006);

PVector desform(float x, float y) {
  float ang = (float) SimplexNoise.noise(desAng+x*detAng, desAng+y*detAng)*TAU;
  float des = (float) SimplexNoise.noise(desDes+x*detDes, desDes+y*detDes)*140*0.3; 
  return new PVector(x+cos(ang)*des, y+sin(ang)*des);
}

void saveImage() {
  String timestamp = year() + nf(month(), 2) + nf(day(), 2) + "-"  + nf(hour(), 2) + nf(minute(), 2) + nf(second(), 2);
  saveFrame(timestamp+".png");
}

//int colors[] = {#E6E7E9, #F0CA4B, #F07148, #EECCCB, #2474AF, #107F40, #231F20};
int colors[] = {#2B00BE, #2B00BE, #F73859, #9896F1, #D59BF6, #EDB1F0};
int rcol() {
  return colors[int(random(colors.length))];
}
int getColor() {
  return getColor(random(colors.length));
}
int getColor(float v) {
  v = abs(v)%1;
  int ind1 = int(v*colors.length);
  int ind2 = (int((v)*colors.length)+1)%colors.length;
  int c1 = colors[ind1]; 
  int c2 = colors[ind2]; 
  return lerpColor(c1, c2, (v*colors.length)%1);
}
