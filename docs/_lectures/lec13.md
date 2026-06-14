---
num: "13"
title: "Learning Reward Functions"
track: "Reward Learning"
youtube_id:
slides_url:
colab_url:
chapter_url:
readings:
  - url: "https://arxiv.org/abs/2103.14295"
  - url: "https://arxiv.org/abs/1710.06537"
  - url: "https://arxiv.org/abs/1808.00177"
  - url: "https://arxiv.org/abs/1901.08652"
description: >
  Inverse reinforcement learning and reward learning from demonstrations and preference comparisons.
  Covers MaxEnt IRL, preference-based reward learning (RLHF), and the connection to both
  imitation learning and LLM alignment.
---

The reward function is the most powerful lever in RL — it defines what the agent should optimize.
But designing rewards by hand is brittle. This lecture covers methods for learning rewards from
expert demonstrations and human preference comparisons, connecting imitation learning and IRL.

### Key topics

- Inverse RL: recovering a reward from demonstrations
- Maximum Entropy IRL and its connection to behavior cloning
- Preference-based reward learning and RLHF
- Active learning for preference queries
- Connections to LLM alignment and reward shaping with LLMs (Lecture 26)
