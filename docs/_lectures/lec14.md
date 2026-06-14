---
num: "14"
title: "Hierarchical RL"
track: "Hierarchical RL"
youtube_id:
slides_url: "https://drive.google.com/file/d/19FHrf60-yzZMAuBHFxIjQ4NxFqr-f1mD/view"
colab_url:
chapter_url:
description: >
  Temporal abstraction and hierarchical planning. The options framework, subgoal discovery,
  and motor primitives for structuring long-horizon tasks into manageable sub-problems.
---

Long-horizon tasks are hard: credit assignment becomes difficult, exploration is sparse,
and the policy must make thousands of coherent decisions. Hierarchical RL addresses this
by decomposing tasks into higher-level goals and lower-level controllers.

### Key topics

- The options framework: temporal abstraction over actions
- Subgoal discovery: learning useful intermediate goals
- Motor primitives and dynamic movement primitives (DMPs)
- Manager–worker architectures (HIRO, HAC)
- Credit assignment across levels of hierarchy
