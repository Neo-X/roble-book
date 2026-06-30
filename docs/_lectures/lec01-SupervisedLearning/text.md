---
title: Supervised Learning Over Sequences
author: Glen Berseth
date: Jan 5, 2022
published: false
header-includes:
    - \input{../defs.md}
---

# Motivation

![Large Scale Behaviour Cloning \citep{Jang2022-uu} ](../lec01-SupervisedLearning/figures/BC-task-complexity.png){width=90% #fig:bc-complexity}

The central question motivating this chapter is whether a simple recipe can serve as the foundation for general robot learning: observe what experts do, and copy it. Not all tasks are equally tractable, and some are considerably more complex than others, but across nearly all of them, humans already possess ideas about how to perform the task. That expert knowledge can be recorded as demonstrations. The question then becomes whether copying from enough of those demonstrations — what the field calls behavior cloning — produces an agent that generalizes meaningfully, and how far this paradigm can be pushed before it breaks down.

\autoref{fig:bc-complexity} illustrates the scaling dimension of the question. The BC-Z system \citep{Jang2022-uu} shows a characteristic pattern: as the volume and diversity of demonstration data increases, behavior cloning begins to handle increasingly complex and varied tasks. The figure arranges tasks by difficulty and plots performance as a function of scale, making clear that the approach is not fundamentally limited to simple, narrow behaviors. This observation motivates the rest of the chapter: understanding when and why behavior cloning works, where it fails, and what additions are needed to make it a viable foundation for large-scale robot learning.

## Imitation Learning

![Imitation Learning for Car driving](../lec00-WhatIsRobotLearning/figures/vgg16-policy-choice){width=70% #fig:vgg16-policy-choice}

Behavior cloning formalizes learning from demonstration as a supervised learning problem, and as \autoref{fig:bc-complexity} suggests, its appeal grows with the scale of available demonstration data. A human expert drives a car, and at each timestep the camera observation $\st$ and the steering action $\at$ are recorded, as in \autoref{fig:vgg16-policy-choice}. Collecting this across many drivers, roads, and weather conditions yields an expert dataset $\data = \{(\st^{\star}, \at^{\star})\} \sim d^{\pi^{\star}}$, where $d^{\pi^{\star}}$ is the state distribution induced by the expert policy. A neural network policy $\pi_\theta$ is then trained to minimize the behavioral loss in \autoref{eq:BC-loss}:

\begin{equation} \label{eq:BC-loss}
\hat{\theta} = \argmin_{\theta} \sum_{t=1}^{N} \ell(\pi_{\theta}, \st^{\star}, \at^{\star})
\end{equation}

This is nothing more than supervised learning where each (observation, action) pair is treated as a labeled example. No reward function is required, and no interaction with the environment is needed during training — the expert has already done that work.

The appeal is obvious: human demonstrations are comparatively cheap to collect, and the training procedure is well-understood. With enough data across diverse conditions, one might expect the policy to generalize. Early large-scale work in autonomous driving \citep{bojarski2016end} pursued exactly this, collecting millions of miles of driving while simultaneously capturing steering corrections. Imitation learning for manipulation and locomotion followed a similar trajectory \citep{schaal1999imitation,hussein2017imitation}. Self-driving cars, however, have not become ubiquitous, which signals that something more fundamental limits this approach — the distribution shift problem explored in the following sections.

## How Deep Imitation Learning Began

![ALVINN Design](../lec01-SupervisedLearning/figures/alvinn.png){width=80% #fig:alvinn}

The history of imitation learning for autonomous driving begins with ALVINN — Autonomous Land Vehicle In a Neural Network \citep{pomerleau1988alvinn} — built at Carnegie Mellon in 1988. The vehicle used a camera and laser range finder whose input was reduced to a coarse $30 \times 32$ image, fed into a shallow neural network that predicted steering angles from human driving demonstrations. The resulting system navigated real roads at highway speeds. This predates deep learning and is, in retrospect, a remarkably early proof of concept that the behavior cloning framework can work.

\autoref{fig:alvinn} shows the ALVINN architecture: a single hidden-layer network receiving the retinal image and range map, trained by recording the actions of a human driver. The same paradigm described in the previous section — collect (observation, action) pairs from an expert, minimize prediction error — was already being practiced three decades ago.

The lesson from ALVINN is sobering: despite its early success, the approach did not scale to the full complexity of real-world driving. The core difficulty is not the model size or data volume alone, but the fundamental compounding error problem that the next section formalizes.

## Why Doesn't ALVINN Work?

![Trajectory Training](../lec01-SupervisedLearning/figures/trajectorytraining.svg){width=70% #fig:trajectory-training}

The failure mode of behavior cloning is not a single large error but the compounding of many small ones. No neural network achieves zero training loss — there is always some residual mismatch between the model's predictions and the expert's actions. On a single prediction this error is small and tolerable. But behavior cloning deploys the policy over a sequence of timesteps, and each prediction influences the next state.

\autoref{fig:trajectory-training} illustrates the dynamics: the expert trajectory (solid line) is the sequence of states the policy was trained on. As the deployed policy accumulates small errors, it drifts to states not well-covered by the training data. The model was never trained on these states, so its predictions there become even less accurate. The deviation compounds — small early errors lead to larger later ones — until the policy visits states the expert never encountered and has no guidance for.

The distribution of states actually visited during deployment, $p(\st|\pi_\theta)$, diverges from the training distribution $d^{\pi^*}$ used to collect $\data$. This is the distribution shift problem: the model is evaluated on inputs drawn from a different distribution than the one it was trained on. Any machine learning system suffers some performance degradation under distribution shift, but the sequential nature of policy deployment makes the degradation particularly severe \citep{anthony1999neural}.

## General Problem: A Difference of Distributions

![Difference of Distributions](../lec01-SupervisedLearning/figures/distributionChallenges.svg){width=70% #fig:distribution-shift}

The core problem is that the learning algorithm has access to the expert's *data* but not the expert's *model*. The expert policy $\pi^*$ produced the dataset $\data^* = \{\bo_0, \ba_0, \ldots, \bo_N, \ba_N\}$ by interacting with the world from a particular initial distribution and visitation pattern. The resulting state visitation distribution $p(\bo|\data^*)$ reflects where the expert goes.

\autoref{fig:distribution-shift} shows the divergence: the expert trajectory remains in a narrow corridor of state space (the solid region), while a policy trained via behavior cloning, once deployed, drifts into an ever-wider region. The question behavior cloning must answer is: how can the agent make $p(\bo|\theta) = p(\bo|\data^*)$?

The honest answer is that it cannot — not without matching the expert exactly. The agent's policy is an approximation. Every approximation error shifts the trajectory slightly. The shifted trajectory visits states outside the training distribution. At those states, the approximation error is larger. The trajectory shifts further. This feedback loop is what makes behavior cloning fundamentally limited for long-horizon tasks, regardless of how much expert data is available.

## Behavior Cloning Algorithm

The behavior cloning algorithm is a direct application of supervised learning to the imitation problem. The expert dataset $\data^*$ is treated as a labeled training set: each observation $\bo_t$ is an input, and the corresponding expert action $\at^*$ is the target label. The policy $\pi(\ba_t|\bo_t,\theta)$ is trained by maximum likelihood on these pairs, then deployed to select actions without further modification.

The algorithm is attractive for its simplicity: no environment interaction is needed during training, no reward function must be designed, and standard deep learning infrastructure applies directly. It is the natural first baseline for any imitation learning problem, and in many settings it achieves surprisingly good results — particularly when the task is short-horizon, the training distribution is broad, or the policy is used only as initialization for a subsequent reinforcement learning phase.

Its limitation is structural. The policy is trained on states from $d^{\pi^*}$ and deployed to states from its own visitation distribution $p(\bo_t|\pi,\theta)$. Because $\pi \neq \pi^*$, these distributions diverge from the first timestep. The loop labeled "while true" in the pseudocode runs the policy in an environment where the policy was never trained, and there is no mechanism within the algorithm to recover when it encounters unfamiliar territory.

## How to Make the Distribution the Same?

DAgger (Dataset Aggregation) \citep{dagger} reframes the distribution shift problem as a dataset problem. Instead of asking whether the policy can match the expert's distribution, DAgger asks whether the dataset can be grown to include the states the policy actually visits. The key insight is that the data shortage is not in the expert's original demonstrations but in the off-trajectory states the learner wanders into.

The algorithm iterates: (1) train $\pi(\ba_t|\bo_t,\theta)$ on the current dataset $\data^*$; (2) roll out the learned policy to generate new trajectories $\data_\theta$, visiting the states the current policy actually encounters; (3) ask the expert to label the actions $\ba_t$ for every state in $\data_\theta$; (4) aggregate $\data^* \leftarrow \data^* \cup \data_\theta$ and repeat. Over iterations, the dataset expands to cover the states the policy visits, not just the states the expert visited.

The dataset that accumulates is not merely a collection of expert demonstrations but a coverage map of corrective behaviors: expert labels for every deviation the student policy makes, and expert labels showing how to return from each deviation to the target trajectory. This is qualitatively richer than demonstrations alone — it encodes the gradient of how to recover, not just the ideal path.

The price is the labeling requirement. The expert must provide actions for states in $\data_\theta$ that the expert has never visited. For car driving, this means asking a human to annotate what the correct action would be when the car is already partially off the road — a task that requires expertise and attention, and that scales poorly as the policy and task become more complex.

## Still an Issue

![Human Expert Data is Expensive](../lec01-SupervisedLearning/figures/NeedHumanLabels.svg){width=60% #fig:human-labels-cost}

The labeling step in DAgger, shown in \autoref{fig:human-labels-cost}, is the practical bottleneck. Each iteration of the algorithm requires a human expert to annotate every state in the on-policy rollout $\data_\theta$. For complex tasks — robot manipulation, surgical assistance, logistics planning — the volume of states can be enormous, and the annotations require domain expertise. This cost scales with both the number of iterations and the length of the rollouts.

In Tesla's Autopilot system, a real-world variant of this process occurs: whenever a human driver overrides the autopilot, the system logs the corrective action and the preceding state. This is crowd-sourced DAgger at fleet scale — millions of drivers, each contributing a few corrective labels per week. Most organizations cannot replicate this data collection infrastructure, making DAgger impractical for domains without a large installed base of human-supervised systems.

The expense of human labeling motivates the inverse dynamics and inverse reinforcement learning approaches discussed later in this chapter: methods that can extract action labels from observation-only data, or that circumvent the labeling requirement entirely by learning a reward function and using the environment itself to generate training signal.

# Now for Some Theory

## Challenges for Imitation Learning

Three structural challenges limit imitation learning beyond the distribution shift problem already discussed.

First, deep learning is data hungry. Neural network policies require large, diverse datasets to generalize. For robotics, the space of possible states and tasks is enormous, and the fraction of that space covered by any expert dataset is small. Increasing coverage requires sustained human effort.

Second, the human-robot interface introduces systematic error. Teleoperation via joystick or keyboard records low-fidelity proxies for the demonstrator's intended behavior: the actions logged are controller inputs, not the fine-grained muscle activations and intent that produced them. This action-interface mismatch degrades supervision quality independently of how much data is collected.

Third, humans learn autonomously through interaction, not solely by observing demonstrations. A human child acquires most skills by doing — trying, failing, and adjusting. A system trained purely on static demonstrations lacks any mechanism to improve through interaction, discover recovery strategies, or adapt to conditions never encountered in the training data. Closing this gap motivates the transition from pure imitation to reinforcement-based methods discussed in subsequent chapters.

## Notation Setup

![Imitation Learning for Car driving](../lec00-WhatIsRobotLearning/figures/vgg16-policy-choice.svg){width=70% #fig:vgg16-policy-choice-notation}

Two complementary scalar functions characterize the desirability of a state-action pair. The reward function $r(\st,\at)$ assigns higher values to preferred pairs; the cost function $c(\st,\at)$ assigns lower values to preferred pairs. The two conventions are equivalent under the sign change $r(\st,\at) = -c(\st,\at)$, and the choice of which to use is a matter of convention for the problem at hand.

\begin{align*}
&= \argmin_{\theta} \expectation_{\ba \sim \pi(\ba | \bs, \theta),\bs' \sim p(\bs'| \ba, \bs) }
[ p (\bs' = \text{accident}) ] && \text{Expectation over policy distribution} \\
&= \argmin_{\theta} \expectation_{\bs_{1:T},\ba_{1:T}}
[\sum\limits_{t}^{T} p(\bs_t = \text{accident}) ] && \text{expectation over trajectories} \\
&= \argmin_{\theta} \expectation_{\bs_{1:T},\ba_{1:T} }
[\sum\limits_{t}^{T} c(\st ,\at ) ] && \text{General expectation over any cost}
\end{align*}

For the car driving example of \autoref{fig:vgg16-policy-choice-notation}, the objective can be written in three equivalent forms. Starting from the most concrete — minimize the probability of an accident across all trajectories:

$$\argmin_{\theta} \E_{\ba \sim \pi(\ba|\bs,\theta),\,\bs' \sim p(\bs'|\ba,\bs)}\!\left[p(\bs' = \text{accident})\right]$$

This expands to an expectation over complete trajectories, and then generalizes to any cost function $c(\st,\at)$ in place of the accident indicator:

$$\argmin_{\theta} \E_{\bs_{1:T},\ba_{1:T}}\!\left[\sum_{t}^{T} c(\st,\at)\right]$$

This trajectory-level formulation is the standard objective for both imitation learning and reinforcement learning. In the imitation setting, the cost $c(\st,\at)$ measures how far the agent's actions deviate from the expert's.

## Imitation Cost Function

![Behaviour Cloning](../lec01-SupervisedLearning/figures/BehaviourCloning.svg){width=90% #fig:behaviour-cloning}

Two cost functions are commonly used in the analysis of imitation learning, both measuring how far the learned policy strays from the expert behavior depicted in \autoref{fig:behaviour-cloning}.

The **probabilistic formulation** uses the log-likelihood of the expert action under the learned policy:

$$r(\bs,\ba) = \log p(\ba = \pi^*(\bs) \mid \bs)$$

This measures how likely the learned policy is to produce the same action as the expert at a given state. It is the log-likelihood objective optimized during training and is convenient in practice.

The **indicator formulation** counts discrete mistakes:

$$c(\st,\at) = \begin{cases} 0 & \text{if } \at = \pi^*(\st) \\ 1 & \text{otherwise} \end{cases}$$

The indicator cost turns the trajectory objective into a cumulative regret: the total number of steps on which the policy disagrees with the expert. This formulation is convenient for theoretical analysis because it admits clean combinatorial arguments.

The key subtlety in both formulations is which state distribution the expectation is taken over. Behavior cloning minimizes cost under the *expert's* state distribution $d^{\pi^*}$, because that is where training data was collected. But the objective of interest — the cost during deployment — evaluates under the *learned policy's* state distribution $d^{\pi_\theta}$. These two distributions differ whenever $\pi_\theta \neq \pi^*$, and the mismatch is what causes behavior cloning to fail at long horizons. DAgger corrects this by collecting training data from $d^{\pi_\theta}$, closing the distributional gap iteratively.

## Analysis of Typical Behavior Cloning Case

![Tight Rope Walking](../lec01-SupervisedLearning/figures/tightRope.svg){width=60% #fig:tightrope}

To quantify the failure of pure behavior cloning, assume that for any state in the training distribution, the probability of the learned policy making a mistake is bounded:

$$p(\at \neq \pi^*(\st)|\st,\theta) \leq \epsilon$$

This is the per-step error rate achievable via supervised learning on $\data^*$. The question is how much total cost accumulates over a trajectory of length $T$, sketched in \autoref{fig:trajectory-training}.

\autoref{fig:tightrope} provides the analogy: walking a tightrope with small per-step error probability. Each step, the agent might slip with probability $\epsilon$. Staying on the rope requires making no mistakes for $T$ consecutive steps, which has probability $(1-\epsilon)^T \approx 1 - \epsilon T$ — vanishingly small for large $T$.

Once the agent makes a mistake, it enters a state outside the training distribution $\data^*$. From there, the error rate is no longer bounded by $\epsilon$; it can be arbitrarily large. The distribution of mistake states $p_{\text{mistake}}(\st)$ is unknown and worst-case. In the worst case, a single early mistake sends the agent into a region where every subsequent action is wrong.

The expected cumulative cost under behavior cloning expands by conditioning on whether a mistake occurs at each step. A mistake at step $t=0$ costs at most $T$ steps of regret; a mistake at $t=1$ given no prior mistake costs at most $T-1$; and so on:

$$\E\!\left[\sum_t c(\st,\at)\right] \leq \epsilon T + (1-\epsilon)\!\left(\epsilon(T-1) + (1-\epsilon)(\ldots)\right)$$

Summing the $T$ such terms, each of order $\mathcal{O}(\epsilon T)$, gives:

$$\E\!\left[\sum_t c(\st,\at)\right] \in \mathcal{O}(\epsilon T^2)$$

The dominant term is quadratic in $T$: as the task horizon grows, the cumulative error grows quadratically with respect to the per-step error rate. This means that even a very small per-step error rate $\epsilon$ leads to large total cost for long-horizon tasks. Halving $\epsilon$ through better modeling does not halve the deployment cost; it merely shifts the onset of serious failure to a somewhat longer horizon.

## Improved Dagger Algorithm

The full DAgger algorithm \citep{dagger} formalizes the dataset aggregation process with a mixing parameter $\beta_i$ that controls the transition from expert-guided to learner-guided exploration. At iteration $i$, the policy used for data collection is a mixture:

$$\pi_i = \beta_i \pi^* + (1 - \beta_i)\hat\pi_i$$

When $\beta_i = 1$, only the expert acts; when $\beta_i = 0$, only the learned policy acts. As $i$ increases, $\beta_i$ is annealed toward zero, so the agent gradually takes over. At first, the expert acts nearly all the time, providing clean demonstrations. As $\beta_i$ decreases, the agent acts for longer stretches, and the expert steps in only to provide corrective labels.

This schedule is crucial for building a dataset that covers both near-expert trajectories and recovery behaviors. Early iterations capture high-quality demonstrations; later iterations capture the long-range deviations and corrections that simple imitation misses. The aggregated dataset $D$ after $N$ iterations contains the state distribution of every mixed policy used across all iterations, which converges to covering the learned policy's own visitation distribution.

\begin{algorithm}
\caption{DAgger \citep{dagger}}
\begin{algorithmic}[1]
\State Initialize $D \leftarrow \emptyset$.
\State Initialize $\pi_1$ to any policy in $\Pi$.
\For{$i = 1$ to $N$}
    \State Let $\pi_i = \beta_i \pi^* + (1 - \beta_i) \hat{\pi}_i$. \Comment{anneal $\beta_i \rightarrow 0$}
    \State Sample $m$-step trajectories using $\pi_i$.
    \State Get dataset $\tau_i = \{(\bs, \pi^*(\bs))\}$ of states visited by $\pi_i$, actions labelled by expert.
    \State Aggregate: $D \leftarrow D \cup \tau_i$.
    \State Train $\pi_{i+1}$ on $D$.
\EndFor
\State \Return best $\pi_i$ on validation.
\end{algorithmic}
\end{algorithm}

The algorithm returns the best $\pi_i$ on a held-out validation set, rather than the final iterate, since individual iterations may overfit the states seen in that batch.

## Dagger Analysis

DAgger — short for Dataset Aggregator — is formalized as a reduction to no-regret online learning. At each round $i$, a policy $\hat\pi_i$ is selected and used to collect data; the loss is the per-step imitation cost $l(s,\hat\pi)$ under the induced state distribution $d_{\hat\pi}$. The key parameters in the analysis are: $N$, the total number of learning iterations (equivalently, the number of distinct policies trained); $\beta_i$, the probability of selecting an action from the expert $\pi^*$ at iteration $i$; $\gamma_N$, the average regret of the sequence $\hat\pi_{1:N}$ relative to the best fixed policy in hindsight; and $T$, the trajectory length.

For the full DAgger bound in the infinite-data case, the expected loss of the best policy found satisfies:

$$\E_{s \sim d_{\hat\pi}}\!\left[l(s, \hat\pi)\right] \leq \epsilon_N + \gamma_N + \frac{2 l_{\text{max}}}{N}\!\left[n_\beta + T \sum_{i=n_\beta+1}^{N} \beta_i\right]$$

Here $\epsilon_N$ is the supervised learning error achieved after $N$ iterations of training on the aggregated dataset, $l_{\text{max}}$ is the maximum possible per-step cost, and $n_\beta$ is the number of iterations for which $\beta_i > 0$ (iterations where the expert still acts). The remaining sum $T\sum_{i=n_\beta+1}^{N}\beta_i$ penalizes any residual mixing with the expert after the schedule has nominally reached $\beta_i = 0$ — once the agent is supposed to act autonomously, lingering expert influence slows convergence.

In the finite-sample case, where only $m$ trajectories are collected per iteration, a statistical estimation term appears:

$$\E_{s \sim d_{\hat\pi}}\!\left[l(s, \hat\pi)\right] \leq \epsilon_N + \gamma_N + \frac{2 l_{\text{max}}}{N}\!\left[n_\beta + T \sum_{i=n_\beta+1}^{N} \beta_i\right] + l_{\text{max}}\sqrt{\frac{2\log(1/\delta)}{mN}}$$

The additional term $l_{\text{max}}\sqrt{2\log(1/\delta)/(mN)}$ accounts for the statistical error from estimating the per-iteration loss on only $m$ samples, with $\delta$ as the failure probability. Collecting more trajectories per iteration (larger $m$) or running more iterations (larger $N$) both drive this term toward zero.

To interpret the bound, consider the limits of each parameter. As $N \to \infty$ and $\beta_i \to 0$, the third and fourth terms vanish, and the bound approaches $\epsilon_N + \gamma_N$. This is a linear function of $T$ through $\epsilon_N$ — a fundamental improvement over the $\mathcal{O}(\epsilon T^2)$ scaling of pure behavior cloning. Increasing $T$ makes the problem harder for behavior cloning quadratically; under DAgger, the dependence on $T$ is absorbed into $\epsilon_N$, which is controlled by how well the supervised learning step fits the aggregated data. As $m$ increases, the statistical term shrinks. As $\beta_i \to 0$ at all but the first few iterations, the mixing penalty disappears. The bound thus degrades gracefully with finite resources and approaches the fundamental limit set by the online learning regret $\gamma_N$.

## History of Improvements

![Imitation Learning History \citep{zheng2022imitation}](../lec01-SupervisedLearning/figures/imitationLearningHistory.png){width=90% #fig:imitation-history}

\autoref{fig:imitation-history} traces the development of imitation learning methods over several decades \citep{zheng2022imitation}. The progression reveals a recurring pattern: each generation of methods identifies a specific failure mode of its predecessors and proposes a structural fix.

Behavior cloning (1990s) established the supervised learning framework but exposed the distribution shift problem. DAgger (2011) addressed distribution shift by collecting on-policy corrections, at the cost of requiring interactive expert labeling. Inverse reinforcement learning approaches (mid-2010s) replaced the need for direct action supervision with reward learning, enabling the agent to generalize beyond the demonstrations. Adversarial imitation methods (GAIL, 2016) reframed the problem as distribution matching, connecting imitation to generative adversarial training. The most recent era is characterized by large-scale behavior cloning — RT-1, BC-Z, and related work — which returns to the basic BC formulation but applies it at data and model scales that were previously impractical, achieving generalization that earlier small-scale BC could not.

The history shows that no single approach has rendered the others obsolete. Each occupies a different point in the tradeoff between data cost (does it require interactive expert labeling?), distribution coverage (how well does it generalize?), and sample complexity (how much data does it require?).

# Deep Imitation Learning In Practice

![What could go wrong](../lec01-SupervisedLearning/figures/looksOkayElsewhere.svg){width=70% #fig:looksokayelsewhere}

## Deep Imitation Learning In Practice

Even after addressing distribution shift with DAgger, several deeper failure modes remain, and as \autoref{fig:looksokayelsewhere} warns, a policy that looks fine in one setting can fail badly elsewhere.

The Markovian assumption holds that the optimal action at time $t$ depends only on the current state $\st$, not on the history of states and actions that preceded it. In practice, this assumption is frequently violated. A robot picking up an object needs to know which object it already grasped, not just what it currently sees. An agent navigating a building needs to track which rooms it has visited. When the current observation does not uniquely determine the optimal action, conditioning only on $\ot$ forces the policy to make ambiguous decisions.

Causal confusion compounds this problem. Deep learning models are inclined to exploit any feature in the input that is statistically predictive of the output, regardless of whether that feature is causally related to the correct action. In a self-driving context, if braking is correlated with a dashboard indicator light — because the human demonstrator always presses the brake and triggers the light simultaneously — the trained policy may learn to stop whenever the light is on rather than whenever a pedestrian is in the road. The light is a non-causal correlate of stopping behavior, but it is just as predictive in the training data.

Expert behavior is often multi-modal: different experts, or the same expert in different moods, will take qualitatively different actions in identical situations. One driver may change lanes early on a highway; another may wait. A Gaussian policy trained on mixed demonstrations will produce a single mean action that corresponds to neither strategy — and may produce a dangerous intermediate behavior as a result. More expressive distribution models are required to represent multi-modal behavior faithfully.

## How Can The Agent Fail to Fit the Expert?

Behavior cloning rests on a set of assumptions about the structure of the decision problem and the demonstrations. Each assumption can be violated in practice, and each violation produces a characteristic failure mode. The central tension arises from the Markovian assumption embedded in the policy $\pi(\ba_t|\bs_t,\theta)$: the policy conditions on the current state $\st$ alone, implicitly assuming that $\st$ contains all information needed to select the optimal action. Under this assumption, the optimal policy is deterministic and consistent — it always produces the same action in the same state.

The history-conditioned policy $\pi(\ba_t|\bo_0,\ldots,\bo_t,\theta)$ relaxes this assumption by conditioning on the full observation sequence. This is closer to how the real world works: the optimal action frequently depends on where the agent has been, what it has touched, and what commitments it has already made. The disadvantage is practical — the input grows with $t$, inference becomes expensive, and longer histories expose the model to more spurious correlates.

The following table summarizes the key assumptions behavior cloning makes and the mechanism by which each is broken in practice.

| Assumption | BC formulation | How it breaks | Consequence |
|---|---|---|---|
| **Markov property** | $\pi(\ba_t \mid \st, \theta)$: current state is sufficient | Partial observability: $\ot$ does not reveal the full state $\st$ | Policy produces the same (wrong) action in observationally identical but contextually different situations |
| **i.i.d. distribution** | Test states are drawn from the same distribution as training demonstrations | Compounding errors shift the state distribution; the agent visits states the expert never saw | Error grows as $\mathcal{O}(\epsilon T^2)$ instead of $\mathcal{O}(\epsilon T)$ |
| **Causal identifiability** | Predictive features in $\ot$ are causally linked to the optimal action | Spurious correlations: non-causal features can be perfectly predictive in training data | Policy latches onto irrelevant cues that fail at test time when correlation breaks |
| **Unimodal expert** | Demonstrations follow a single consistent policy | Multi-modal behavior: different experts or moods yield qualitatively different actions in the same state | A unimodal policy (e.g., Gaussian) averages across modes, producing behavior that matches none of them |

Recognizing which assumption is violated in a given task guides the appropriate remedy. Distribution shift calls for on-policy data collection or DAgger. Partial observability calls for observation history or recurrent architectures. Causal confusion calls for data diversity or causal intervention. Multi-modal behavior calls for expressive distribution models such as Gaussian mixtures or diffusion policies.

## How to Learn From History

![Variable number of Frames/States](../lec01-SupervisedLearning/figures/vgg16-policy-choice-POMDP.pdf){width=90% #fig:pomdp-stack}

The simplest response to partial observability is observation stacking, illustrated in \autoref{fig:pomdp-stack}: instead of feeding a single observation $\ot$ to the policy, feed the last $k$ observations $\bo_{t-k+1}, \ldots, \ot$ as a concatenated input. This extends the policy's effective receptive field in time, giving it access to recent history. For tasks where the relevant context is contained within a short window — the direction of the last few robot joint movements, the position of an object two timesteps ago — this approach is effective and computationally cheap.

Its limitation is that $k$ must be fixed at training time, and the policy's capacity to summarize longer histories is constrained by the concatenation window. For tasks requiring long-range memory — remembering which objects were placed where at the start of a long manipulation sequence — frame stacking is insufficient.

## How to Learn From History

![Long Short Term Memory Example \citep{rumelhart1985learning,Hochreiter1997-zr}](../lec01-SupervisedLearning/figures/vgg16-policy-choice-POMDP-LSTM.pdf){width=80% #fig:pomdp-lstm}

Recurrent architectures — particularly LSTMs \citep{rumelhart1985learning,Hochreiter1997-zr}, shown in \autoref{fig:pomdp-lstm} — provide a principled mechanism for maintaining a compressed summary of the observation history. The LSTM hidden state $h_t$ is updated at each timestep from the previous hidden state and the current observation: $h_t = f(h_{t-1}, \ot)$. The policy then maps $(h_t, \ot) \to \at$, with $h_t$ serving as an implicit belief state. Because $h_t$ is computed by processing the full observation sequence, the policy's effective history is unbounded in principle, limited only by the LSTM's capacity to retain relevant information over long sequences.

More recently, Transformers \citep{vaswani2017attention} have emerged as strong alternatives for sequence modeling in policy learning \citep{ni2023transformers}. The self-attention mechanism allows the model to directly relate any observation in the input sequence to any other, without the information bottleneck imposed by compressing history into a fixed-size LSTM hidden state. For long demonstrations with complex temporal structure, Transformers tend to outperform LSTMs, particularly when training data is plentiful enough to support the larger model capacity.

The tradeoff between these approaches — observation stacking, recurrent networks, and Transformers — depends on the task's temporal structure, the available data volume, and the inference latency budget.

# Large Scale Behavior Cloning

As we increase the amount of data available to train out model we enter in the space of __large scale__ behavior cloning. 
With enough data and data augmentations models can develop strong genralization and robustness capabilities that make the models useful enough to use in the real world. This section introduces initial work in this area and discusses how to make behavior cloning models that are goal-conditioned and therefor multi-task models enabling more __taskable__ agents.

## BC-Z: Zero-shot task generalization with robotic imitation learning

![Mapping language and image to same encoding \citep{Jang2022-uu}](image.png){width=90% #fig:image}

BC-Z \citep{Jang2022-uu}, shown in \autoref{fig:image}, demonstrates that behavior cloning can generalize to novel task descriptions not seen during training, provided the task is specified via a shared embedding space. The key design choice is to map both language task descriptions and goal images into the same latent representation, then condition the policy on this embedding, similar to CLIP ~\citep{Radford2021-pq}. At training time, the policy learns across a large collection of tasks with associated language labels or goal images. At test time, a new task can be described by either modality — a language instruction the system has never encountered, or a goal image showing the desired outcome — and the policy generalizes via the shared embedding.

This approach illustrates a broader principle in large-scale BC: generalization at the task level is achieved by conditioning on rich task representations, not by making the policy unconditional. The behavior cloning objective remains unchanged; the change is in what the policy is conditioned on. With sufficient diversity in the training task distribution and a powerful enough encoder, the resulting policy exhibits zero-shot generalization to new task descriptions that are semantically close to training tasks.

![The BC-Zero network is a Resnet \citep{he2016deep}](image-1.png){width=90% #fig:image-1}

## Still, Model learning can be Lazy

![Learned models focus on the wrong indicators \citep{De_Haan2019-ub}](../lec01-SupervisedLearning/figures/causalConfusion.png){width=90% #fig:causal-confusion}

\autoref{fig:causal-confusion} illustrates a canonical example of causal confusion \citep{De_Haan2019-ub}: a self-driving system trained to stop for pedestrians inadvertently learns to stop when a dashboard brake indicator light activates, because the human demonstrator always pressed the brake pedal — activating both the light and the stopping behavior — simultaneously. The light is a non-causal correlate of the stopping behavior, but it is perfectly predictive in the training data.

Deep learning models exploit any feature that reduces training loss, regardless of causal structure. A feature can be causally irrelevant yet statistically sufficient for prediction in training data. The result is a policy that appears correct during training but fails catastrophically when the spurious correlate and the true causal variable diverge — for example, when the brake light malfunctions.

Including observation history helps partially: if the policy sees that the light activates only when the driver presses the brake, and the brake press correlates with the car slowing, it may disambiguate more of the causal chain. DAgger-style on-policy data collection can also help by forcing the policy into states where the spurious correlate is absent but the causal variable is present, requiring the model to learn from the true signal. Neither approach eliminates causal confusion entirely; they reduce its severity. The problem is ultimately one of causal identification from observational data, which supervised learning is not in general designed to solve.

## Give models More Data to Avoid Confusion

![RT-1: Robotics transformer for real-world control at scale \citep{Brohan2022-fw}](image-2.png){width=90% #fig:image-2}

RT-1 \citep{Brohan2022-fw}, shown in \autoref{fig:image-2}, demonstrates that large-scale behavior cloning can substantially mitigate causal confusion through data diversity alone. The system was trained on over 130,000 demonstrations collected across 700+ tasks with 13 robots over 17 months — a scale that exposes the policy to enough variation in the visual context that spurious correlates rarely appear consistently across the entire dataset. A feature that correlates with stopping in one task's recordings is unlikely to correlate with stopping across hundreds of other tasks, so the model cannot rely on it.

The architecture is a transformer that processes a sequence of image observations conditioned on a language instruction, using FiLM (Feature-wise Linear Modulation) \citep{Perez2018-pk} to integrate the language embedding into the visual processing stream. FiLM allows the language instruction to modulate the visual features in a learned, task-dependent way — emphasizing features that are relevant for the current task description rather than processing images unconditionally.

The result is a behavior cloning system that generalizes to novel task descriptions and novel object arrangements, achieves high success rates on held-out tasks, and is robust to distractors that would confuse smaller models trained on less diverse data. The lesson is that scale — in data, in tasks, and in model capacity — is a practical substitute for the causal identification that pure BC cannot provide in principle.

## Give Models More Data to Avoid Confusion: Humanoids

![Humanoid Locomotion as Next Token Prediction \citep{Radosavovic2024-rz}](image-5.png){width=90% #fig:image-5}

The behavior cloning paradigm extends naturally to humanoid locomotion, as in \autoref{fig:image-5}. Treating motor commands as a sequence of tokens, a transformer-based policy can be trained to predict the next motor command given the history of observations and past commands — the same next-token prediction formulation used in large language models \citep{Radosavovic2024-rz}.

Training data is collected from physics simulation using model-based controllers (which can generate unlimited data at low cost) and from motion capture of real human movements. The resulting policy, when deployed on a physical humanoid, produces locomotion behavior — walking, jogging, stair climbing — that has not been explicitly demonstrated on hardware, achieved through generalization from the diverse training distribution.

This result reinforces the pattern: at sufficient scale and diversity, behavior cloning generalizes beyond its training distribution. The key architectural choice — treating the policy as a sequence model and the control problem as next-token prediction — unifies robot learning with the scaling machinery that has proven so effective in natural language processing.

# Difficulty Modeling the Expert Data

![The Mean is Low Value](../lec01-SupervisedLearning/figures/dogJumpGap){width=90% #fig:dogjumpgap}

A fundamental tension in imitation learning arises when expert behavior is multi-modal — when there are two or more qualitatively different actions that are each reasonable in a given state. Consider the character of \autoref{fig:dogjumpgap} at the edge of a gap that can be traversed by either jumping or bounding. Both strategies are valid; individual experts choose one or the other. A policy trained by maximum likelihood with a unimodal output distribution (such as a single Gaussian) estimates the mean over the training data \citep{2016-TOG-deepRL}. The mean of a jump and a bound is an intermediate action that corresponds to neither strategy — and which, in the context of a gap with danger below, lands the character in exactly the wrong place.

Point estimates are inadequate because they collapse a distribution of valid behaviors to a single representative action. The training objective minimizes average loss across the dataset, which for a Gaussian distribution means finding the mean of the label distribution. When the label distribution is bimodal, the mean lies between the two modes — a location that is poorly supported by the data and often results in catastrophic behavior.

This failure is not a deficiency of neural networks in particular; it is a consequence of optimizing any unimodal distribution model on multi-modal data. Fixing it requires either more expressive output distributions or methods that explicitly model the multi-modal structure of expert behavior.

## Better Models

![Gaussian Mixture Model](../lec01-SupervisedLearning/figures/mixtureOfGaussians.svg){width=90% #fig:mixture-gaussians}

A mixture-of-Gaussians (MoG) policy replaces the single Gaussian output head with a weighted combination of $K$ Gaussian components, as in \autoref{eq:gaussianMixture}:

\begin{equation} \label{eq:gaussianMixture}
\pi(\at|\ot,\theta) = \sum_{i=1}^{K} \omega_i \mathcal{N}(\mu_i, \Sigma_i)
\end{equation}

Each component $i$ has its own mean $\mu_i$ and covariance $\Sigma_i$, and the mixture weights $\omega_i$ sum to one. In practice, the covariance is usually restricted to a diagonal matrix to reduce the number of output parameters. \autoref{fig:mixture-gaussians} illustrates the distribution shape: two or more separate peaks can be represented simultaneously, avoiding the pathological mean between modes.

The network architecture shares a common perception backbone (typically a convolutional or transformer encoder) that processes the observation $\ot$ into a rich representation. Multiple heads branch from this shared backbone — one set of heads per component $(\mu_i, \Sigma_i, \omega_i)$ — so the components share perceptual processing while maintaining separate action distributions. At execution time, the policy either samples from the full mixture or selects the highest-weight component.

Beyond Gaussian mixtures, three families of more expressive output models have been applied to multi-modal imitation, each trading off representational power against inference cost.

## Diffusion Models For Multiple Modes

![Stable Diffusion Model](image-3.png){width=70% #fig:stable-diffusion}

![Diffusion process on an image](image-4.png){width=70% #fig:diffusion-process}

Diffusion models \citep{Rombach2022-gg,Saharia2022-id} learn action distributions implicitly by training a network to reverse a noise injection process. The forward process gradually corrupts a clean action sample with Gaussian noise over $T$ steps; the reverse process, illustrated in \autoref{fig:diffusion-process}, is a learned denoiser that recovers the original distribution step by step from pure noise. For action generation, the denoiser is conditioned on the current observation $\ot$ and any task descriptor, so the resulting distribution is both observation-conditional and expressive enough to represent arbitrary multi-modal structure.

Sampling an action requires running the full reverse denoising chain — typically 10 to 100 steps — which is more computationally expensive than a single forward pass through a Gaussian or MoG head. The practical benefit is that the practitioner does not need to specify the number of modes or choose a parametric family in advance: the network discovers the modes from data, placing probability mass wherever the training demonstrations cluster. Diffusion policies \citep{Chi2024-ep} have achieved strong results on manipulation benchmarks with highly multi-modal demonstration data, precisely because they impose no structure on the shape of the output distribution.

## Better Models: Variational Autoencoders

![Latent variable policy model](../lec01-SupervisedLearning/figures/latentVariableModelExample.png){width=70% #fig:latent-vae}

Variational autoencoders (VAEs) model the action distribution through a latent variable $z$: the policy samples $z \sim q(z|\ot)$ from a learned encoder, then decodes $\at \sim p(\at|z,\ot)$ through a learned decoder. The latent variable captures the discrete structure of multi-modal expert behavior — different values of $z$ correspond to different modes — while the decoder maps each $z$ to a smooth, unimodal action distribution conditional on that mode. Training uses the evidence lower bound (ELBO), which encourages the latent space to be well-organized and the reconstructed actions to match the expert data.

Conditional VAEs (CVAEs) extend this to condition both encoder and decoder on additional context such as the task description or a goal image, as in \autoref{fig:latent-vae}. Related approaches include normalizing flows (which model the action distribution as an invertible transformation of a simple base distribution) and Stein variational gradient descent (which maintains a particle approximation of the posterior). All three are more tractable to train than diffusion models — they require a single forward pass at inference — but are more constrained in the distributions they can represent.

## Better Models: Autoregressive Models

![Autoregressive policy model](../lec01-SupervisedLearning/figures/autogressiveModel.png){width=70% #fig:autoregressive}

Autoregressive models factorize the joint action distribution across action dimensions. Rather than predicting all action dimensions simultaneously, the policy predicts each dimension conditioned on the previous ones. For a two-dimensional action $(x_t, y_t)$, the factorization is:

$$\pi(x_t|\ot,\theta_x) \cdot \pi(y_t|\ot,x_t,\theta_y)$$

The first network $\pi(x_t|\ot,\theta_x)$ predicts the $x$-component from the observation alone; the second network $\pi(y_t|\ot,x_t,\theta_y)$ predicts the $y$-component given both the observation and the sampled $x$, as illustrated in \autoref{fig:autoregressive}. This chain rule factorization is exact — no approximation is made — and the product is arbitrarily expressive as a distribution over action vectors.

The cost is sequential sampling: all $D$ action dimensions must be predicted one at a time, requiring $D$ forward passes per timestep instead of one. For high-dimensional action spaces (whole-body robot control, dexterous hand manipulation), this can be expensive. Autoregressive action prediction has nonetheless been adopted in several large-scale robot learning systems where the expressiveness of the output distribution is worth the inference cost.

# Action Chunking

All of the output distribution models above — Gaussian mixtures, diffusion, VAEs, and autoregressive factorizations — address the problem of matching the policy's output distribution to the multi-modal structure of expert data. A complementary approach, action chunking, addresses the problem of how long a policy must plan without querying new observations. Rather than changing the output distribution, action chunking changes the fundamental granularity of the prediction: instead of predicting a single action $\at$ at each timestep, the policy predicts a sequence of $k$ actions $\langle\ba_t, \ba_{t+1}, \ldots, \ba_{t+k}\rangle$ as a single unit. All $k$ actions in the chunk are then executed in sequence before the policy is queried again.

\begin{figure}[h!]
\centering
\input{../lec01-SupervisedLearning/figures/ActionChunking.tex}
\caption{
Action Chunking: Group actions together into sequences.
}
\label{fig:Action-chunking}
\end{figure}

Action chunking groups $k$ consecutive actions into a single prediction unit: the policy outputs an action chunk $ac_t = \langle \ba_t, \ba_{t+1}, \ldots, \ba_{t+k}\rangle$ rather than a single action $\ba_t$. All $k$ actions in the chunk are executed in sequence before the policy is queried again. The mechanism is not new — frameskip in the Atari reinforcement learning literature \citep{mnih2015human} repeats a single action for $k$ frames, effectively reducing decision frequency — but the idea of predicting an explicit multi-step sequence rather than a repeated single action adds expressive power.

The key benefit for behavior cloning is its effect on the effective horizon. The $\mathcal{O}(\epsilon T^2)$ error bound from the distributional shift analysis has $T$ in the denominator through the number of independent prediction steps. With action chunking, the number of policy queries over a trajectory of length $T$ is reduced from $T$ to $T/k$. The effective horizon is $T/k$, and the quadratic penalty becomes $\mathcal{O}(\epsilon (T/k)^2) = \mathcal{O}(\epsilon T^2 / k^2)$ — a factor of $k^2$ reduction in worst-case error for the same per-prediction error rate $\epsilon$. Halving the chunk size quadruples the error; doubling it reduces error by four times.

\autoref{fig:Action-chunking} illustrates the grouping: a sequence of time steps is divided into non-overlapping chunks, each predicted as a unit by a single policy query.

## Action Chunking for Robotics

Two distinct strategies address the partial observability problem in robotic imitation:

**Option 1 — observation history.** The policy $\pi(\ba_t|\bo_{t-k},\ldots,\bo_t,\theta)$ receives the last $k$ observations as input, allowing it to infer aspects of the hidden state from the observation sequence. This approach can, in principle, learn an accurate belief state if the history window is long enough. The disadvantages are practical: the context size grows with $k$, increasing memory and compute requirements; and longer context windows expose the model to more spurious correlations, increasing the risk of causal confusion \citep{De_Haan2019-ub,swamy2022causal}. If a non-causal feature appeared consistently in the recent history of demonstrations, the model will attend to it.

**Option 2 — action sequence prediction.** Instead of expanding the input, the policy predicts a chunk of $k$ future actions given the current observation: $\pi(\langle\ba_t,\ldots,\ba_{t+k}\rangle|\bo_t,\theta)$. The future action sequence encodes an implicit belief — by committing to actions that make sense given hidden state $h_t$, the policy reveals what it believes the hidden state to be. The context is short (just the current observation), reducing causal confusion risk and inference cost. The ACT framework \citep{Zhao2023-vm} realizes this approach with a transformer decoder that generates action sequences conditioned on proprioceptive and visual observations. The main disadvantage is jittery control at chunk boundaries, addressed by the smoothing techniques discussed next.

## Action Chunking Meets Deep Learning

Training action-chunking policies on real robot datasets exposes several dataset pathologies that interact poorly with gradient-based optimization.

First, many robotics datasets contain long stretches of the same action: a robot arm holds a grasped object steady for several seconds, or a mobile robot drives straight for extended periods. When a model is trained to predict a single next action, the loss is dominated by these long constant-action sequences. Stochastic gradient descent finds the easiest solution: predict the average action across the dataset for any ambiguous state. Predicting a chunk of $k$ actions rather than a single action forces the model to predict the variation *within* each chunk, providing gradient signal proportional to the temporal complexity of the behavior rather than its duration.

Second, when the input includes recent past actions (for belief estimation via option 1), the model can learn a near-trivial solution: copy the most recent action. If the last action at time $t-1$ is $\ba_{t-1}$ and consecutive actions in the training data are often identical, the identity function $\pi(\ba_t|\ldots,\ba_{t-1}) = \ba_{t-1}$ achieves low loss. This lazy solution ignores the visual input entirely and produces a frozen policy that never adapts to the current scene.

Both pathologies illustrate the same principle: gradient descent finds the simplest function that fits the training loss. The problem formulation — what inputs are provided and what the model is required to predict — must be structured to make the lazy solution unavailable, forcing the model to attend to the features that actually drive correct behavior.

## Action Chunk Smoothing

![Control Discountinuities](../lec10-SequenceModelsAndAux/figures/box.svg){width=70% #fig:box}

When consecutive action chunks are executed back to back, the boundary between them can produce abrupt control discontinuities, as in \autoref{fig:box}. The chunk ending at $t+k$ and the chunk starting at $t+k+1$ are generated by two independent policy queries, each optimized for internal consistency but unaware of each other. The last action of one chunk may point the robot in a direction inconsistent with the first action of the next chunk, producing a sudden jerk in the trajectory.

Model averaging addresses this by predicting a new chunk at every observation, then averaging the predictions across the overlapping windows. At timestep $t$, the policy has predicted chunks starting at $t-k+1, t-k+2, \ldots, t$ — all of which include a prediction for what action to take at time $t$. Averaging these $k$ predictions smooths the control signal: any single chunk's unusual action at the overlap point is attenuated by the other chunks' predictions, which were generated from adjacent observations and therefore encode slightly different views of the current context.

This approach trades off temporal consistency for smooth control. The effective chunk length is still $k$, but each executed action incorporates information from $k$ policy queries rather than one. The computational cost increases by a factor of $k$, which motivates the inference optimization discussed next.

## Action Chunk Inference is Expencive

Real-time robot control requires action decisions at frequencies of 10–100 Hz, depending on the task dynamics. Transformer-based vision-language-action (VLA) models — which process high-dimensional image inputs, language embeddings, and proprioception through large architectures — often require 0.5 seconds or more per inference pass on current hardware. A 0.5-second inference time corresponds to a maximum query rate of 2 Hz, far below the control frequency needed for precise manipulation or fast locomotion.

The solution is to increase action chunk size $k$ to match the inference latency. If the model requires 0.5 seconds per forward pass and the control loop runs at 50 Hz, a chunk of size 25 allows the robot to execute 25 pre-planned actions (0.5 seconds of control) while the next chunk is being computed. The model now queries at 2 Hz while the robot acts at 50 Hz — inference and execution proceed in parallel.

Larger chunks reduce the effective decision frequency and can make the policy less responsive to unexpected changes in the environment (e.g., an object that moves during execution). This is an active engineering tradeoff: larger chunks improve computational tractability but reduce agility. Methods that predict very long action sequences, or that use efficient model architectures to reduce per-query latency, are active research directions.

## Review: Behaviour Cloning

![Behaviour Cloning](../lec01-SupervisedLearning/figures/BehaviourCloning.svg){width=70% #fig:behaviourcloning}

Behavior cloning, summarized in \autoref{fig:behaviourcloning}, is the natural starting point for any imitation learning problem, but it is often insufficient when deployed on long-horizon tasks. The distribution mismatch between training states (from $d^{\pi^*}$) and deployment states (from $d^{\pi_\theta}$) causes errors to compound, producing the $\mathcal{O}(\epsilon T^2)$ degradation derived earlier.

When behavior cloning does work well, one of several conditions typically holds: the task horizon is short enough that compounding errors do not dominate; the training distribution is stable and the deployed policy rarely visits out-of-distribution states; or the dataset is large enough to cover most of the states the policy will encounter. Self-contained tasks with narrow state distributions — a robot repeatedly performing the same pick-and-place motion — are more amenable to pure BC than open-ended navigation or multi-step manipulation.

Adding on-policy data through DAgger, using more expressive output distributions (Gaussian mixtures, diffusion), and scaling up both model and dataset size each address distinct failure modes. Training across data collected from multiple human demonstrators has an additional benefit: individual experts have idiosyncratic biases and suboptimal habits. When a policy is trained on the aggregate of many demonstrators, the idiosyncratic behaviors average out, and the shared, more principled aspects of the task receive stronger gradient signal. The resulting policy can exhibit more robust generalization than any single demonstrator would produce in isolation.

## Review: The Curse of T

![The curse of $T$](../lec01-SupervisedLearning/figures/the-curse-of-T.png){width=90% #fig:curse-of-T}

\autoref{fig:curse-of-T} depicts the $\mathcal{O}(\epsilon T^2)$ relationship: as the task horizon $T$ grows, the worst-case expected cost grows quadratically for a fixed per-step error rate $\epsilon$. This is the central challenge for behavior cloning applied to long-horizon robotics tasks.

Two levers are available for reducing this curse. The first is improving the model to reduce $\epsilon$ — the per-step error rate on the training distribution. Better architectures, larger datasets, and more expressive output distributions all contribute. However, reducing $\epsilon$ by half only reduces the total expected cost by half, because the bound is linear in $\epsilon$. If $T$ is large, even a very small $\epsilon$ still produces large total error.

The second lever is reducing the effective horizon $T$ through action chunking \citep{Zhao2023-vm}. Predicting a chunk $\langle a_i, \ldots, a_{i+k}\rangle$ as a single unit reduces the number of independent policy queries from $T$ to $T/k$, pushing the bound to $\mathcal{O}(\epsilon (T/k)^2) = \mathcal{O}(\epsilon T^2/k^2)$. In recent manipulation work, chunk sizes of 25 to 100 timesteps are common, reducing the quadratic penalty by factors of 625 to 10,000. This is why action chunking has become standard in state-of-the-art behavior cloning systems.

# Learning from Demonstration

Imitation learning is broadly defined as training a policy to reproduce behavior from a dataset: find model parameters $\theta$ such that $p(\bo|\theta) = p(\bo|\data)$, where $\data$ is a collection of observed trajectories. This framing encompasses a wide family of methods that differ in what they observe, what supervision they receive, and what they learn.

Behavior cloning — described in previous sections — is the simplest member of this family: it directly fits a policy to (observation, action) pairs via supervised learning. The remaining methods in the family address specific limitations of behavior cloning by bringing in additional structure or additional interactions with the environment.

Inverse dynamics models infer missing action labels from observation-only data. Inverse reinforcement learning recovers a reward function rather than imitating actions directly, enabling generalization beyond the demonstrations through RL. Distribution matching methods (including adversarial approaches) match the state-action visitation distribution of the policy to the expert rather than minimizing pointwise action prediction error. Partially observed imitation learning methods handle cases where action data is unavailable entirely. A survey of these methods in the robotics context can be found in \citep{ROB-053}.

## Inverse Dynamics Models

![What Action Caused This?](../lec01-SupervisedLearning/figures/IDMexp.png){width=85% #fig:idm-example}

The Internet contains vast quantities of video data — people performing everyday tasks, professional demonstrators, cooking shows, sports footage. This data shows what happens but not what actions caused it: the actions (joint torques, control signals, button presses) are not recorded. Standard behavior cloning cannot use this data directly because it requires (observation, action) pairs.

Inverse dynamics models (IDMs) \citep{bayo1989inverse,asada1990inverse,wada1993neural,nguyen2008learning} address this by learning a model $p(\at|\st,\stt)$ that predicts what action was executed between two consecutive states $\st$ and $\stt$. The problem is framed as supervised learning given state transitions: for any pair $(\st, \stt)$ where the action $\at$ is known, the IDM is trained to predict $\at$. Once trained, the IDM can be applied to observation-only data — video frames, for example — to infer the likely action that caused each transition.

\autoref{fig:idm-example} illustrates the question the IDM answers: given before and after images of a scene, what manipulation action (grasp, push, lift) was performed? For robotics, this allows a small set of fully-annotated demonstrations to bootstrap annotation of a much larger unlabeled video corpus, exponentially increasing the training data available for the final behavior cloning policy.

## Inverse Dynamics Models: Generating Data

![Video Pretraining (VPT) Method Overview \citep{baker2022video}](../lec01-SupervisedLearning/figures/VPT.png){width=85% #fig:vpt}

The common use case for IDMs exploits the asymmetry between observation-rich and action-labeled data. Video of humans performing tasks — cooking, assembly, Minecraft gameplay — is available at enormous scale and essentially zero marginal cost. Data that includes actions (teleoperation logs, controller recordings) is expensive to collect and requires specialized setup.

The IDM pipeline, illustrated in \autoref{fig:vpt}, uses a small amount of action-labeled expert data $\data_{exp}$ to train the IDM, then applies the trained IDM to pseudo-label a much larger observation-only dataset $\data_{wild}$. The pseudo-labeled dataset is then used to train the final behavior cloning policy.

Video Pretraining (VPT) \citep{baker2022video} demonstrated this at large scale for Minecraft: approximately 2,000 hours of contractor gameplay with keyboard-and-mouse actions were used to train an IDM; the IDM was then applied to 70,000 hours of unlabeled internet gameplay video to generate pseudo-labeled action annotations; a large transformer policy was trained on the combined dataset. The resulting foundation model showed strong zero-shot behavior and could be fine-tuned with a small amount of additional expert data to acquire specific skills. The IDM approach thus makes it possible to leverage the orders-of-magnitude more data available in the wild compared to expert-annotated datasets.

## Inverse Dynamics Models: Algorithm

The IDM pretraining algorithm requires two datasets: a small expert dataset $\data_{exp}$ with both states and actions, and a large observation-only dataset $\data_{wild}$ with only states. The expert dataset is used exclusively to train the IDM $\pi(\at|\st,\stt,\phi)$ — it is never used directly to train the final policy. The IDM is then applied to generate pseudo-action labels for $\data_{wild}$, converting it to a fully-labeled dataset suitable for behavior cloning.

The key advantage is data efficiency at the policy level: the expensive expert data requirement is confined to the IDM, which is a simpler model (it only needs to infer actions from state transitions, without needing to generate actions from observations alone). In practice, relatively small amounts of expert data are sufficient for the IDM, because the state-transition-to-action mapping is a more constrained problem than the full observation-to-action mapping.

A practical benefit of the IDM formulation is debuggability: the IDM's predictions can be evaluated independently of the policy. If the IDM is producing clearly wrong action labels in a specific region of state space — visible from the fact that the inferred actions produce transitions inconsistent with the training data — this signals that $\data_{exp}$ needs more coverage of that region. This interpretability makes the IDM pipeline easier to diagnose and improve than end-to-end behavior cloning on unlabeled data.

## Behaviour Cloning

\begin{equation}
    \label{equation:behaviour-cloning}
    \max_{\theta} \expectation_{\pi_{E}}[\sum_{t = 0}^{T} \log \pi(\ba_{t}| \bs_{t}, \theta )]
\end{equation}

Behavior cloning \citep{bain1995framework} formally maximizes the log-likelihood of the expert's actions under the learned policy. Given a collection of expert trajectories $\trajectory = \langle(\bs_0,\ba_0),\ldots,(\bs_T,\ba_T)\rangle$, the objective is:

$$\max_\theta \E_{\pi_E}\!\left[\sum_{t=0}^T \log\pi(\ba_t|\bs_t,\theta)\right]$$

This is a maximum likelihood estimation problem over the conditional distribution $\pi(\ba_t|\bs_t,\theta)$. For a Gaussian policy, maximizing log-likelihood is equivalent to minimizing mean squared error between predicted and expert actions. For a categorical distribution over discrete actions, it is equivalent to minimizing cross-entropy.

The simplicity of this objective is its main advantage: any supervised learning infrastructure — stochastic gradient descent, automatic differentiation, pre-trained feature extractors — applies directly. The main disadvantage is the distribution mismatch discussed at length in earlier sections: the expectation is taken over states sampled from the *expert's* state distribution $d^{\pi_E}$, not the *learner's* deployment distribution. This discrepancy grows as the learned policy deviates from the expert, producing the quadratic error scaling with task horizon.

## Distribution Matching

Behavior cloning minimizes prediction error at each state independently: for every $(s,a)$ pair in the expert dataset, the loss penalizes disagreement between $\pi_\theta(\ba|\bs)$ and $\ba$. This pointwise objective does not directly constrain the global distribution of states the policy visits. Distribution matching methods take a different objective: rather than matching the expert's actions state by state, they match the expert's *state-action visitation distribution* $d^{\pi^*}(\bs,\ba)$ as a whole.

The key insight is that distribution shift arises because $d^{\pi_\theta}(\bs,\ba) \neq d^{\pi^*}(\bs,\ba)$: the policy visits different states than the expert did, and the training signal was computed only over the expert's states. A policy trained to make $d^{\pi_\theta}(\bs,\ba) = d^{\pi^*}(\bs,\ba)$ cannot suffer distribution shift by definition. The challenge is that this distribution-level objective is harder to optimize than pointwise prediction error: computing $d^{\pi_\theta}$ requires rolling out the policy in the environment, and comparing two trajectory distributions requires a distance metric that is tractable to optimize.

In practice, distribution matching is approximated through adversarial training or through maximum entropy objectives. The adversarial formulation, described in the next section, trains a discriminator to distinguish the policy's visitation distribution from the expert's, and uses the discriminator's output as a reward signal for policy optimization. This approach recovers a distribution-matching objective without requiring an analytic form for $d^{\pi_\theta}$ or $d^{\pi^*}$.

## Inverse Reinforcement Learning

\begin{equation}
    \label{equation-IRL}
    \max_{c \in C} \min_{\pi} (\expectation_{\theta}[c(\bs, \ba)] - H(\pi(\ba|\bs,\theta)) ) - \expectation_{\data_{\text{train}}}[c(\bs, \ba)]
\end{equation}

Inverse reinforcement learning (IRL) reframes imitation as reward learning rather than action cloning. Instead of directly copying actions, IRL recovers a cost function $c(\bs,\ba)$ that characterizes what the expert is trying to achieve, then uses this cost function as a reward signal to train a policy via RL. The recovered reward generalizes across states not covered by the demonstrations, because the policy can optimize $r_t = -c(\bs_t,\ba_t)$ in novel situations.

Maximum entropy IRL \citep{Ziebart:2008:MEI:1620270.1620297} formalizes this as a max-min optimization over cost functions $c \in C$ and policies $\pi$:

$$\max_{c \in C} \min_\pi \left(\E_\theta[c(\bs,\ba)] - H(\pi(\ba|\bs,\theta))\right) - \E_{\data_{train}}[c(\bs,\ba)]$$

The outer maximization over $c$ looks for a cost function that is high for the learned policy but low for the expert demonstrations. The inner minimization over $\pi$ finds the best response to the current cost function while maintaining high entropy $H(\pi)$ — the entropy term prevents the solution from collapsing to a deterministic policy and ensures that ambiguous states are handled probabilistically. The resulting $c$ is the cost function for which the expert appears most rational and the learned policy performs worst, serving as the most discriminating reward for RL training.

IRL is more powerful than BC in principle — it can generalize to states never visited by the expert — but it is computationally expensive: the inner minimization requires solving an RL problem at each outer iteration. This cost motivates the adversarial approaches that approximate IRL more efficiently.

## Adversarial Methods

\begin{equation}
    \label{eq:GAIL}
  \min_{\theta} \max_{\phi} \expectation_{\pi_{E}}[\log( D(\bs, \ba | \phi))] + \expectation_{\pi_{\theta}}[\log( 1- D(\bs, \ba | \phi))]
\end{equation}

Generative Adversarial Imitation Learning (GAIL) \citep{NIPS2016_6391} connects imitation learning to generative adversarial training. A discriminator $D(\bs,\ba|\phi)$ is trained to distinguish state-action pairs from expert trajectories (positive examples) from pairs generated by the current policy (negative examples). The policy is trained adversarially to fool the discriminator — to produce state-action pairs indistinguishable from the expert's. The adversarial objective is given in \autoref{eq:GAIL}:

$$\min_\theta \max_\phi \E_{\pi_E}[\log D(\bs,\ba|\phi)] + \E_{\pi_\theta}[\log(1 - D(\bs,\ba|\phi))]$$

The discriminator's output $D(\bs,\ba|\phi)$ serves as a dense reward signal for RL: state-action pairs that look expert-like receive reward close to 0; pairs that look unlike the expert receive reward close to 1 (to be minimized). This connection to RL makes GAIL more robust to distribution shift than behavior cloning — the policy can optimize via environment interaction, not just on fixed demonstration data.

The practical limitation of GAIL \citep{NIPS2016_6391,DBLP:journals/corr/MerelTTSLWWH17} is that it requires ongoing access to the expert policy for online sampling. The policy must collect fresh rollouts and compare them to fresh expert samples at every training step. When demonstrations are fixed and the expert is unavailable, this continuous sampling requirement cannot be met. Extensions such as offline GAIL variants relax this requirement, but introduce additional distributional shift challenges.

## Partially Observable Imitation

![VisualImitationLearning](../lec01-SupervisedLearning/figures/ImitationLearningData.svg){width=35% #fig:imitation-data}

The methods described so far assume access to action labels in the demonstration data, or at minimum to an interactive expert who can provide actions on demand. A more challenging setting arises when only observations are available — for example, when learning from internet video where no action recording was made.

GAILfO \citep{torabi2018generative} extends GAIL to the observation-only setting. The discriminator now operates on state-transition pairs $(\bs_t, \bs_{t+1})$ rather than state-action pairs $(\bs_t, \ba_t)$, since actions are not available. The policy is trained to produce transitions that are indistinguishable from the expert's observed transitions. This removes the action-supervision requirement but retains the requirement for ongoing access to an expert policy for sampling \citep{DBLP:conf/icml/0002VBB19,NIPS2019_8317}.

Methods that work from a single fixed demonstration address the further challenge of the expert policy being unavailable entirely \citep{VizImitation}. These approaches often combine an inverse dynamics model (to infer a plausible action sequence from the demonstration) with environment interaction to refine the policy, potentially even transferring behavior across robots with different dynamics from the same observation sequence. The trade-off is increased dependence on the quality of the IDM and the accuracy of the inferred dynamics model.

\autoref{fig:imitation-data} shows the variety of supervision available across different imitation learning settings: full (state, action) pairs; state-only sequences; or even partial observations from a third-person view.

## Main points

Behavior cloning is the natural starting point for robot learning from demonstrations. Its simplicity — supervised learning on (observation, action) pairs — makes it straightforward to implement and often surprisingly effective at short horizons. The compounding error analysis shows why it fails at long horizons: a per-step error rate $\epsilon$ leads to $\mathcal{O}(\epsilon T^2)$ cumulative cost, which grows quadratically with the task length.

DAgger corrects distribution shift through iterative dataset aggregation, but requires a human expert to label on-policy states at each iteration — a cost that limits its practical applicability. The theoretical improvement is substantial: the error bound drops to $\mathcal{O}(\epsilon T)$ with sufficient iterations, linear rather than quadratic in $T$.

At scale, behavior cloning generalizes more than its theoretical analysis suggests. Systems like RT-1 and BC-Z demonstrate that training on 100,000+ demonstrations across hundreds of tasks produces policies that generalize to novel instructions and object arrangements — not because the theory changes, but because data diversity prevents any spurious correlate from being consistently predictive.

Multi-modal expert behavior requires expressive output distributions. Gaussian mixture models, diffusion policies, VAEs, and autoregressive factorizations each capture different aspects of this multi-modality, with different trade-offs between expressiveness and inference cost.

Action chunking reduces the effective horizon from $T$ to $T/k$, shrinking the quadratic error penalty by a factor of $k^2$ and simultaneously decoupling inference latency from control frequency. It has become a standard component of state-of-the-art behavior cloning systems for robot manipulation.

The progression from pure BC through DAgger, scale, and better output models illustrates a recurring pattern in robot learning: each structural limitation of a simpler approach motivates a principled extension, and the extensions can be combined. A modern large-scale behavior cloning system might use DAgger-style on-policy data collection, a transformer architecture conditioned on language goals, a diffusion output head, and action chunking — addressing distribution shift, partial observability, multi-modality, and horizon simultaneously.

