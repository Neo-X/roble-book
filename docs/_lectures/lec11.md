---
num: "11"
title: "Goal-Conditioned RL"
track: "Goal-Conditioned & Language-Guided RL"
youtube_id:
slides_url: "https://drive.google.com/file/d/1TU2f9pm_USSiyfbYkK45qVjssRbaqUQ_/view"
colab_url:
chapter_url:
description: >
  Goal-conditioned policies that generalize across tasks by conditioning on a desired goal state.
  Covers Hindsight Experience Replay (HER) as a key technique for learning from sparse rewards
  in multi-goal settings.
---

Rather than learning a separate policy for every task, goal-conditioned RL trains a single
policy $\pi(a \mid s, g)$ that can pursue any specified goal $g$. This is a powerful form
of generalization — the same network handles navigation to any target location, for instance.

### Key topics

- Goal-conditioned policy formulation: $\pi(a \mid s, g)$
- Universal Value Functions (UVFAs)
- Hindsight Experience Replay (HER): relabeling failed trajectories as successes toward different goals
- Sparse rewards and why HER helps
- Connections to visual goals (Lecture 12) and language goals (Lecture 12b)
