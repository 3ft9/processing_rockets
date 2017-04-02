class Population {
  ArrayList<Rocket> rockets;
  int max_age;
  int min_reproduction_age;
  float mutation_probability;

  Population(PVector target, int size, float max_speed, int max_age, int min_reproduction_age, float mutation_probability) {
    rockets = new ArrayList<Rocket>(size);
    this.max_age = max_age;
    this.min_reproduction_age = min_reproduction_age;
    this.mutation_probability = mutation_probability;
    for (int i = 0; i < size; i++) {
      Rocket r = new Rocket(target, width / 2, height - target.y, 10, 20, max_speed);
      rockets.add(r);
    }
  }
  
  void setTarget(float x, float y) {
    for (Rocket r : rockets) {
      r.target.x = x;
      r.target.y = y;
    }
  }
  
  int getGoalCount() {
    int count = 0;
    for (Rocket r : rockets) {
      if (r.goal) {
        count++;
      }
    }
    return count;
  }
  
  float avgFitnessPercent() {
    float max_fitness = 0;
    float total_fitness = 0;
    float this_fitness = 0;
    for (Rocket r : rockets) {
      this_fitness = r.calcFitness();
      total_fitness += this_fitness;
      if (this_fitness > max_fitness) {
        max_fitness = this_fitness;
      }
    }
    if (max_fitness == 0) {
      return 0;
    }
    return ceil(map(total_fitness / rockets.size(), 0, max_fitness, 0, 100));
  }
  
  void breed() {
    ArrayList<Rocket> new_rockets = new ArrayList<Rocket>(rockets.size());
    ArrayList<Rocket> parents = new ArrayList<Rocket>(rockets.size() * 2);
    
    float min_fitness = -1;
    float max_fitness = -1;
    for (Rocket r : rockets) {
      if (min_fitness == -1 || min_fitness > r.fitness) {
        min_fitness = r.fitness;
      }
      if (max_fitness == -1 || max_fitness < r.fitness) {
        max_fitness = r.fitness;
      }
    }
    
    int max_duplicates = rockets.size() * 100;
    for (Rocket r : rockets) {
      if (r.age_at_min_distance > min_reproduction_age) {
        for (int i = floor(map(r.fitness, min_fitness, max_fitness, 0, max_duplicates)); i > 0; i--) {
          parents.add(r);
        }
      }
    }
    
    int num_parents = parents.size();
    if (num_parents == 0) {
      println("No available parents! Using the full population.");
      for (Rocket r : rockets) {
        new_rockets.add(new Rocket(r, r, mutation_probability * 100));
      }
    } else {
      while (new_rockets.size() < rockets.size()) {
        Rocket p1 = parents.get((int)random(num_parents));
        Rocket p2 = parents.get((int)random(num_parents));
        new_rockets.add(new Rocket(p1, p2, mutation_probability));
      }
    }
    
    rockets = new_rockets;
  }

  boolean update(int age) {
    int alive_count = 0;
    if (age < max_age) {
      for (Rocket r : rockets) {
        r.update(age);
        if (!r.dead) {
          alive_count++;
        }
      }
    }
    
    if (alive_count == 0) {
      breed();
      return true;
    }
    return false;
  }

  void display() {
    for (Rocket r : rockets) {
      r.display();
    }
  }
}