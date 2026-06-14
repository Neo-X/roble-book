---
num: "08"
title: "Q-Learning"
track: "Value-Based Methods"
youtube_id:
slides_url: "https://drive.google.com/file/d/13wAwTqii3ClJ8PLBXno8OzvvEghaj4eD/view"
colab_url: "https://colab.research.google.com/drive/11WE75q-8yQCp_ShvVeFiP7KRb7fb-Wo6"
chapter_url:
description: >
  From bandit problems to DQN. Derives the Bellman equation, develops Q-learning,
  and covers the deep RL innovations — experience replay and target networks — that
  made DQN work at Atari scale.
---

Value-based methods learn to estimate the quality of taking an action from a given state —
the Q-function — and derive a policy implicitly by acting greedily. This lecture traces
the path from the simple tabular Bellman equation through deep Q-networks (DQN).

### Key topics

- The Bellman equation and Q-values
- Tabular Q-learning and convergence
- Deep Q-Networks (DQN): function approximation challenges
- Experience replay and target networks: why they stabilize training
- Double DQN, dueling architectures, and prioritized replay

### Colab notebook

A Q-iteration Colab notebook implements value iteration and Q-learning from scratch.
