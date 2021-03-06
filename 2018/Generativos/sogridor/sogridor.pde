int seed = int(random(999999));

PShader noi;

void setup() {
  size(960, 960, P3D);
  smooth(8);
  pixelDensity(2);

  noi = loadShader("noiseShadowFrag.glsl", "noiseShadowVert.glsl");

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

  int back = int(lerpColor(color(255), rcol(), 0.3));

  background(back);

  noiseSeed(seed);
  randomSeed(seed);

  float fov = PI/2.0;
  float cameraZ = (height/2.0) / tan(fov/2.0);
  perspective(fov, float(width)/float(height), 
    cameraZ/10.0, cameraZ*10.0);

  translate(width*0.5, height*0.5, 500);

  rotateX(random(TAU)*0.02);
  rotateY(random(TAU)*0.02);
  rotateZ(random(TAU)*0.02);


  noi = loadShader("noiseShadowFrag.glsl", "noiseShadowVert.glsl");
  noi.set("displace", random(100));
  shader(noi);


  int grid = int(random(30, 80));//int(width*1./pow(2, int(random(random(7, 8), 9))));
  float gs = width*2./(grid*5);
  int gc = rcol();
  while (gc == back) gc = rcol();
  noFill();
  //noStroke();
  /*
  float alpDes = random(100);
   float alpDet = random(0.005, 0.006);
   for (int j = 0; j < grid; j++) {
   for (int i = 0; i < grid; i++) {
   float xx = i*gs;
   float yy = j*gs;
   
   stroke(gc, 120*pow(noise(alpDes+xx*alpDet, alpDes+yy*alpDet), 2));
   //fill(rcol());
   rect(xx, yy, gs, gs);
   }
   }
   */

  float ampDet = random(0.003, 0.006)*0.2;
  float ampDes = random(1000);


  for (int i = 0; i < grid*8; i++) {

    noi.set("displace", random(100));
    shader(noi);

    float xx = int(random(-1-grid, grid+1))*gs;
    float yy = int(random(-1-grid, grid+1))*gs;
    float no = noise(ampDes+xx*ampDet, ampDes+yy*ampDet);
    int sizeAmp = 40;
    float ww = gs*int(1+sizeAmp*no);
    float hh = gs*int(1+sizeAmp*no);
    int col = rcol();
    float alp = random(40, 80)*1.2;
    float bb = min(ww, hh)*random(1, random(3));

    noFill();
    noStroke();
    if (random(1) < 0.8) stroke(col, 50);
    rect(xx, yy, ww, hh);
    noStroke();

    pushMatrix();

    translate(0, 0, -random(800));

    noi.set("displace", random(100));
    shader(noi);

    boolean draGrid = false;//(random(1) < 0.5);

    int cc = int(random(2, 25));
    for (int j = 0; j < cc; j++) {
      pushMatrix();
      translate(0, 0, map(j, 0, cc-1, 0, ww));
      rotateZ(HALF_PI);
      if (draGrid) grid(xx, yy, ww, hh, 8);
      else plane(xx, yy, ww, hh, bb, col, alp);
      popMatrix();
    }

    //ellipse(xx+ww*0.5, yy+hh*0.5, ww*0.1, hh*0.1);

    popMatrix();
  }
}

void grid(float xx, float yy, float ww, float hh, int cc) {
  float dx = ww/cc;
  float dy = hh/cc;
  float amp = random(0.6, 0.8);
  noStroke();
  fill(rcol());
  rectMode(CENTER);
  for (int j = 0; j < cc; j++) {
    for (int i = 0; i < cc; i++) {
      rect(xx+dx*(i+0.5), yy+dy*(j+0.5), dx*amp, dy*amp);
    }
  }
}

