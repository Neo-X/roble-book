---
num: "11"
title: "Goal-Conditioned RL"
track: "Goal-Conditioned & Language-Guided RL"
youtube_id: "-ZchWqayPR8"
slides_url: "https://drive.google.com/file/d/1TU2f9pm_USSiyfbYkK45qVjssRbaqUQ_/view"
colab_url:
chapter_url:
readings:
  - url: "http://citeseerx.ist.psu.edu/viewdoc/download?doi=10.1.1.51.3077&rep=rep1&type=pdf"
  - url: "https://proceedings.neurips.cc/paper/2017/hash/453fadbd8a1a3af50a9df4df899537b5-Abstract.html"
  - url: "https://arxiv.org/pdf/1606.05312.pdf"
  - url: "https://arxiv.org/abs/2104.11707"
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
