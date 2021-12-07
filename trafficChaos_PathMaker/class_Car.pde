// Heavily dependent on:
// The Nature of Code
// Daniel Shiffman
// http://natureofcode.com

class Car{

    PVector position;
    PVector velocity;
    PVector acceleration;
    float r, maxForce, maxSpeed;
    color carColor = color(255, 0, 0);

    Car(PVector _position, float _maxSpeed, float _maxForce){
        position = _position.get();
        r = 4.0;
        maxSpeed = _maxSpeed;
        maxForce = _maxForce;
        acceleration = new PVector(0, 0);
        velocity = new PVector(maxSpeed, 0);
    }

    void run(){
        update();
        render();
    }

    void update(){
        velocity.add(acceleration);
        velocity.limit(maxSpeed);
        
        position.add(velocity);

        acceleration.mult(0);
    }

    void render(){
        float angle = velocity.heading2D() + radians(90);
        fill(carColor);
        stroke(0);
        pushMatrix();
        translate(position.x, position.y);
        rotate(angle);
        rectMode(CENTER);
        rect(0, 0, 6, 20);
        rect(0, 0, 6, 10);
        popMatrix();
    }

    void applyForce(PVector force) {
        acceleration.add(force);
    }

    void seek(PVector target){
        PVector desired = PVector.sub(target, position);

        if (desired.mag() == 0){
            return;
        }

        desired.normalize();
        desired.mult(maxSpeed);

        PVector steer = PVector.sub(desired, velocity);
        steer.limit(maxForce);

        applyForce(steer);
    }

    // This function implements Craig Reynolds' path following algorithm
    // http://www.red3d.com/cwr/steer/PathFollow.html
     void follow(Path p) {

        // Predict position 50 (arbitrary choice) frames ahead
        // This could be based on speed 
        PVector predict = velocity.get();
        predict.normalize();
        predict.mult(25);
        PVector predictpos = PVector.add(position, predict);

        // Now we must find the normal to the path from the predicted position
        // We look at the normal for each line segment and pick out the closest one

        PVector normal = null;
        PVector target = null;
        float worldRecord = 1000000;  // Start with a very high record distance that can easily be beaten

        // Loop through all points of the path
        for (int i = 0; i < p.points.size(); i++) {

            // Look at a line segment
            PVector a = p.points.get(i);
            PVector b = p.points.get((i+1) % p.points.size()); // Note Path has to wraparound

            // Get the normal point to that line
            PVector normalPoint = getNormalPoint(predictpos, a, b);


            // Check if normal is on line segment
            PVector dir = PVector.sub(b, a);
            // If it's not within the line segment, consider the normal to just be the end of the line segment (point b)
            //if (da + db > line.mag()+1) {
            if (
                normalPoint.x < min(a.x, b.x) ||
                normalPoint.x > max(a.x, b.x) ||
                normalPoint.y < min(a.y, b.y) ||
                normalPoint.y > max(a.y, b.y)
            ) {
                normalPoint = b.copy();
                // If we're at the end we really want the next line segment for looking ahead
                a = p.points.get((i + 1) % p.points.size());
                b = p.points.get((i + 2) % p.points.size()); // Path wraps around
                dir = PVector.sub(b, a);
            }


            // How far away are we from the path?
            float distance = PVector.dist(predictpos, normalPoint);
            // Did we beat the record and find the closest line segment?
            if (distance < worldRecord) {
                worldRecord = distance;
                // If so the target we want to steer towards is the normal
                normal = normalPoint;

                // Look at the direction of the line segment so we can seek a little bit ahead of the normal
                dir.normalize();
                // This is an oversimplification
                // Should be based on distance to path & velocity
                dir.mult(25);
                target = normalPoint.get();
                target.add(dir);
            }
        }

        // Only if the distance is greater than the path's radius do we bother to steer
        if (worldRecord > p.radius) {
            seek(target);
        }


        // Draw the debugging stuff
        if (debug) {
        // Draw predicted future position
            stroke(0);
            fill(0);
            line(position.x, position.y, predictpos.x, predictpos.y);
            ellipse(predictpos.x, predictpos.y, 4, 4);

            // Draw normal position
            stroke(0);
            fill(0);
            ellipse(normal.x, normal.y, 4, 4);
            // Draw actual target (red if steering towards it)
            line(predictpos.x, predictpos.y, normal.x, normal.y);
            if (worldRecord > p.radius) fill(255, 0, 0);
            noStroke();
            ellipse(target.x, target.y, 8, 8);
        }
    }

    PVector getNormalPoint(PVector p, PVector a, PVector b){
        PVector ap = PVector.sub(p, a);
        PVector ab = PVector.sub(b, a);
        ab.normalize();
        ab.mult(ap.dot(ab));
        PVector normalPoint = PVector.add(a, ab);
        return normalPoint;
    }

}
