class Bin {
  float x, y;
  float wide, high, diameter;
  float vx, vy;
  int id;

  Bin(int idin, float s) { 
    this.x = (idin%4)*200+100; //bins start in fixed positions to prevent them from being drawn too close and starting with really large acceleration
    this.y = (idin/4)*250+125;
    
    //random velocities, but not too slow
    this.vx = random(1,2);
    float t = random(0,1);
    if (t <= 0.5) this.vx = this.vx*-1;
    this.vy = random(1,2);
    t = random(0,1);
    if (t <= 0.5) this.vy = this.vy*-1;
    this.id = idin;
    
    //setting sizes
    this.wide = binPics[id%2].width/s;
    this.high = binPics[id%2].height/s;
    this.diameter = (wide + high)/2;
  } 

  void collide() { //general collision code, but unfordunately doesn't take into account the sizes of the bins
    for (int i = id + 1; i < 8; i++) {
      float dx = bins[i].x - this.x;
      float dy = bins[i].y - this.y;
      float distance = sqrt(dx*dx + dy*dy);
      float minDist = bins[i].diameter/2 + this.diameter/2;
      if (distance < minDist) { 
        float angle = atan2(dy, dx);
        float targetX = this.x + cos(angle) * minDist;
        float targetY = this.y + sin(angle) * minDist;
        float ax = (targetX - bins[i].x) * 0.09;
        float ay = (targetY - bins[i].y) * 0.09;
        this.vx = (this.vx - ax);
        this.vy = (this.vy - ay);
        bins[i].vx = (bins[i].vx + ax);
        bins[i].vy = (bins[i].vy + ay);
      }
    }
  }

  void move() { //general move code with bouncing off walls
    this.x += this.vx;
    this.y += this.vy;
    if (this.x + this.diameter/2 > width) {
      this.x = width - this.diameter/2;
      this.vx *= -1;
    } else if (this.x - this.diameter/2 < 0) {
      this.x = diameter/2;
      this.vx *= -1;
    }
    if (this.y + this.diameter/2 > height) {
      this.y = height - this.diameter/2;
      this.vy *= -1;
    } else if (this.y - this.diameter/2 < 0) {
      this.y = this.diameter/2;
      this.vy *= -1;
    }
  }

  void display() {
    image(binPics[id%2], this.x, this.y, this.wide, this.high);
  }
}
