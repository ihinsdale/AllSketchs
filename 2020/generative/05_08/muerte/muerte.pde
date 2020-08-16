import org.processing.wiki.triangulate.*;
import toxi.math.noise.SimplexNoise;

int seed = 28910;//int(random(999999));

float nwidth =  960;
float nheight = 960;
float swidth = 960; 
float sheight = 960;
float scale  = 1;

boolean export = false;
void settings() {
  scale = nwidth/swidth;
  size(int(swidth*scale), int(sheight*scale), P2D);
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

void generate() {
  noiseSeed(seed);
  randomSeed(seed);

  background(0);
  noStroke();
  for (int i = 0; i < 47; i++) {
    float x = random(width);
    float y = random(height);
    x = lerp(x, width*0.5, random(0.3));
    y = lerp(y, height*0.5, random(0.3));
    float s = width*random(0.05)*0.8;
    s *= random(30);
    int col = rcol();
    noStroke();
    fill(col, 8);
    ellipse(x, y, s*random(1, 3), s*random(1, 1));
    ellipse(x, y, s*random(1, 3)*0.5, s*random(1, 1)*0.5);
    ellipse(x, y, s*random(1, 3)*0.05, s*random(1, 1)*0.05);
    for (int j = 0; j < s*s*0.3; j++) {
      float ang = random(TAU);
      float dis = sqrt(random(1))*s*random(random(0.1), 1);
      stroke(col, random(60, 90));
      point(x+cos(ang)*dis, y+sin(ang)*dis);
      if (random(1) < 0.1) {
        blendMode(ADD); 
        point(x+cos(ang)*dis, y+sin(ang)*dis);
        blendMode(NORMAL);
      }
    }
  }
}

void saveImage() {
  String timestamp = year() + nf(month(), 2) + nf(day(), 2) + "-"  + nf(hour(), 2) + nf(minute(), 2) + nf(second(), 2); 
  saveFrame(timestamp+"-"+seed+".png");
}

//int colors[] = {#7D7FD8, #F7AA06, #EA79B7, #FF0739, #12315E};
//int colors[] = {#354998, #D0302B, #F76684, #FCFAEF, #FDC400};
//int colors[] = {#F7F5E8, #F1D7D7, #6AA6CB, #3E4884, #E36446, #BBCAB1};
//int colors[] = {#6402F7, #F7A4EF, #F62C64, #00DACA};
//int colors[] = {#2B349E, #F57E15, #ED491C, #9B407D, #B48DC0, #E3E8EA};
//int colors[] = {#0A0B0B, #2E361E, #ACB2A4, #B66F3A, #B91A1B};
//int colors[] = {#D7CEA9, #7E845A, #232319, #303B4D, #362D17};
int colors[] = {#2e2a14, #5d6643, #f2c4d1, #e4e1e6, #2934cc};
//int colors[] = {#B2734B, #A69050, #897E6A, #5B6066, #292E31};
//int colors[] = {#FCB375, #FEAE02, #FED400, #F0EBBE, #B0DECE, #01B6D2, #18AD92, #90BC96};
//int colors[] = {#9C0106, #8A8F32, #8277EE, #B58B17, #5F5542};
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
