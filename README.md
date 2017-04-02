# Rockets

A simple simulation of rockets using a genetic algorithm done with [processing](https://processing.org/).

- 100 rockets are launched.
- Each iteration they either follow their existing DNA (in the form of forces) or, if it doesn't have an existing gene (force) for the current age it will generate a new random one.
- This continues for up to 500 iterations.
- Once all the rockets have either gone off the screen or 500 iterations have occurred, the rockets breed.
- Parents are randomly chosen from a weighted pool based on how close they got to the target and how quickly they got there, aka their fitness.
- Which gene comes from which parent is determined by their relative fitness.
- The new generation is then launched and the process repeats.

The target can be changed while the simulation is running by left-clicking with the mouse. The target will be changed at the end of the current generation.
