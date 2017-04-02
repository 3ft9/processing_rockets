class Rocket {
  DNA dna;
  PVector target;
  PVector start_pos;
  PVector pos;
  PVector vel;
  PVector acc;
  float w;
  float h;
  float min_distance = width * height;
  int age_at_min_distance = 0;
  boolean dead = false;
  boolean goal = false;
  float fitness = -1;

  Rocket(PVector target, float x, float y, float w, float h, float max_speed) {
    init(target, x, y, w, h, max_speed);
    dna = new DNA(max_speed);
  }

  Rocket(Rocket p1, Rocket p2, float mutation_probability) {
    init(p1.target, p1.start_pos.x, p1.start_pos.y, p1.w, p1.h, max_speed);
    
    if (true) {
      // SELECTION
      float p1_prob = map(p1.fitness, 0, p1.fitness + p2.fitness, 0, 1);
      int p1_size = p1.dna.getSize();
      int p2_size = p2.dna.getSize();
      int max_gene_idx = max(p1_size, p2_size);
      dna = new DNA(max_gene_idx);
      boolean from_p1 = true;
      for (int i = 0; i < max_gene_idx; i++) {
        from_p1 = true;
        if (p1.age_at_min_distance < i && p2.age_at_min_distance < i) {
          // Don't add any more.
          break;
        } else {
          if (random(1) < p1_prob) {
            if (p1_size < i) {
              from_p1 = false;
            }
          } else {
            if (p2_size >= i) {
              from_p1 = false;
            }
          }
          dna.addGene(from_p1 ? p1.dna.getGene(i) : p2.dna.getGene(i));
        }
      }
    } else {
      // SPLICE
      int max_splice_point = min(p1.dna.getSize(), p2.dna.getSize());
      int splice_point = (int)random(max_splice_point);
      dna = new DNA(p1.dna, p2.dna, splice_point);
    }
    
    dna.mutate(mutation_probability);
  }
  
  void init(PVector target, float x, float y, float w, float h, float max_speed) {
    this.target = target;
    this.start_pos = new PVector(x, y);
    this.pos = new PVector(x, y);
    this.vel = new PVector(0, 0);
    this.acc = new PVector(0, 0);
    this.w = w;
    this.h = h;
  }
  
  float calcFitness() {
    return map(min_distance, 0, width+height, (width+height)*100, 0) * map(1/max(1, age_at_min_distance), 0, 1, 10000000, 0);
  }

  void update(int age) {
    if (!dead) {
      this.acc.add(dna.getGene(age));
      this.vel.add(this.acc);
      this.pos.add(this.vel);
      this.acc.mult(0);

      if (this.pos.x < 0 || this.pos.x > width ||
        this.pos.y < 0 || this.pos.y > height) {
        dead = true;
        fitness = calcFitness();
      } else if (pos.x > target.x - (target_size/2) && pos.x < target.x + (target_size/2) && pos.y > target.y - (target_size/2) && pos.y < target.y + (target_size/2)) {
        dead = true;
        goal = true;
        fitness = 1000000000 * (1/age);
      } else {
        float distance = this.pos.dist(target);
        if (distance < min_distance) {
          min_distance = distance;
          age_at_min_distance = age;
        }
      }
    }
  }

  void display() {
    if (!dead) {
      pushMatrix();
      translate(this.pos.x - this.w/2, this.pos.y + this.h);
      rotate(this.vel.heading());
      noStroke();
      fill(255, 150);
      triangle(0, 0, 0, this.w, this.h, this.w/2);
      popMatrix();
    }
  }
}