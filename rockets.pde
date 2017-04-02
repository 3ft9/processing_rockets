boolean save_frames = false;
int population_size = 100;
int target_size = 20;
int max_age = 500;
float max_speed = 0.1;
int min_reproduction_age = 30;
float mutation_probability = 0.01;

Population p;
PVector target;
int age = 0;
int generation = 1;
int max_goals = 0;
int new_target_x = -1;
int new_target_y = -1;

void setup() {
  size(1920, 1080);
  target = new PVector(width / 2, 150);
  p = new Population(target, population_size, max_speed, max_age, min_reproduction_age, mutation_probability);
}

void mousePressed() {
  new_target_x = mouseX;
  new_target_y = mouseY;
}

void draw() {
  background(0);

  if (p.update(age)) {
    age = 0;
    generation++;
    if (new_target_x != -1) {
        p.setTarget(new_target_x, new_target_y);
        new_target_x = -1;
        new_target_y = -1;
    }
  } else {
    p.display();

    fill(255);
    noStroke();
    ellipse(target.x, target.y, target_size, target_size);

    text("Generation: " + generation, 20, height - 20);
    text("Age: " + age, 125, height - 20);
    text("Avg fitness: " + floor(p.avgFitnessPercent()) + "%", 200, height - 20);
    int goals = p.getGoalCount();
    if (goals > max_goals) {
      max_goals = goals;
    }
    text("Winners: " + goals + " (" + max_goals + ")", 320, height - 20);

    if (save_frames) {
      saveFrame("frames/########.png");
    }

    age++;
  }
}