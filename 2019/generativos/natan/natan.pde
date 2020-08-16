import org.processing.wiki.triangulate.*;

int seed = int(random(999999));

float nwidth =  960; 
float nheight = 960;
float swidth = 960; 
float sheight = 960;
float scale = 1;

boolean export = false;

void settings() {
  scale = nwidth/swidth;
  size(int(swidth*scale), int(sheight*scale));
  smooth(8);
  pixelDensity(2);
}

void setup() {

  generate();

  if (export) {
    saveImage();
    exit();
  }
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

  randomSeed(seed);
  noiseSeed(seed);

  int back = lerpColor(color(#E1E8E0), getColor(), random(0.05));

  background(back);



  ArrayList<PVector> points = new ArrayList<PVector>();

  noStroke();
  int count = 600;
  for (int i = 0; i < count; i++) {
    float x = width*random(-0.2, 1.2);
    float y = height*random(-0.2, 1.2);
    float scale = random(0.8, 1.8);
    float minSize = width*random(0.04, 0.2)*scale;
    float maxSize = minSize*random(1, 3)*scale*0.5;
    float des1 = random(10000);
    float det1 = random(0.001);
    float des2 = random(10000);
    float det2 = random(0.001);
    float ic = random(100);
    float dc = random(0.012)*random(0.2, 1)*random(0.1, 1)*90;
    float da = random(0.004, 0.01)*((random(1) < 0.5)? -1 : 1);

    int cc = 800;
    int ccc = int(random(2, 7));
    float dd = TAU/ccc;
    float ia = random(TAU);

    float rrr = random(0.04, 0.12);

    float black = random(0.02)*random(1);

    for (int j = 0; j < cc; j++) {
      float a = noise(des1+x*det1, des1+y*det1)*2*TAU;
      float amp = 0.5+pow(sin(j*PI/cc), 2)*0.5;
      float s = 0.18*lerp(minSize, maxSize, noise(des2+x*det2, des2+y*det2))*amp;
      int col = lerpColor(back, getColor(ic+dc*j), 0.2+pow(i*1./count, 0.2)*0.8);
      col = lerpColor(col, color(0), black);
      fill(col, 250);
      ellipse(x, y, s, s);

      x += cos(a)*0.4*scale;
      y += sin(a)*0.4*scale;
      
      noStroke();
      strokeWeight(1);

      float amprad = pow(sin(j*PI/cc), 0.4);
      fill(lerpColor(back, getColor(ic+dc*j+2), 0.2+pow(i*1./count, 1.2)*0.8), 240);
      for (int k = 0; k < ccc; k++) {
        float aa = ia+dd*k+da*j;
        float r = s*(1-rrr*0.5)*0.8*scale;
        ellipse(x+cos(aa)*r, y+sin(aa)*r, s*rrr*amprad, s*rrr*amprad);
      }
    }
  }

  noStroke();
  fill(0);
  for (int i = 0; i < points.size(); i++) {
    PVector p = points.get(i);
    ellipse(p.x, p.y, 2, 2);
  }
}

void saveImage() {
  String timestamp = year() + nf(month(), 2) + nf(day(), 2) + "-"  + nf(hour(), 2) + nf(minute(), 2) + nf(second(), 2);
  saveFrame(timestamp+"-"+seed+".png");
}

int colors[] = {#E1E8E0, #F5CE4B, #FC5801, #025DC4, #02201A, #489B4D};
//int colors[] = {#F0C7C0, #F65A5C, #3080E9, #50E2C6, #F7D3C3, #F41B9C};
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
  return lerpColor(c1, c2, pow(v%1, 2));
}
