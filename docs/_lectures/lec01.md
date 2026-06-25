---
num: "01"
title: "Supervised Learning & Behavior Cloning"
track: "Behavior Cloning & Imitation"
youtube_id: "5hNxQ1l_Ago"
slides_url: "https://drive.google.com/file/d/1VvM-1-PcuYcd7oLJYQEIv8-XBQrNAM6n/view"
colab_url: "https://colab.research.google.com/drive/1QY29NpcIqkKMGoslbXdSzs_o3CPraHl7"
chapter_url:
readings:
  - url: "http://proceedings.mlr.press/v15/ross11a"
    title: "A Reduction of Imitation Learning and Structured Prediction to No-Regret Online Learning"
    required: true
  - url: "https://arxiv.org/abs/2304.13705"
    title: "Learning Fine-Grained Bimanual Manipulation with Low-Cost Hardware"
  - url: "https://images.nvidia.com/content/tegra/automotive/images/2016/solutions/pdf/end-to-end-dl-using-px.pdf"
    title: "End to End Learning for Self-Driving Cars"
  - url: "https://dhiraj100892.github.io/Visual-Imitation-Made-Easy/"
    title: "Visual Imitation Made Easy"
  - url: "https://sites.google.com/view/bc-z/home"
    title: "BC-Z: Zero-Shot Task Generalization with Robotic Imitation Learning"
  - url: "https://arxiv.org/abs/2209.05451"
    title: "Perceiver-Actor: A Multi-Task Transformer for Robotic Manipulation"
description: >
  Behavior cloning as supervised learning on state–action pairs.
  Covers the distribution shift problem — why a policy trained on expert data fails when it makes
  mistakes and encounters out-of-distribution states — and DAgger as a principled solution.
---

Behavior cloning is the simplest approach to learning from demonstrations: treat it as supervised learning,
mapping states to actions. This lecture shows why that seemingly straightforward idea runs into trouble
in practice (the compounding error / distribution shift problem), and introduces DAgger as an interactive
imitation learning algorithm that collects corrective data online.

### Key topics

- Supervised learning setup and maximum likelihood over demonstrations
- Distribution shift and compounding errors in sequential decisions
- DAgger: dataset aggregation for iterative improvement
- Connection to data collection strategies (see Lecture 25)

### Colab notebook

An accompanying Colab notebook walks through a behavior cloning implementation hands-on.
