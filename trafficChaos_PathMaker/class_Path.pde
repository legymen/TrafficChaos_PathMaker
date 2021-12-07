// The Nature of Code
// Daniel Shiffman
// http://natureofcode.com

// Path Following

class Path {
    ArrayList<PVector> points;
    float radius;

    Path(){
        radius = 20;
        points = new ArrayList<PVector>();
    }

    void addPoint(float x, float y){
        PVector point = new PVector(x, y);
        points.add(point);
    }

    PVector getStart(){
        return points.get(0);
    }

    PVector getEnd(){
        return points.get(points.size() - 1);
    }

    void render(){
        stroke(175);
        strokeWeight(radius*2);
        noFill();
        beginShape();
        for (PVector v : points) {
            vertex(v.x, v.y);
        }
        endShape();
        // Draw thin line for center of path
        stroke(0);
        strokeWeight(1);
        noFill();
        beginShape();
        for (PVector v : points) {
            vertex(v.x, v.y);
        }
        endShape();
    }
}
