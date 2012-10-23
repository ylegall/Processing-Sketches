

PFont font;               
boolean sticky = true;
int fontSize = 200;
float scale = 2f;
PGraphics buffer;
ArrayList<Texel> particles;

void loadPoints(String str)
{
    float newWidth  = width/scale;
    float newHeight = height/scale;
    
    PGraphics img;
    img = createGraphics(width, height, JAVA2D);
    img.beginDraw(); 
    img.scale(1/scale);
    img.textAlign(CENTER,CENTER);
    img.textFont(font, fontSize);
    img.background(0);
    img.fill(255);
    stroke(255);
    noSmooth();
    img.text(str,width/2,height/2 - fontSize/2);
    img.endDraw();
    
    // loop over image to find anchor points:
    for(int y=0; y < newHeight; y++) {
       for(int x=0; x < newWidth; x++) {
            color c = img.get(x,y);
            if (c != color(0)) {
                Texel t = new Texel(x*scale,y*scale);
                t.setSize(scale);
                particles.add(t);
            }
        }
    }
}

void mouseClicked()
{
    sticky = !sticky;
    if (!sticky) {
        for (Texel t: particles) {
            t.scatter();   
        }
    }
}

void setup() 
{
    size(640, 640, JAVA2D);
    font = createFont("Ubuntu", 24, true);
    particles = new ArrayList<Texel>();
    loadPoints("dust");
    
    stroke(0);
    fill(0);
    //noFill();
    noStroke();
}


void draw()
{
    background(#eaeaea, 0.1);
    
    for (Texel t: particles) {
        t.update(sticky);
        t.draw();   
    }    
}


class Texel
{
    PVector anchor;
    PVector pos;
    PVector vel;
    float size;
    float spring = 0.01;
    float damping = 0.93;
    float g = 100f;
    
    Texel(float x, float y) {
        this(new PVector(x,y));
    }
    
    Texel(PVector p) {
        pos = p;
        vel = new PVector(0,0);
        //vel.limit(0.5);
        anchor = new PVector(p.x, p.y);
        size = 2;
    }
    
    void scatter() {
        scatter(5);
    }
    
    void scatter(int f) {
        float x = random(-f,f);
        float y = random(-f,f);
        PVector p = new PVector(x,y);
        p.normalize();
        p.mult(random(0,f));
        vel.add(p);
    }
    
    void update(boolean attached) {
        
        if (attached) {
            
            // simple spring:
            // float fx = anchor.x - pos.x;
            // float fy = anchor.y - pos.y;
            // fx *= spring;
            // fy *= spring;
            // vel.add(fx, fy, 0f);
            
            PVector f = new PVector(anchor.x-pos.x, anchor.y - pos.y);
            float d = f.mag();
            
            if (d > 13) {
                // gravity
                d = pow(d, 1.5);
                f.normalize();
                f.mult(g/d);
                if (d > 0) {
                    vel.add(f);
                }
                
            } else {
                // behave like a spring
                vel.add(f.x*spring, f.y*spring, 0f);
            }

        } else {
            scatter(2);   
        }
        
        vel.mult(damping);
        pos.add(vel);

        // boundary:       
        if (pos.x < 0) pos.x = 0;
        else if (pos.x >= width) pos.x = width;
        if (pos.y < 0) pos.y = 0;
        else if (pos.y >= height) pos.y = height;
    }
    
    void setSize(float size) {
        this.size = size + 0.5;
    }
    
    void draw() {
        //point(pos.x, pos.y);
        ellipse(pos.x, pos.y, size, size);
    }
}

