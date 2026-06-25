---
num: "05"
title: "Using Learned Models"
track: "Planning & Model-Based RL"
youtube_id:
slides_url: "https://drive.google.com/file/d/13G6yjYAYriJqRKBY3SLlYHETW06mEyW7/view"
colab_url: "https://colab.research.google.com/drive/1YvcYgDveePA3I9n1U5Ne0sXqnZ62LnH1"
chapter_url:
readings:
  - url: "https://arxiv.org/abs/1709.10489"
    title: "Self-supervised Deep Reinforcement Learning with Generalized Computation Graphs for Robot Navigation"
    required: true
  - url: "https://arxiv.org/abs/1710.02298"
    title: "Rainbow: Combining Improvements in Deep Reinforcement Learning"
  - url: "https://arxiv.org/abs/1611.05397"
    title: "Reinforcement Learning with Unsupervised Auxiliary Tasks"
description: >
  Using learned dynamics models for policy improvement — including MBPO, probabilistic ensembles,
  and model-based policy optimization. Contrasts sample efficiency gains against the bias
  introduced by imperfect models.
---

Having a learned model opens up a spectrum of uses: from pure planning with a fixed model
to hybrid approaches that blend model-generated data with real environment interaction.
This lecture covers the practical side of model-based RL, including how to handle model uncertainty.

### Key topics

- Model-Based Policy Optimization (MBPO)
- Probabilistic dynamics models and ensembles for uncertainty estimation
- Short vs. long model rollouts: the bias–variance tradeoff
- Connecting to autonomous learning pipelines (Lecture 20)

### Colab notebook

An accompanying MBRL Colab notebook demonstrates model learning and planning.
