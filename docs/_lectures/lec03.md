---
num: "03"
title: "Planning"
track: "Planning & Model-Based RL"
youtube_id:
slides_url: "https://drive.google.com/file/d/1YwxGYvxZPit_eV7KfoxhA3iROADYZkCJ/view"
colab_url:
chapter_url:
readings:
  - url: "https://arxiv.org/abs/2002.05700"
    required: true
  - url: "https://discovery.ucl.ac.uk/id/eprint/10045895/1/agz_unformatted_nature.pdf"
  - url: "https://arxiv.org/pdf/2302.00111"
    required: true
description: >
  Classical planning and optimal control: dynamic programming, LQR, and trajectory optimization.
  Builds the foundation for model-based methods by showing how a known model can be exploited
  to find optimal action sequences.
---

Before learning, there is planning. When the dynamics are known, optimal control theory provides
principled algorithms for finding the best sequence of actions. This lecture covers the spectrum
from discrete dynamic programming through continuous trajectory optimization and LQR.

### Key topics

- Dynamic programming and value iteration in discrete MDPs
- Linear Quadratic Regulator (LQR) for continuous linear systems
- Trajectory optimization and shooting methods
- How planning connects to learned world models (Lecture 04–05)
