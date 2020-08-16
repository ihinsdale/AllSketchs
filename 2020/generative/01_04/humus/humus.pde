import org.processing.wiki.triangulate.*;
import toxi.math.noise.SimplexNoise;
import peasy.PeasyCam;

//PeasyCam cam;

int seed = int(random(999999));

float nwidth =  960; 
float nheight = 960;
float swidth = 960; 
float sheight = 960;
float scale  = 1;

boolean export = false;

PImage img;

void settings() {
  scale = nwidth/swidth;
  size(int(swidth*scale), int(sheight*scale), P3D);
  smooth(8);
  pixelDensity(2);
}

void setup() {
  //cam = new PeasyCam(this, 400);
  img = loadImage("colors2.jpg");
  generate();

  /*
  if (export) {
   saveImage();
   exit();
   }
   */
}

void draw() {
  //generate();
}

void keyPressed() {
  if (key == 's') saveImage();
  else {
    seed = int(random(999999));
    generate();
  }
}

class Rect {
  float x, y, w, h;
  Rect(float x, float y, float w, float h) {
    this.x = x;
    this.y = y;
    this.w = w;
    this.h = h;
  }
}

void generate() {

  float time = millis()*0.001;
  if (export) time = frameCount/30.;
  float ntime = (time%40)/40.;

  hint(DISABLE_DEPTH_TEST);

  randomSeed(seed);
  noiseSeed(seed);

  background(20);

  translate(width*0.5, height*0.5);
  rotateX(random(-0.2, 0.2));
  rotateY(random(-0.2, 0.2));

  do {
    ix = random(img.width);
    iy = random(img.height);
    fx = random(img.width);
    fy = random(img.height);
  } while (dist(ix, iy, fx, fy) < img.width*0.5);
  float detCol = random(0.01);
  float desCol = random(10000);

  int cc = 800000;
  beginShape(POINTS);
  for (int i = 0; i < cc; i++) {
    if (i%20090 == 0) {
      endShape();
      beginShape(POINTS);
    }
    float a = random(TAU)+time*0.01;
    float d = sqrt(random(1))*width*0.6*random(0.5, 1);
    //d -= (d%(10+d*0.08))*0.1;
    //a -= (a%(TAU*0.05))*random(1);
    //a += cos(d*0.1*sin(time*0.03))*0.1;
    float xx = cos(a)*d;
    float yy = sin(a)*d;
    if (random(1) < 0.1) blendMode(ADD);
    else blendMode(NORMAL);
    strokeWeight(random(1.2));
    stroke(getColor(desCol+xx, desCol+yy, detCol));//noise(desCol+xx*detCol, desCol+yy*detCol)*colors.length*5), random(260));
    vertex(xx, yy, d*0.2);
  }
  endShape();


  if (export) {
    if (frameCount > 1800*0.5) exit();
    saveFrame("export/f####.png");
  }
}


void saveImage() {
  String timestamp = year() + nf(month(), 2) + nf(day(), 2) + "-"  + nf(hour(), 2) + nf(minute(), 2) + nf(second(), 2); 
  saveFrame(timestamp+"-"+seed+".png");
}


//int colors[] = {#FFB401, #072457, #EF4C02, #ADC7C8, #FE6567};
//int colors[] = {#07001C, #2e0091, #E2A218, #D61406};
//int colors[] = {#99002B, #EFA300, #CED1E2, #D66953, #28422E};
int colors[] = {#A1A7F4, #EA77BA, #EA0071, #F70D04, #301156};
//int colors[] = {#99002B, #CED1E2, #D66953, #28422E};
//int colors[] = {#EA2E73, #F7AA06, #1577D8};
//int colors[] = {#0F0F0F, #7C7C7C, #4C4C4C};
int rcol() {
  return colors[int(random(colors.length))];
}

int getColor() {
  return getColor(random(colors.length));
}

int getColor(float v) {
  v = abs(v); 
  v = v%(colors.length); 
  int c1 = colors[int(v%colors.length)]; 
  int c2 = colors[int((v+1)%colors.length)]; 
  return lerpColor(c1, c2, pow(v%1, 0.6));
}

float ix, iy, fx, fy;
int getColor(float x, float y, float detCol) {
  float noi = noise(x*detCol, y*detCol); 
  return img.get(int(lerp(ix, fx, noi)), int(lerp(iy, fy, noi)));
}
