class Ship extends Entity
{
    float w, h;
    float speed;
    float halfWidth;
    float halfHeight;
    float hitboxX, hitboxY, hitboxW, hitboxH;
    float lx, ly;

    // firerate variables
    float timeDelta = 1.0f/60.0f;
    float fireRate = 5.0f;
    float ellapsed = 0.0f;
    float toPass = 1.0f/fireRate;

    int health;
    
    boolean move;

    Ship(float x, float y)
    {
        this.x = x;
        this.y = y;
        this.x += 10;
        this.y += 10;

        h = 20;
        w = 20;
        halfWidth = w / 2;
        halfHeight = h / 2;

        colour = color(255);

        theta = 0;

        health = 1;
        
        move = false;
    }

    void update()
    {
        ellapsed += timeDelta;
        speed = 5;

        lx = sin(theta);
        ly = -cos(theta);

        hitboxX = x - 10;
        hitboxY = y - 10;
        hitboxW = hitboxX + 20;
        hitboxH = hitboxY + 20;
        
        move = false;
    }

    void move()
    {
        if (keyPressed) {
            switch (key) {
                case 'w':
                    x += lx * speed;
                    y += ly * speed;
                    move = true;
                    break;
                case 's':
                    y = y + speed;
                    break;
                case 'a':
                    theta -= 0.15f;
                    break;
                case 'd':
                    theta += 0.15f;
                    break;  
                case ' ':
                    if (ellapsed > toPass) {
                        // generate new bullet
                        bullets.add(new Bullet(x, y, theta, 5000, #CE0C0C));
                        ellapsed = 0.0f;
                        // sound effect
                        player = sfx.loadFile("ship_laser.wav", 2048);
                        player.play();
                    }
              } // end switch()

            // screen boundraies
            if (x < 0) {
            x = width; 
            }
            if (x > width) {
            x = 0; 
            }
            if (y < 0) {
            y = height; 
            }
            if (y > height) {
            y = 0; 
            } // end if()
        } // end keypressed 
    } // end move()

    void display()
    {
        pushMatrix();
        
        translate(x, y);   
        rotate(theta);
        
        // Ship
        stroke(#000000);
        strokeWeight(1);
        // hull
	fill(#FFFF66);
        beginShape();
	curveVertex(0, - 20);
	curveVertex(0, - 20);
	curveVertex(8, - 10);
	curveVertex(10, 0);
	curveVertex(8, 10);
	curveVertex(5, 20);
	curveVertex(- 5, 20);
	curveVertex(- 8, 10);
	curveVertex(- 10, 0);
	curveVertex(- 8, - 10);
	curveVertex(0, - 20);
	curveVertex(0, - 20);
	endShape();

		// windows
	fill(#33CCFF);
        ellipse(0, 0, 5, 5);
	ellipse(0, 0 - 8, 5, 5);
	ellipse(0, 0 + 8, 5, 5);

	// left wing
	fill(#FF5050);
        beginShape();
	curveVertex(- 8, 10);
	curveVertex(- 8, 10);
	curveVertex(- 13, 20);
	curveVertex(- 15, 30);
	curveVertex(- 10, 25);
	curveVertex(- 5, 20);
	curveVertex(- 8, 10);
	curveVertex(- 8, 10);
	endShape();

	// right wing
	beginShape();
	curveVertex(8, 10);
	curveVertex(8, 10);
	curveVertex(13, 20);
	curveVertex(15, 30);
	curveVertex(10, 25);
	curveVertex(5, 20);
	curveVertex(8, 10);
	curveVertex(8, 10);
	endShape();
        
        if (move == true) { 
            fill(#FFA971);
            
            beginShape();
            curveVertex(- 5, 20);
            curveVertex(- 5, 20);
            curveVertex(0, 30);
            curveVertex(5, 20);
            curveVertex(5, 20);
            endShape();
        }

        popMatrix();
    }

    void die()
    {
        if (health == 0) {
            ships.remove(this);
            println("Ship destroyed");
            gameState = GAME_OVER;
        }

        // asteroid collision
        for (int i = 0; i < asteroids.size(); i++) {
            Asteroid asteroid = (Asteroid) asteroids.get(i);

            if ( (asteroid.hitboxW > hitboxX) && (asteroid.hitboxX < hitboxW) && (asteroid.hitboxH > hitboxY) && (asteroid.hitboxY < hitboxH) ) {
                health--;
                asteroids.remove(i);
                asteroids.add(new Asteroid());
                // sound effect
                player = sfx.loadFile("ship_explosion.wav", 2048);
                player.play();
                println("Ship damaged");
                println("Health: " + health);
            } // end if()
        } // end for()

        // bullet collision
        for (int i = 0; i < bullets.size(); i++) 
        {
            Bullet bullet = (Bullet) bullets.get(i);
            // check x, y coordinate and colour
            if ( (bullet.x > hitboxX && bullet.x < hitboxW) && (bullet.y > hitboxY && bullet.y < hitboxH) && (bullet.colour == #F2FA14) ) {
                health--;
                bullets.remove(i);
                // sound effect
                player = sfx.loadFile("ship_explosion.wav", 2048);
                player.play();
                println("Ship damaged");
                println("Health: " + health);
            }
        }
    } // end die()
} // end class

