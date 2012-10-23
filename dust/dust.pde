

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

