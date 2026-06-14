---
num: "10"
title: "Sequence Models & Auxiliary Learning"
track: "Sequence Models"
youtube_id:
slides_url:
colab_url:
chapter_url:
description: >
  Recurrent and transformer-based policies for handling partial observability and
  long-horizon dependencies. Auxiliary tasks for representation learning — predicting
  future states, rewards, or other signals to shape learned representations.
---

Many real robot tasks involve partial observability or require memory over long horizons.
This lecture covers sequence models (RNNs, transformers) as policies and world models,
and shows how auxiliary prediction tasks can dramatically improve the quality of learned representations.

### Key topics

- Recurrent policies and LSTM/GRU for partial observability
- Transformers in RL: Decision Transformer and trajectory-level modeling
- Auxiliary tasks: reward prediction, state prediction, contrastive objectives
- Self-supervised representation learning for RL
