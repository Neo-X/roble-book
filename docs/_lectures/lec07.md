---
num: "07"
title: "Actor-Critic"
track: "Policy Gradient Methods"
youtube_id:
slides_url:
colab_url:
chapter_url:
description: >
  Actor-critic architectures combine a policy (actor) with a learned value function (critic)
  to reduce variance in the gradient estimator. Covers advantage estimation, GAE,
  PPO, and how critics connect policy gradient methods with value-based RL.
---

Actor-critic methods replace the high-variance Monte Carlo return of REINFORCE with a
learned value function that serves as a baseline and advantage estimator. This dramatically
reduces gradient variance while introducing some bias, yielding practical algorithms like A2C, PPO, and SAC.

### Key topics

- Actor-critic architecture: policy + value network
- Advantage function $A(s, a) = Q(s, a) - V(s)$ and why it matters
- Generalized Advantage Estimation (GAE)
- Proximal Policy Optimization (PPO)
- Connections to Q-learning (Lecture 08) and value methods (Lecture 09)
