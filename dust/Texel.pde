
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
