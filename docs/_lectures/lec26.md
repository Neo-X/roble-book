---
num: "26"
title: "Reward Functions with LLMs"
track: "Goal-Conditioned & Language-Guided RL"
youtube_id:
slides_url: "https://drive.google.com/file/d/1SlM4QvGkn9ftvdOx_l7O-30_dofhCCYj/view"
colab_url:
chapter_url:
description: >
  Using large language models to specify, generate, and shape reward functions.
  Covers EUREKA, Text2Reward, VLM-based reward labeling, and the broader question
  of how foundation models can serve as reward designers for robotic systems.
---

Reward engineering is one of the hardest parts of applying RL to real tasks. Large language
models encode substantial knowledge about task structure and human intent — this lecture
explores how that knowledge can be translated into reward signals automatically.

### Key topics

- LLMs as reward function generators (EUREKA, Text2Reward)
- Vision-language models for dense reward labeling from videos
- Iterative refinement: using LLM feedback to improve rewards
- Failure modes: reward hacking and misspecification through LLMs
- Connections to reward learning (Lecture 13) and language goals (Lecture 12b)
