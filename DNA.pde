class DNA {
  ArrayList<PVector> genes;
  float max_speed;
  
  DNA(float max_speed) {
    init(max_speed);
  }
  
  DNA(int size) {
    genes = new ArrayList<PVector>(size);
  }
  
  DNA(DNA dna1, DNA dna2, int splice_point) {
    init(dna1.max_speed);
    int i = 0;
    for (i = 0; i < splice_point; i++) {
      genes.add(dna1.getGene(i));
    }
    for (; i < dna2.getSize(); i++) {
      genes.add(dna2.getGene(i));
    }
  }
  
  void init(float max_speed) {
    init(max_speed, 100);
  }
  
  void init(float max_speed, int num_genes) {
    this.max_speed = max_speed;
    genes = new ArrayList<PVector>(num_genes);
  }
  
  void addGene(PVector gene) {
    genes.add(gene);
  }
  
  void mutate(float probability) {
    for (int i = genes.size()-1; i >= 0; i--) {
      if (random(1) < probability) {
        PVector new_vector = PVector.random2D();
        new_vector.limit(max_speed);
        genes.set(i, new_vector);
      }
    }
  }
  
  int getSize() {
    return genes.size();
  }
  
  PVector getGene(int age) {
    if (age == 0) {
      age = 1;
    }
    while (genes.size() < age) {
      PVector new_gene = PVector.random2D();
      new_gene.limit(max_speed);
      genes.add(new_gene);
    }
    return genes.get(age-1);
  }
}