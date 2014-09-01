
final int MAX_TIME = 3000;
final int N_PARTICLES = 1000;
final PVector[] sinks = new PVector[3];

void setup() 
{
    size(840, 840, JAVA2D);    
    stroke(0);
    strokeWeight(4);
    noFill();
    noLoop();
    //noStroke();

    // initialize sinks:
    for (int i = 0; i < sinks.length; ++i) {
        sinks[i] = new PVector(random(width), random(height));
    }
}

class Particle {
    PVector pos, vel, oldPos;
    public Particle(PVector pos) {
        this(pos, new PVector(0,0));
    }
    public Particle(PVector pos, PVector vel) {
        this.pos = pos;
        this.oldPos = new PVector(pos.x, pos.y);
        this.vel = vel;
    }

    void update() {
        oldPos.x = pos.x;
        oldPos.y = pos.y;
        pos.add(vel);
    }
    void display() {
        line(pos.x, pos.y, oldPos.x, oldPos.y);
    }
}

PVector getForce(PVector p, PVector sink) {
    PVector dir = PVector.sub(sink, p);
    float dist2 = dir.magSq();
    if (dist2 < 10) {
        dir.z = -1; return dir;
    }
    dir.normalize();
    dir.mult(16.0f / dist2);
    return dir;
}

PVector getTotalForce(PVector p) {
    PVector f = getForce(p, sinks[0]);
    for (int i = 0; i < sinks.length; ++i) {
        PVector f2 = getForce(p, sinks[i]);
        if (f2.z == -1) return f2;
        f.add(f2);
    }
    return f;
}

boolean visible(PVector p) {
    if (p.x < 0 || p.x >= width) return false;
    if (p.y < 0 || p.y >= height) return false;
    return true;
}

color randomGray(float alpha) { return color(random(200,255), random(200,255), random(200,255), alpha); }
color randomBlue(float alpha) { return color(random(32, 64), random(128, 220), random(220,255), alpha); }
color randomRed(float alpha) {  return color(random(220,255), random(86, 128), random(32, 64), alpha); }

void run(Particle p, int x, int y) {
    p.pos.y = y;
    p.pos.x = x;
    p.vel.x = p.vel.y = 0;
    int t = 0;

    while (true) {
        PVector f = getTotalForce(p.pos);
        if (f.z == -1) break;
        p.vel.add(f);
        if (p.vel.mag() > 5) break;

        int c = (t / 60) % 3;
        float alpha = 255 - 255*(t / (float)MAX_TIME);
        if (c == 0) {
           stroke(randomRed(alpha)); 
        } else if (c == 1) {
           stroke(randomBlue(alpha));
        } else {
           stroke(randomGray(alpha));
        }
        p.update();
        p.display();
        if (!visible(p.pos) || t > MAX_TIME) break;
        ++t;
    }
}

void draw()
{
    background(#ffffff, 1.0);

    Particle p = new Particle(new PVector(0,0), new PVector(0,0));
    for (int x = 0; x < width; x += 4) {
        run(p, x, 0);
        run(p, x, height);
    }
    for (int y = 0; y < height; y += 4) {
        run(p, 0, y);
        run(p, width, y);
    }

    /*
    for (int i = 0; i < sinks.length; ++i) {
        ellipse(sinks[i].x, sinks[i].y, 4, 4);
    }
    */
    save("trace.png");
}
