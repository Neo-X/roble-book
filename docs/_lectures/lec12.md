---
num: "12"
title: "Visual Goal-Conditioned RL"
track: "Goal-Conditioned & Language-Guided RL"
youtube_id:
slides_url: "https://drive.google.com/file/d/1oMsDHolKoONUMHOoXMYrG-RumWcuxEL-/view"
colab_url:
chapter_url:
description: >
  Extending goal-conditioned RL to image-based goals. Covers representation learning
  for visual goals, contrastive methods, and how to specify desired robot configurations
  with a goal image rather than an engineered reward.
---

Specifying goals as images is natural for robots that perceive through cameras: show the robot
a picture of where you want it to end up. This lecture covers the representation learning
challenges this introduces and methods that handle high-dimensional visual goal spaces.

### Key topics

- Visual goal specification: goal images and state representations
- Contrastive learning for visual representations (e.g., CURL, R3M)
- Learned distance functions for goal-reaching
- Out-of-distribution visual goals and robustness
