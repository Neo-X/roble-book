---
num: "04"
title: "Learning to Plan"
track: "Planning & Model-Based RL"
youtube_id: "hc_9Qe-wgnE"
youtube_id_2: "ZgyhcKGJodk"
slides_url: "https://drive.google.com/file/d/1F7gZVEHYQqGT0-P2ZNoXDCInRK4_VsGI/view"
colab_url:
chapter_url:
readings:
  - url: "https://core.ac.uk/download/pdf/17294935.pdf"
    required: true
  - url: "https://arxiv.org/abs/1805.12114"
  - url: "https://arxiv.org/abs/1912.01603"
  - url: "https://arxiv.org/abs/2206.14176"
  - url: "https://arxiv.org/abs/2402.15391"
    required: true
  - url: "https://arxiv.org/abs/2306.17582"
description: >
  Learning to plan by combining learned world models with planning algorithms.
  Covers differentiable planning, neural network dynamics models, and the interplay
  between model accuracy and planning horizon.
---

When the dynamics are unknown, they must be learned from data. This lecture bridges classical
planning (Lecture 03) and model-free RL by showing how to learn a dynamics model and use it
for planning — a family of methods that can be far more sample-efficient than pure model-free approaches.

### Key topics

- Learning dynamics models: one-step and multi-step prediction
- Dyna-style planning: interleaving real experience with imagined rollouts
- Differentiable planning and end-to-end learning
- Model error accumulation and when to trust a learned model