void plane(float xx, float yy, float ww, float hh, float bb, int col, float alp) {

  /*
  beginShape();
  fill(rcol(), random(80));
  vertex(xx, yy+hh);
  vertex(xx, yy);
  fill(rcol(), random(80));
  vertex(xx+ww, yy);
  vertex(xx+ww, yy+hh);
  endShape();
  */

  noStroke();
  beginShape();
  fill(col, alp);
  vertex(xx+ww*1.0, yy+hh*0.0);
  vertex(xx-ww*0.0, yy+hh*0.0);
  fill(col, 0);
  vertex(xx-bb, yy-bb);
  vertex(xx+ww+bb, yy-bb);
  endShape(CLOSE);

  beginShape();
  fill(col, alp);
  vertex(xx+ww*0.0, yy-hh*0.0);
  vertex(xx+ww*0.0, yy+hh*1.0);
  fill(col, 0);
  vertex(xx-bb, yy+hh+bb);
  vertex(xx-bb, yy-bb);
  fill(col, 80);
  endShape(CLOSE);

  beginShape();
  fill(col, alp);
  vertex(xx-ww*0.0, yy+hh*1.0);
  vertex(xx+ww*1.0, yy+hh*1.0);
  fill(col, 0);
  vertex(xx+ww+bb, yy+hh+bb);
  vertex(xx-bb, yy+hh+bb);
  endShape(CLOSE);

  beginShape();
  fill(col, alp);
  vertex(xx+ww*1.0, yy+hh*1.0);
  vertex(xx+ww*1.0, yy-hh*0.0);
  fill(col, 0);
  vertex(xx+ww+bb, yy-bb);
  vertex(xx+ww+bb, yy+hh+bb);
  endShape(CLOSE);
}

void arc(float x, float y, float s, float a1, float a2, int col, float alp1, float alp2) {
  float r = s*0.5;
  float amp = (a2-a1)%TWO_PI;
  float ma = map(amp, 0, TWO_PI, 0, 1);
  int cc = max(1, int(r*PI*ma));
  float da = amp/cc;
  for (int i = 0; i < cc; i++) {
    float ang = a1+da*i;
    beginShape();
    fill(col, alp1);
    vertex(x, y);
    fill(col, alp2);
    vertex(x+cos(ang)*r, y+sin(ang)*r);
    vertex(x+cos(ang+da)*r, y+sin(ang+da)*r);
    endShape(CLOSE);
  }
}

void arc2(float x, float y, float s1, float s2, float a1, float a2, int col, float alp1, float alp2) {
  float r1 = s1*0.5;
  float r2 = s2*0.5;
  float amp = (a2-a1);
  float ma = map(amp, 0, TWO_PI, 0, 1);
  int cc = max(1, int(max(r1, r2)*PI*ma));
  float da = amp/cc;
  for (int i = 0; i < cc; i++) {
    float ang = a1+da*i;
    beginShape();
    fill(col, alp1);
    vertex(x+cos(ang)*r1, y+sin(ang)*r1);
    vertex(x+cos(ang+da)*r1, y+sin(ang+da)*r1);
    fill(col, alp2);
    vertex(x+cos(ang+da)*r2, y+sin(ang+da)*r2);
    vertex(x+cos(ang)*r2, y+sin(ang)*r2);
    endShape(CLOSE);
  }
}

void saveImage() {
  String timestamp = year() + nf(month(), 2) + nf(day(), 2) + "-"  + nf(hour(), 2) + nf(minute(), 2) + nf(second(), 2);
  saveFrame(timestamp+".png");
}

int colors[] = {#000000, #0D0D52, #401972, #FF55A7, #F59CD4, #4CFDC6};
//int colors[] = {#1C2533, #303A36, #9DA37F, #A88D40, #C5BD77, #EAF2D9, #C2C8A8, #DED9A2, #DFE4CC};
int rcol() {
  return colors[int(random(colors.length))];
}
int getColor(float v) {
  v = abs(v);
  v = v%(colors.length); 
  int c1 = colors[int(v%colors.length)]; 
  int c2 = colors[int((v+1)%colors.length)]; 
  return lerpColor(c1, c2, v%1);
}
