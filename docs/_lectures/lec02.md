---
num: "02"
title: "Introduction to Deep RL"
track: "Foundations"
youtube_id:
slides_url:
colab_url:
chapter_url:
description: >
  Formalizes the Markov Decision Process framework — states, actions, rewards, transitions,
  and horizon — and places behavior cloning within it as a special case of supervised learning
  on state–action pairs from a fixed distribution.
---

The MDP formalism is the mathematical foundation on which all subsequent methods in the course rest.
This lecture develops the framework carefully: what a state is, how actions lead to transitions,
where rewards come from, and what it means to optimize a policy.

### Key topics

- MDP components: $\mathcal{S}$, $\mathcal{A}$, $T$, $R$, $\gamma$, $H$
- Policy, value function, and the Bellman equations
- Model-free vs. model-based distinction
- The exploration–exploitation tradeoff (introduced here, revisited throughout)
