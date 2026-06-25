---
num: "12b"
title: "Language Goal-Conditioned RL"
track: "Goal-Conditioned & Language-Guided RL"
youtube_id:
slides_url:
colab_url:
chapter_url:
readings:
  - url: "https://arxiv.org/abs/2307.15818"
    title: "RT-2: Vision-Language-Action Models Transfer Web Knowledge to Robotic Control"
    required: true
  - url: "https://arxiv.org/abs/2204.01691"
    title: "Do As I Can, Not As I Say: Grounding Language in Robotic Affordances"
    required: true
  - url: "https://arxiv.org/abs/2209.05451"
    title: "Perceiver-Actor: A Multi-Task Transformer for Robotic Manipulation"
    required: true
  - url: "https://arxiv.org/abs/2104.11707"
    title: "DisCo RL: Distribution-Conditioned Reinforcement Learning for General-Purpose Policies"
    required: true
  - url: "http://arxiv.org/abs/1910.11670"
    title: "Contextual Imagined Goals for Self-Supervised Robotic Learning"
    required: true
  - url: "https://arxiv.org/abs/2103.00020"
    title: "Learning Transferable Visual Models From Natural Language Supervision"
description: >
  Using natural language as the goal specification modality. Covers grounding language
  in robot perception, language-conditioned imitation, and the connection to large
  pretrained language and vision-language models.
---

Natural language is the most flexible way to specify goals — humans can describe arbitrarily
complex intentions without engineering a structured representation. This lecture covers how
to connect language understanding to robot behavior, leading into the LLM-based reward
shaping methods of Lecture 26.

### Key topics

- Language-conditioned imitation and RL
- Vision-language models (CLIP, SayCan, RT-2) for robot goal specification
- Grounding compositional language instructions
- Generalization across novel language goals
