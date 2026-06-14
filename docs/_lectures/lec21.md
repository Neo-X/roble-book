---
num: "21"
title: "Designing Robotics MDPs"
track: "Foundations"
youtube_id:
slides_url:
colab_url:
chapter_url:
description: >
  Practical guide to MDP design for real robotic systems: how to choose state and action
  representations, structure rewards, and set episode boundaries in ways that make learning tractable.
---

The formal MDP from Lecture 02 leaves many design choices open. For real robots, these choices
matter enormously — a poorly designed state representation or reward can make a solvable problem
intractable. This lecture covers the practical engineering of MDPs for robotic tasks.

### Key topics

- State representation: what to include, what to leave out
- Action space design: joint-space vs. task-space, discrete vs. continuous
- Reward shaping: dense vs. sparse, potential-based shaping
- Episode boundaries and early termination
- Common pitfalls and how to diagnose them
