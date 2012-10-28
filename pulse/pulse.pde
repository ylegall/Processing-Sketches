

PFont font;               
//boolean sticky = true;
int fontSize = 200;
float scale = 2f;
PGraphics buffer;
ArrayList<Texel> particles;

class Pulse
{
    float radius;
    float x;
    float y;
    float e = 3;
    
    Pulse (float x, float y) {
        this.x = x;
        this.y = y;   
    }
    
    void update() {
        if (radius > 0 && radius < width) {
            radius += 2;
        } else {
            radius = 0;
        }
    }
}

Pulse pulse;

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
    if (pulse.radius > 0)
        return;
    pulse.x = mouseX;
    pulse.y = mouseY;
    pulse.radius = 1;
}

void setup() 
{
    size(640, 640, JAVA2D);
    font = createFont("Ubuntu", 24, true);
    particles = new ArrayList<Texel>();
    pulse = new Pulse(0,0);
    loadPoints("dust");
    
    stroke(0);
    fill(0);
    //noFill();
    noStroke();
}


void draw()
{
    background(#eaeaea, 0.1);
    
    pulse.update();
    for (Texel t: particles) {
        float dx = t.pos.x - pulse.x;
        float dy = t.pos.y - pulse.y;
        float d = sqrt(dx*dx + dy*dy);
        if (d < pulse.radius + pulse.e && d > pulse.radius - pulse.e) {
            float f = 1/d;
            t.applyForce(f * dx, f * dy);
        }
        
        t.update(true);
        t.draw();
    }
}

