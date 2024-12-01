# Advent of Code 2024 🎄

Welcome to my Advent of Code 2024 solutions repository! This year, I'll be solving two puzzles each day, writing all solutions in Ruby, and including RSpec tests to validate my solutions against the sample inputs provided on the Advent of Code website.

## What is Advent of Code?

[Advent of Code](https://adventofcode.com) is an annual event featuring daily programming puzzles from December 1st to 25th. Each day includes two puzzles, where the second puzzle builds on the first. It’s a fun and festive way to practice problem-solving and coding!

## Repository Structure

Each day’s solutions are organized into folders with a single Ruby file for the day, while all spec files are located in the root-level spec/ directory:

```graphql
+ Day-XX/
-   day_XX.rb       # Ruby solution file for Day XX
-   input.txt       # Input data for the puzzles (Not in the repo, but expected for local runs)
+ spec/
-   day_XX_spec.rb  # RSpec tests for Day XX
-   spec_helper.rb  # RSpec configuration file
```

## Input Data

Puzzle input files (input.txt) are not included in this repository and are part of the .gitignore. Place your input file in the corresponding Day-XX/ folder when running the scripts.

## Spec Tests

RSpec tests for all days are located in the spec/ directory. Each day’s spec file corresponds to its solution file:

- `spec/day_XX_spec.rb`: Contains tests for the logic in `Day-XX/day_XX.rb`.

## Why Ruby?

I work in Ruby every day for the day-job, so it's what I'm most familiar with. This is my first year doing Advent of Code, so I wanted something I could write in without thinking about some of the basic syntax along the way.

## Join the Challenge! ✨

Follow along or participate yourself at https://adventofcode.com.

Happy coding!