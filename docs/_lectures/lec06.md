---
num: "06"
title: "Policy Gradients"
track: "Policy Gradient Methods"
youtube_id:
slides_url: "https://drive.google.com/file/d/1Qlmmwsv0mqkOE8IEq3OvF_y4vdIYTc6i/view"
colab_url:
chapter_url:
description: >
  REINFORCE and the policy gradient theorem. Derives the gradient estimator directly from
  the objective, then covers variance reduction techniques including baselines and causality,
  motivating the actor-critic architecture.
---

Policy gradient methods directly optimize the expected return with respect to policy parameters
using gradient ascent. This lecture derives the REINFORCE estimator from first principles and
shows why its high variance makes learning slow — setting up the actor-critic methods of Lecture 07.

### Key topics

- The policy gradient theorem: $\nabla_\theta J(\theta)$
- REINFORCE: Monte Carlo policy gradient
- Variance reduction: reward-to-go, baselines, and control variates
- Connecting policy gradients to actor-critic (Lecture 07)
