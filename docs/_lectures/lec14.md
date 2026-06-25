---
num: "14"
title: "Hierarchical RL"
track: "Hierarchical RL"
youtube_id: "rEO6tyVaMzM"
slides_url: "https://drive.google.com/file/d/19FHrf60-yzZMAuBHFxIjQ4NxFqr-f1mD/view"
colab_url:
chapter_url:
readings:
  - url: "https://dl.acm.org/doi/10.1145/3072959.3073602"
    title: "DeepLoco: Dynamic Locomotion Skills Using Hierarchical Deep Reinforcement Learning"
  - url: "https://proceedings.neurips.cc/paper/2018/hash/e6384711491713d29bc63fc5eeb5ba4f-Abstract.html"
    title: "Data-Efficient Hierarchical Reinforcement Learning"
  - url: "https://thegradient.pub/the-promise-of-hierarchical-reinforcement-learning/"
    title: "The Promise of Hierarchical Reinforcement Learning"
  - url: "https://progprompt.github.io/"
    title: "ProgPrompt: Generating Situated Robot Task Plans using Large Language Models"
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
