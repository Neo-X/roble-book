---
num: "17"
title: "Offline RL"
track: "Offline RL"
youtube_id: "ghJSjErT3Nk"
slides_url: "https://drive.google.com/file/d/1lIZJEUdEa9JD35a7_wqs7Acsddlb1APF/view"
colab_url:
chapter_url:
readings:
  - url: "https://proceedings.neurips.cc/paper/2021/hash/7f489f642a0ddb10272b5c31057f0663-Abstract.html"
  - url: "https://arxiv.org/abs/2006.04779"
  - url: "https://arxiv.org/abs/2204.05618"
  - url: "https://proceedings.mlr.press/v202/ball23a.html"
  - url: "https://proceedings.mlr.press/v229/chebotar23a.html"
description: >
  Offline (batch) reinforcement learning — learning policies from a fixed dataset without
  any environment interaction. Covers distributional shift in the offline setting,
  conservative value estimation (CQL), and implicit Q-learning (IQL).
---

In many robot settings, online environment interaction is expensive or dangerous — we want
to extract the best policy from existing logged data. Offline RL confronts the distributional
shift that arises when the learned policy deviates from the data-collection behavior.

### Key topics

- The offline RL problem: fixed dataset, no online interaction
- Distributional shift and overestimation of out-of-distribution actions
- Conservative Q-Learning (CQL): penalizing OOD action values
- Implicit Q-Learning (IQL): avoiding OOD queries entirely
- Decision Transformer as an offline sequence model
- Connections to data collection (Lecture 25) and imitation (Lecture 01)
