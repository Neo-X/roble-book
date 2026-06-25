---
num: "18"
title: "Sim-to-Real Transfer"
track: "Transfer & Generalization"
youtube_id: "ItDjkBmiyc0"
slides_url: "https://drive.google.com/file/d/1T6exd3THou-uyq-937ybILeTn1RJRNOv/view"
colab_url:
chapter_url:
readings:
  - url: "https://www.science.org/doi/10.1126/scirobotics.adi8022"
    title: "Open X-Embodiment: Robotic Learning Datasets and RT-X Models"
  - url: "https://arxiv.org/abs/2406.09246"
    title: "OpenVLA: An Open-Source Vision-Language-Action Model"
description: >
  Training in simulation and deploying on real hardware. Covers the reality gap,
  domain randomization, system identification, and adaptive methods that close the gap
  between simulated and real dynamics.
---

Training RL in the real world is expensive and slow. Simulation offers unlimited data but
introduces a "reality gap" — differences in physics, appearance, and sensor noise that can
cause a sim-trained policy to fail on real hardware.

### Key topics

- The reality gap: sources of sim-to-real discrepancy
- Domain randomization: training across a distribution of simulated environments
- System identification and adaptive simulation
- Domain adaptation and meta-learning for sim-to-real
- Connections to generalization (Lecture 22)
