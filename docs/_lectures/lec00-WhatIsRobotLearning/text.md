---
title: "Foundations of Robot Learning: Scaling Learning for Real-World Agents"
author: Glen Berseth
date: Jan 5, 2022
published: false
header-includes: 
    - \input{../defs.md}
---

# Ingredients and Challenges in Real-World (Robot) Learning

![Current robots are deployed in controlled, repetitive settings such as manufacturing, fulfillment, and transportation.](figures/current-robot-use.svg){width=80% #fig:current-robot-use}

#### Why Study Robotics?

Robots are already in the news, and the money being invested in them keeps climbing, which is itself a signal that something important is still missing. If robotics worked as well as it appears to in demo videos, this would not be a research field — it would be a solved engineering problem. This course is about the gap between the two: why current systems fall short of the robots we actually envision, and what has to change to close that gap. Understanding the revolution underway requires first taking an honest look at where things stand today.

#### Robots: Common, But Limited

Robots are not new. They have been around for a long time and are already all around us, as \autoref{fig:current-robot-use} shows. *Eric* (1928), built by W. H. Richards and Alan Reffell for the Society of Model Engineers exhibition in London, is one of the earliest documented humanoid robots. Constructed from aluminium with eleven electromagnetic motors, Eric could rise from a seated position, deliver pre-programmed speeches, and turn his head — all controlled by radio signals or voice commands. He toured England and the United States to considerable public fascination. The mechanical idea of a robot, in other words, long preceded any capacity for learning or adaptation. A faithful reconstruction now resides at the Science Museum in London.

Robots today are essential helpers in a handful of key industries. In manufacturing they assemble cars on a factory line; in fulfillment they package and sort items in large warehouses; in transportation they move materials around controlled areas like hospitals or factories. In every one of these settings, though, the skills involved are severely limited.

#### The "Brittleness" of Current Systems

The limitation is structural: most robots operate in highly controlled environments. Consider the robots attaching doors on a car assembly line. They don't require "intelligence" or even "eyes" — they execute the same repetitive process over and over, inside a manufacturing process engineered to tolerances small enough that adaptability is never needed. This is what a pre-scripted behavior is: a very limited ability to respond to anything outside exact programming.

That limitation makes these systems brittle. In some advanced manufacturing plants, a single speck of dust entering the building can force the entire line to shut down, be cleaned, and restart. A robot that cannot adapt to even minor, unexpected changes is not reusable and not flexible. Closing this gap — building systems that can adapt rather than merely repeat — is the project of modern robotics and machine learning.

## Robots can be Better Tools

![A range of prospective future robot applications, from household assistance to ecological restoration to flexible manufacturing.](figures/future-robot-use.svg){width=80% #fig:future-robot-use}

### Robots as Better Tools for Society
Pursuing more advanced robotics is not merely a technical exercise; it is an attempt to build tools that materially improve human life and societal resilience. The next generation of robotic systems can address several needs that go beyond simple automation, moving toward genuine augmentation of human capability.

#### Reclaiming Time for Creativity and Care
One of the most direct benefits of advanced robotics is reclaiming human time. Automating mundane or laborious tasks — household chores, maintenance, manual labor — frees people to pursue creative, intellectual, or restorative activities instead.

History offers a useful example. Albert Einstein developed some of his most important ideas while working at a patent office, using his spare time for deep, creative thought. Reducing the burden of obligatory labor maximizes this kind of space for more people, not just for the fortunate few.

The same reclaimed time could fund large-scale, long-term projects that are currently unfeasible. Ecological restoration is one example: the dedicated, long-term care needed to plant and tend new forests can revitalize entire landscapes and rebuild ecosystems, but only if enough labor is available to sustain the effort. Robotics that can take on this labor would let more such restorative projects flourish.

#### Enhancing Human Agency and Support
Robotics can also enhance human agency directly, particularly for aging populations or people who need assistance. As people age, daily tasks become harder and support systems are often strained. Intelligent robotic systems that assist with mobility or household management can provide critical support — greater independence, dignity, and quality of life — precisely where human caregiving capacity is limited.

#### Building Agile and Responsive Production
The current model of mass production is rigid. It is highly efficient at producing large quantities of a single item, and exceptionally slow and costly to adapt to a different one. That inflexibility is a real liability.

Building a new manufacturing line — for an electric car, say — can take five years to construct the facility and another five to install and fine-tune the automated systems. A ten-year lag from concept to production is untenable in a world that changes at an accelerating pace; a ten-year plan is often obsolete within three or four years.

Society needs the ability to adjust much faster, whether responding to a public health crisis that demands rapid vaccine production or adapting to new economic and environmental realities. More adaptable robotics is what makes a responsive manufacturing base — one that can be re-tasked quickly — possible.

#### Efficiency in Space and Resource Management
Robotics can also make society more efficient with its use of space and resources. Several companies already use robotics to sort and process waste, enabling recycling at rates manual sorting cannot match.

The same principle extends to food production. Indoor vertical farming uses space far more efficiently than traditional agriculture, and robotics can manage the planting, care, and harvesting that make it possible to expand these operations. Because vertical farming does not rely on the pesticides and chemicals that contaminate water supplies, scaling it up preserves a critical natural resource while increasing food security.

More time, greater agency, responsive production, resource efficiency — these benefits, illustrated in \autoref{fig:future-robot-use}, are compelling enough to motivate the field. They also frame the question this course spends the rest of its time on: how must research advance to achieve these goals at a responsible and effective pace?

## Generalist Robotics Policies

![A Generalist Robotics Policy (GRP): a single agent capable of performing a wide range of tasks across diverse embodiments.](figures/GRP.png){width=70% #fig:grp}

![The tasks-by-morphologies grid: rows represent robot embodiments, columns represent tasks. An ideal GRP achieves high performance across the full grid.](figures/morphology-task-grid.svg){width=55% #fig:morph-task-grid}

A central question in modern robotics is whether a Generalist Robotics Policy (GRP) is feasible: a single agent, illustrated in \autoref{fig:grp}, that adapts across many tasks and environments. Decades of research have chased this objective, and it remains difficult because flexibility, sample efficiency, and stability all have to improve together — none of them can be solved in isolation.

The tasks-by-morphologies grid in \autoref{fig:morph-task-grid} gives the GRP objective a concrete shape. Each row is a robot embodiment — wheeled platform, robotic arm, humanoid — and each column a task such as folding laundry, opening doors, or driving a car. An ideal system achieves high performance across the full grid while sampling as few task-policy combinations as possible; formally, this is minimizing cumulative regret across all tasks and morphologies. Framed this way, generalization, interaction-based learning, and sample efficiency stop looking like separate desiderata: covering the grid without exhaustively sampling every cell requires all three at once.

Why building such a system is hard becomes clearer by tracing the strategies the field has already tried. The first is pure engineering: a domain expert analyzes a specific task, designs a custom algorithm, and programs fixed behaviors for tightly controlled conditions. This produces capable but narrow systems — a robotic arm tuned to assemble exactly one product, in one factory, under one set of lighting conditions, with no ability to adapt when any variable changes.

The second strategy replaces explicit programming with learning from demonstrations. A dataset of expert behaviors trains a policy to replicate them, and under favorable conditions the policy generalizes across minor variations. This is more flexible than scripted engineering and transfers more naturally across robots and task variants, but performance is still bounded by the diversity and coverage of the demonstration dataset — a task or condition absent from the data cannot be handled reliably.

The third strategy introduces autonomous interaction: instead of specifying how to behave, the designer specifies what counts as success through a reward function, and the agent improves by acting in the world and receiving feedback. This makes it possible, in principle, to learn behaviors that exceed the quality of any human demonstration and to discover solutions nobody anticipated at design time.

A genuinely generalist system needs three capabilities to survive this progression. It must generalize beyond the exact situations seen in training, across both tasks and embodiments. It must learn from interaction so performance keeps improving after deployment instead of freezing at the limits of a fixed dataset. And it must support practical task and reward specification, so human intent can be communicated precisely enough for reliable control.

Contextual understanding is what ties these three together. A monolithic policy that treats all actions as equally relevant in every situation is usually too broad to train stably. More effective agents condition their decisions on context, narrowing the action set to what matters in the present situation — preserving broad competence while keeping decision-making tractable.

# Notation Setup

![A deep network policy $\pi(\ba_t, \bo_t, \theta)$ mapping raw image observations to discrete or continuous actions.](figures/vgg16-policy-choice.png){width=95% #fig:vgg16-policy}

\autoref{fig:vgg16-policy} shows a concrete instance of this mapping: raw image input passes through a deep network to produce an action selection — turning left or right. Making this notation operational requires treating state and observation as distinct objects with different informational content. In robotics, state is usually numerical: joint angles, link velocities, orientation terms such as quaternions. These features characterize the robot's proprioceptive configuration and connect directly to classical configuration-space formulations~\citep{schwartz1983piano}.

State is written $\bs_t$, observation $\bo_t$, discrete action $\da_t$, continuous action $\ba_t$, and policy parameters $\theta$. The policy $\pi$ maps available information to an action distribution, and learning updates $\theta$ so that expected return increases.

The distinction that matters is informational completeness. A state representation ideally contains the full decision-relevant description of the world at time $t$; an observation is only the sensor-level view available to the agent, and is often partial. A camera frame can carry rich visual structure while still omitting physically important information outside the field of view.

Two standard formulations follow from this. When the policy conditions on full state, the problem is an MDP. When it conditions on partial observations, the problem is a POMDP, and latent information has to be tracked over time. Notation in the literature is not always consistent about which regime a paper assumes, but the underlying distinction is essential for interpreting what an algorithm assumes and how it will behave.

## Notation History

```{=latex}
\begin{figure}[h]
\centering
\begin{minipage}{0.48\textwidth}
\centering
\includegraphics[width=0.9\linewidth,keepaspectratio]{../lec01-SupervisedLearning/figures/Richard_Bellman.png}
\captionof{figure}{Richard Bellman \citep{bellman1957markovian}, whose dynamic programming framework established the RL notation convention of $a_t$ for actions and $s_t$ for states.}
\label{fig:bellman}
\end{minipage}\hfill
\begin{minipage}{0.48\textwidth}
\centering
\includegraphics[width=0.9\linewidth,keepaspectratio]{../lec01-SupervisedLearning/figures/Lev-Pontrjagin.jpg}
\captionof{figure}{Lev Pontryagin \citep{pontrjagin1962mathematical}, whose optimal control work established the robotics convention of $u_t$ for commands and $x_t$ for states.}
\label{fig:pontryagin}
\end{minipage}
\end{figure}
```
```{=html}
<div style="display:flex; flex-wrap:wrap; gap:1rem; justify-content:center; align-items:flex-start;">
<figure id="fig:bellman" style="width:45%; text-align:center;">
<img src="../lec01-SupervisedLearning/figures/Richard_Bellman.png" style="max-width:100%;" />
<figcaption>Richard Bellman [bellman1957markovian], whose dynamic programming framework established the RL notation convention of $\da_t$ for actions and $\st$ for states.</figcaption>
</figure>
<figure id="fig:pontryagin" style="width:45%; text-align:center;">
<img src="../lec01-SupervisedLearning/figures/Lev-Pontrjagin.jpg" style="max-width:100%;" />
<figcaption>Lev Pontryagin [pontrjagin1962mathematical], whose optimal control work established the robotics convention of $u_t$ for commands and $x_t$ for states.</figcaption>
</figure>
</div>
```

Notation in robot learning carries the marks of the field's mixed lineage. Reinforcement learning conventions descend from Bellman-style dynamic programming (\autoref{fig:bellman}), where $\at$, $\ot$, and $\st$ are standard. Robotics and control instead follow Pontryagin-style notation (\autoref{fig:pontryagin}), where action and state appear as $u_t$ and $x_t$.

Neither notation is better; both encode closely related concepts through different historical traditions. The practical consequence is that readers must translate fluently across papers, or risk mistaking a symbolic difference for a conceptual one.

That translation burden is part of what makes robot learning interdisciplinary. Progress requires comfort with machine learning, reinforcement learning, control theory, and parts of physics, each bringing its own assumptions and formal language to the table.

## State vs Observation

![State features $\bs_t$: joint angles, link velocities, and other proprioceptive quantities describing the robot's configuration.](../lec01-SupervisedLearning/figures/character_features.png){width=45% #fig:state-features}

![Observation features $\bo_t$: raw pixel images from a camera. True state generally cannot be inferred from a single frame.](../lec01-SupervisedLearning/figures/saywerWithTowel.png){width=90% #fig:observation-features}

State variables, in practical robotics, are numerical descriptors of configuration and dynamics: joint angles, link velocities, orientation terms, and related quantities, as \autoref{fig:state-features} shows. These features describe the robot's proprioceptive condition and connect directly to configuration-space reasoning in classical robotics~\citep{schwartz1983piano}.

Observations are the sensor measurements actually available to the agent, which in many modern systems means pixels, as in \autoref{fig:observation-features}. Images carry rich scene information, but a single frame often cannot resolve velocity, contact forces, or direction of motion.

The distinction matters because learning difficulty tracks observability. Control from state can exploit near-Markov structure directly; control from observations has to infer latent state from incomplete evidence first.

## Markov Property

![The Markov property expressed as a factor graph: once the current state $\st$ and action $\at$ are known, earlier variables can be marginalized for next-step prediction.](../lec01-SupervisedLearning/figures/MarkovProperty.png){width=95% #fig:Markov-Property}

The Markov property states that the current state contains all the information required to choose an optimal action. Under this condition the policy needs no history — conditioning on the present state alone is sufficient for optimal decision-making.

This assumption is powerful precisely because it simplifies optimization and analysis so much. Fully observed settings let algorithms exploit Markov structure directly. Partially observed settings do not: the observation itself may fail to be Markov, and the agent must infer latent state from history or learned memory before it can act.

\autoref{fig:Markov-Property} makes this compression explicit as a factor graph: once current state and action are known, earlier variables can be marginalized away for next-step prediction and control. Much of practical RL can be read as an attempt to recover useful Markov structure when the raw observations do not already have it.

## Deep Reinforcement Learning (RL with Non-Linear Function Approximitors)

![The deep RL loop: image observation enters a deep network, an action is produced, the environment returns a reward, and gradients update the network weights.](figures/image-2.png){width=95% #fig:deep-rl-overview}

Three broad strategies exist for programming a robot to perform a task, and placing deep RL among them clarifies what it actually offers. \autoref{fig:deep-rl-overview} shows the full loop: image input, deep network, action output, reward feedback.

The first strategy is explicit engineering. A robotics engineer analyzes the task in full detail, designs a custom algorithm, and programs the robot with pre-scripted behaviors tuned to tight tolerances. This can achieve high precision in a fixed environment, but the resulting systems are brittle under even minor variation, slow to build — commissioning a single industrial robot cell can take years — and cannot be reused across different tasks or layouts.

The second is imitation learning. Instead of programming behavior directly, a human demonstrates the desired behavior — teleoperating the robot, or providing recordings — and the policy is trained to reproduce those demonstrations. This is more flexible than explicit engineering: the same training framework applies regardless of the specific task, and the data can in principle transfer across robots and environments. Its central limitation is that performance is bounded by the scope and diversity of the demonstrations.

The third is deep reinforcement learning. Instead of providing demonstrations, the designer specifies what success and failure mean — the reward function — and the robot learns by interacting with the environment. Deep RL replaces the manual feature engineering of earlier robotics with a general function approximator, typically a deep neural network, that maps raw observations such as images directly to actions such as joint torques. At each step the reward function evaluates the action taken, and the gradient is propagated back through the network to increase the probability of actions that led to higher reward. Repeated over many iterations, this converges toward a policy that achieves the specified objective without any human-scripted movement primitive.

The power of this approach is its scope: any task describable through a reward function is potentially learnable, including tasks whose optimal strategy the designer never knew in advance. Its limitation, which this course addresses at length, is that the resulting policies are often specific to the exact conditions seen during training. Small changes in object appearance, lighting, or arrangement — changes a human would not even notice — can cause a policy to fail outright. Deep RL agents also require far more interaction data than humans need to acquire comparable competence.

Poor generalization, difficulty scaling to larger models, and high data requirements — these three limitations motivate the core research agenda of this course.

# Generalization/Reuse

![Adding a single pixel to an input image is a trivial perturbation, yet it can break a policy trained without explicit robustness objectives.](figures/image-11.png){width=45% #fig:noisy-state}

Generalization is one of the most overused and underdefined terms in robotics. People say a model "generalizes" without specifying what changed, by how much, or whether performance stayed meaningfully high. \autoref{fig:noisy-state} makes the failure mode concrete: adding a single pixel to an input image is a trivial perturbation, and if it breaks the policy, the model was never robust in any practical sense. The opposite confusion is just as common — small perturbations get labeled "unseen tasks" when they are really just noisy versions of the same state.

Everyday manipulation gives a sharper illustration. A person walking into an unfamiliar kitchen encounters cups, glasses, and mugs they have never seen, and does not pause to reconsider how to grasp them — lifting and drinking from a vessel transfers automatically. Robot policies fail in exactly this setting today. A policy trained on one coffee mug may work reliably for that mug and fail completely on a differently shaped or colored one, even though the underlying manipulation task is identical. The policy has overfit to the precise visual and dynamic properties of its training object, not to the invariant structure of the task.

The deeper issue is that "in-distribution" and "out-of-distribution" are not binary labels with a universal boundary. Whether a change counts as out-of-distribution depends on task semantics, not pixel distance. A different cup color may be irrelevant to a grasping task and highly relevant to a color-sorting task. This is why careful definitions matter: robust to what, under what assumptions, evaluated by which operational metric?

This course holds a high standard for generalization claims. Modest performance on small perturbations is not sufficient evidence. The relevant question is whether the policy remains capable when the world changes in the ways real deployments actually fail: sensor artifacts, object diversity, background variability, small but consequential context shifts. Only then is "generalization" a meaningful scientific claim rather than a vague aspiration.

## Finding the Right Representation 

![Invariance and equivariance as representation design principles. *Left:* an equivariant representation preserves spatial structure — translating a scene shifts the feature map by the same amount. *Right:* an invariant representation discards nuisance variation — the same block at the same grid position rendered in three different colours all produce the same structural embedding \citep{lukacs2021sesn}.](figures/equivariance-invariance.svg){width=90% #fig:equivariance-invariance}

Improving generalization starts with representation design. A representation should be invariant to factors the agent should ignore and equivariant to transformations that preserve meaningful structure, as \autoref{fig:equivariance-invariance} illustrates. Invariance and equivariance are not aesthetic mathematical properties here; they directly decide whether a policy survives ordinary deployment noise.

A cat viewed from close up and far away is still a cat: moving the camera changes nearly every pixel, but not the underlying identity of the object. A good representation preserves that identity and refuses to base decisions on accidental image details. In control, this extends beyond recognition — the representation should preserve dynamics-relevant structure while suppressing everything irrelevant.

Representation choices also expose hidden assumptions. When a representation fails to factor out nuisance variability, the practitioner compensates by assuming a static environment, controlled lighting, fixed backgrounds, or a narrow task setting. A better-structured representation relaxes those assumptions without sacrificing performance. In practice, representation quality is often the difference between a demo system and a deployable one.

## Connecting Experiences Together

![Trajectory composition \citep{Ghugare2024-xh}: partial trajectories in a dataset can be stitched together to form novel routes between unseen start-goal pairs.](figures/image-13.png){width=65% #fig:trajectory-composition}

Invariance alone does not produce capable agents; a system also needs to reuse information aggressively. Humans do this constantly — nobody relearns how to leave home, navigate the streets, and enter a building from first principles each day. Prior experience gets composed and adapted to the current context, even as weather, timing, and surface details change.

Trajectory composition is the control analogue, shown in \autoref{fig:trajectory-composition}: given a dataset of partial routes, an agent should be able to stitch fragments into a novel plan between unseen start-goal pairs. This is intuitive on road networks, where intersections define obvious compositional structure. In robotics, overlap and compatibility between trajectories are latent, noisy, and high-dimensional, so stitching becomes a genuinely hard representation-and-planning problem.

The Montreal navigation analogy captures the goal: avoid brute-force coverage of every start-end combination. Strong data reuse lets a finite dataset support broad transfer; weak reuse leaves the system sample-inefficient and brittle. Turning trajectory logs from a pile of isolated episodes into reusable, compositional knowledge is one of the central scientific questions in scalable robot learning.

## Taskable Agents

![A training dataset of diverse goal images and goal-language strings feeds a single policy $\pi(\at \mid \st, g, \theta)$ that generalises across all tasks at inference time.](figures/goal-conditioned-scaling.svg){width=90% #fig:goal-conditioned-scaling}

A central design decision for taskable agents is how goals are represented. \autoref{fig:goal-conditioned-scaling} shows a single policy conditioned on language goals, scaled across a broad range of task specifications. The naive strategy — one policy per task — is memory-inefficient, hard to maintain, and scientifically unsatisfying, because it prevents transfer outright. When each task has its own network, shared perception and control structure is wasted, and adding a new task scales poorly.

A shared policy with an explicit task context variable, such as one-hot conditioning, is an improvement: it forces parameter sharing and cuts duplication. But one-hot conditioning does not generalize to unseen tasks without hand-engineered similarity or manual task indexing.

Richer goal representations — language, multimodal conditioning — are the natural next step. The objective is not just selecting among known tasks, but representing task intent in a form that supports extension and reuse.

Large language models offer a suggestive parallel: certain chunks of the network appear to activate preferentially for specific topic domains — recipe questions, code problems, factual lookup — behaving like implicit sub-policies selected by input context. If this characterization holds, scaling a single large model over broad text data may organically produce task-specialized decomposition without any explicit hierarchical design.

Whether this implicit decomposition transfers cleanly to physical control is still open. Robotics has extensive experience with explicitly hierarchical policies, and those architectures frequently suffer at the interfaces between levels — the seams where high-level intent has to translate into low-level motor commands. A single large model that handles every level of abstraction fluidly, while still representing meaningful task-specific structure internally, remains one of the central open problems in generalist robot learning.

## Good Results

Demonstration clips matter because they show language- and goal-conditioned policies executing nontrivial manipulation tasks with real success. Placing a banana in a bowl, placing a bottle in a tray — these indicate that scaling behavior cloning with richer conditioning produces practical capabilities, not just toy outcomes.

Chapter-quality interpretation still requires caution. Demo videos establish possibility, not reliability. A successful clip says nothing about failure rate under perturbation, robustness to object diversity, long-horizon consistency, or recovery from error states. Even the tooling around communicating results is fragile — media embedding failures in demo slides are a small but honest reminder that real workflows are messy well before deployment enters the picture.

The right conclusion is balanced: these systems are already useful and impressive in constrained settings, but they remain far from open-world competence. The research challenge is turning episodic success into systematic capability across environments, users, and task variations.

## Conditioning on Text

![Grounding language instructions in robot capability. *Left:* a language model ranks candidate actions by $P(a \mid \text{text})$ for the instruction "get me a snack." *Right:* after multiplying by the robot's value function $Q(s, a)$, which scores physical feasibility, the ranking changes — "bring sandwich" drops from second to fourth because the robot cannot assemble one.](figures/saycan-grounding.svg){width=90% #fig:saycan}

Text is an attractive goal interface because it is low-friction, expressive, and scalable for data collection. The policy $\pi(\at | \st, \text{``Get me a snack"}, \theta)$ takes a natural language string as part of its input, so goals can be specified flexibly without ever requiring a goal image. \autoref{fig:saycan} shows one approach to grounding language goals in action selection by combining value functions with language model scoring. Writing text prompts is far cheaper and easier to standardize than producing high-quality goal videos — a real operational advantage, since a broad dataset requires a goal interface that is not itself the bottleneck.

Text can also describe outcomes that do not yet exist anywhere in the dataset. A user can request "fold the laundry" or "clean the room" with no exact target image available at all. Language, in this sense, supports specification before demonstration, which expands the task space available to a learning algorithm.

Text does not solve everything, though. Performance still depends on how language grounding connects to perception and control. If the model's semantic interpretation is disconnected from physical execution, task completion is shallow or inconsistent. Text conditioning is a powerful interface layer, not a replacement for embodied interaction learning.

## Why Does Text Conditioning Work?

Text conditioning works because large language models encode broad statistical structure about goals, objects, and human intent, giving agents a flexible symbolic channel for task specification and compositional instructions. In practice this often makes language a stronger goal descriptor than brittle one-hot encodings.

The grounding problem remains unresolved, though: linguistic tokens are not physical objects. A "cup" in text is not automatically linked to grasp points, mass distribution, friction, or motion constraints. "Clean the room" leaves precision, coverage, and acceptable outcomes all unresolved. Language encodes purpose; dynamics live in embodied interaction.

That is why multimodal systems are not optional for robust robotics. Vision, proprioception, and other sensors provide the closed-loop information control actually needs, while language supplies high-level intent. Good systems integrate both, letting semantic goals constrain action selection without pretending language alone carries enough information for physically grounded behavior. PaLM-E \citep{driess2023palme} is a representative example, combining a large language model with visual encoders to produce policies conditioned on both image observations and natural language instructions.

## Where Does the Data Come From?

![Robotics data sources span teleoperation, third-person video, and autonomous interaction; the challenge is assembling enough diversity for stable abstraction learning.](figures/image-16.png){width=70% #fig:robotics-data}

The core data problem in robotics is not raw scarcity but structure, diversity, and accessibility. \autoref{fig:robotics-data} points at an enormous amount of interaction data already sitting in the world — industrial robots, mobile platforms, teleoperated systems — most of it siloed, weakly labeled, or hard to transfer across embodiments. Data volume is large; usable learning signal is hard to assemble.

Teleoperation guarantees physically realizable trajectories for the target platform, which is valuable and expensive at scale. Third-person human video is abundant and varied, but it introduces embodiment mismatch: what a human can do does not map directly onto robot dynamics or morphology.

The strategic objective is enough diversity that agents discover stable object and task abstractions — seeing enough diversity to realize there is "no diversity" at the right conceptual level. The model should stop memorizing superficial variation and start learning classes, structure, and controllable dynamics.

# Autonomous Learning Systems (DeepRL)

When curated demonstrations run out, the agent has to become its own data collector. That is the motivation for autonomous learning systems: instead of waiting for a human to provide every trajectory, the robot interacts with the environment, evaluates outcomes through rewards, and incrementally improves its behavior.

Reinforcement learning, framed this way, is not an optimization module bolted onto perception — it is a full data-generation and adaptation pipeline. The "infinity-shot" framing is useful here: a system that can safely keep interacting can eventually solve many tasks that were never explicitly demonstrated, provided reward design and exploration are set up right.

The remaining challenge is engineering, not philosophy: can autonomous loops be built stable, sample-efficient, and safe enough for deployment? If so, autonomous interaction becomes the mechanism that scales data collection past manual imitation and enables continual adaptation in real environments. ReLMM \citep{realmm} is a concrete illustration, demonstrating a robot that autonomously collects experience and improves its manipulation policy through self-supervised interaction.

## Autonomous Learning

![An unstructured real-world environment where autonomous learning must operate: cluttered, variable, and lacking manual resets \citep{squirrel2013project}.](figures/image.png){width=55% #fig:cluttered-env}

![The reinforcement learning loop: the agent takes an action $\at$, the environment transitions to $\bs_{t+1}$ and emits reward $r_t$, and the policy is updated to favor higher-return actions.](figures/image-1.png){width=60% #fig:rl-loop}

Learning from interaction closes the loop between decision and consequence. Instead of imitating a static dataset forever, the agent acts, receives feedback, and updates its behavior in response to the environment it actually inhabits — essential in robotics, where deployment conditions differ from collection conditions and edge cases are unavoidable.

The loop itself is conceptually simple: take an action, observe the next state, compute a reward, reinforce the better choice, as \autoref{fig:rl-loop} depicts. \autoref{fig:cluttered-env} shows the kind of unstructured environment this loop actually has to run in. Operationally the loop is deep — it couples perception, control, credit assignment, and planning under uncertainty, which is why RL is often described as a microcosm of the broader AI problem: nearly every major learning challenge shows up somewhere inside this one recurring process.

Making the loop robust and data-efficient yields a general mechanism for adaptation. Without it, systems stay trapped in brittle imitation pipelines that fail as soon as the world shifts even slightly.

## Many DeepRL Algorithms

A policy $\pi(\at | \st, \theta)$ induces a distribution over trajectories through interaction with environment dynamics. The probability of a trajectory $\tau = (\bs_1, \ba_1, \ldots, \bs_T, \ba_T)$ factorizes as:

\begin{multline} 
\label{eq:path-prob}
\underbrace{p(\bs_1, \ba_1, \ldots, \bs_T, \ba_T| \theta)}_{p(\tau|\theta)} = 
 \underbrace{p(\bs_1)}_{\text{unknown}}\prod_{t=1}^{T} \pi(\at | \st, \theta) \underbrace{p(\bs_{t+1} | \st, \at)}_{\text{unknown}} 
\end{multline}

The RL objective maximizes expected cumulative reward over this distribution:

\begin{equation} 
\label{eq:sum-reward}
\argmax_{\theta^{*}} \expectation_{\tau \sim p(\tau|\theta)}\left[\sum_{t} r(\st,\at)\right]
\end{equation}

The unifying view of deep RL is trajectory-centric. A policy induces a distribution over trajectories through interaction with environment dynamics, formalized in \autoref{eq:path-prob}, and optimization maximizes expected cumulative reward over that distribution, given in \autoref{eq:sum-reward}. This framing is more informative than thinking in terms of one-step losses or isolated predictions.

It also clarifies what robust performance actually means: not accurate local estimates, but sustained high return under long-horizon execution. Small local errors compound over time in robotics, so trajectory-level reasoning is the right granularity for evaluating progress.

The framing doubles as a diagnostic tool. When a method fails, the question is whether it misestimates values, mishandles distribution shift, underexplores the state space, or produces unstable policy updates. Returning to the trajectory objective repeatedly separates superficial metric gains from genuine control improvements.

## Is Reinforcement Learning Data Hungry?

![A deep network policy maps observations to actions; the data efficiency question is how many environment interactions are needed before this mapping becomes reliable.](figures/vgg16-policy-choice.png){width=90% #fig:data-hungry-policy}

The contrast between supervised learning and reinforcement learning starts at the level of data structure, illustrated architecturally in \autoref{fig:data-hungry-policy}. Supervised learning assumes independent and identically distributed (IID) samples: each example is drawn from a fixed distribution, and the order examples arrive in does not affect the training signal. This assumption is rarely satisfied perfectly, but it is close enough that supervised learning can be applied widely and reliably.

Reinforcement learning never gets this assumption. Every transition the agent collects depends on the policy that generated it, which in turn depends on all prior updates. The agent cannot re-sample a state it visited last week — that exact state of the world no longer exists. Data is sequentially correlated, policy-dependent, and non-stationary throughout training, which undermines the convergence arguments that make supervised learning tractable.

Deep RL is often called data-hungry because many algorithms need repeated exposure to similar states before converging, but the sharper framing is data utilization rather than data volume. Given a fixed dataset, how much reusable signal can the algorithm actually extract? An update rule that cannot absorb information already sitting in replay makes the system look data-hungry even when the evidence is already there.

The distinction matters for where to focus research. Some failures are exploration failures, but many are optimization and credit-assignment failures over existing data. Improving data reuse can produce large sample-efficiency gains without touching exploration budgets, and without waiting for exploration to be solved first.

## How can Reinforcement Learning be Better Fed?

![The data hierarchy (LeCun 2018): unsupervised and self-supervised signals vastly outnumber labeled reward signals, yet RL methods often fail to exploit the unlabeled majority.](../lec17-OfflineRL/figures/lecun-cake){width=70% #fig:lecun-cake}

The "better fed" question is whether RL's sample complexity is fundamental, or partly self-inflicted through weak replay efficiency. \autoref{fig:lecun-cake} frames this through the cake, icing, and cherries analogy: the vast majority of useful signal lies in the unlabeled or self-supervised regime, and current RL methods routinely fail to exploit it. Interaction data is expensive in most settings, yet algorithms still fail to fully use what they already collected.

Supervised learning gets much of its efficiency by revisiting a static dataset many times. Deep RL often cannot do this safely — repeated optimization on replay can destabilize value estimates and induce policy collapse. Data that should be informative ends up underused as a result.

Feeding RL better means increasing the useful passes over replay while holding stability. If every transition contributes more gradient signal before it gets discarded, real-world interaction costs fall and practical autonomous learning gets closer.

# Can Reinforcement Learning Eat More?

![Squeezing every useful gradient from collected experience: the goal is to maximize replay ratio while avoiding value divergence.](figures/image-18.png){width=65% #fig:replay-efficiency}

Replay stability is a central asymmetry between supervised learning and deep RL. Supervised models tolerate many epochs over the same data; deep RL models frequently diverge when replay is pushed too aggressively. \autoref{fig:replay-efficiency} captures the goal — extracting every useful gradient from collected data before discarding it — which makes RL paradoxically bad at one of the most valuable forms of learning efficiency.

On-policy methods are stable but data-limited, often reusing each batch only a handful of times. Off-policy methods increase reuse by learning from behavior generated by older policies, but that introduces distribution mismatch and bootstrapping instability. Reuse versus divergence is a constant balancing act.

The long-term objective is explicit: increase replay ratio and model capacity while controlling instability. This is not a minor optimization; it is foundational for making RL viable in data-constrained robotic domains.

### Q-iteration {.block}

Experience replay operationalizes reuse: the agent stores transitions in a buffer, samples mini-batches, and performs optimization updates between collection phases \citep{Lin1992-br,Mnih2013-up,Fedus2020-um}. The Q-iteration algorithm formalizes this:

\begin{algorithmic}[1]
    \State init $\phi$ to a random network and $\data \leftarrow \{\}$
    \While{true}
        \State {Collect experience $\{\st^{i}, \at^{i}, \rt^{i}, \stt^{i}\}_{i,t=1,1}^{N, T}$ using some policy and add to $\data$}
        \For{$k \in 0, \ldots, K$}
            \State Sample batch of data $\{\st^{i}, \at^{i}, \rt^{i}, \stt^{i}\}_{i=1}^{N}$ from $\data$
            \State Minimize $\frac{1}{N} \sum^{N} \|Q(\st^{i}, \at^{i}, \phi) - r_i + \max_{\ba'} Q(\stt^{i}, \ba', \phi)\|^{2}$
        \EndFor
    \EndWhile
\end{algorithmic}

In principle, this should let the learner squeeze far more signal from each expensive interaction.

The key parameter is the replay ratio, often denoted $k$: how many gradient updates are performed per unit of newly collected data. Ideally $k$ would be pushed high and learning would keep improving until it saturates. In practice, higher replay amplifies value overestimation, distribution mismatch, and bootstrapping artifacts.

Much of modern deep RL is a controlled attempt to raise effective replay safely: better targets, regularization, conservative updates, representation stabilization. The engineering goal is simple to state and hard to achieve — maximize learning per sample without crossing the divergence boundary.

## How can RL scale?

![A small gradient step size $\alpha$ produces stable convergence toward the optimal policy parameter $\theta^*$, while a large step size causes the update to overshoot the peak of the return surface $J(\theta)$ and land at a lower return.](figures/policy-gradient-stepsize.svg){width=80% #fig:scaling-instability}

Scaling in RL is not just a parameter-count question; it is an optimization-dynamics question. \autoref{fig:scaling-instability} shows how stochastic policy-ascent dynamics become harder to control as model capacity grows. Larger networks represent richer behaviors, but they are also more sensitive to update noise when the data is non-IID and continuously shifting — which is why methods that scale cleanly in supervised learning can become unstable online.

Every update changes the action distribution, and with a high-capacity model those shifts can be unexpectedly large. If the policy moves too far in one step, data collected under the prior policy no longer matches the current one well, and learning degrades.

Current mitigations include network resets \citep{Nikishin2022-sb}, constrained updates \citep{Tang2024-bg}, and pretrained model priors \citep{Zeng2024-zq}. These help, but the evidence is uneven across algorithm families. Value-based pipelines have seen more scaling wins than pure policy-gradient systems, where variance and instability remain the major bottleneck.

## How Well Does Deep RL Work?

Deep RL methods differ not only in implementation but in objective alignment. Value-based methods optimize Bellman-consistency surrogates, which are useful but only indirectly related to true return maximization in nonlinear regimes — which is why low value error does not always translate into strong control behavior.

Model-based methods face a related disconnect. Improving world-model prediction quality can be valuable, but better one-step prediction does not automatically mean better policy performance unless planning and control actually exploit that model correctly. A model can be made more accurate with no guarantee of improved return.

Policy-gradient methods are attractive because they optimize return directly, but that benefit comes with high variance and sensitivity to update stability. No family is universally superior; each trades off objective fidelity, sample efficiency, and optimization robustness differently.

## Reinforcement Learning Assumptions

Assumption mismatch is a recurring theme in robot learning. Three assumptions appear most often in the theoretical foundations of deep RL, and all three are routinely violated in real robotic settings.

The first is full observability: many value-function algorithms assume the policy conditions on the complete state $\st$ rather than a partial observation $\bo_t$. Real sensors are occluded, time-varying, and noisy. The standard mitigation is recurrent memory — typically an LSTM — so the policy can integrate evidence over time instead of acting on a single frame. This helps, but it shifts the problem from observability to credit assignment over long histories.

The second is episodic resettability, or ergodicity: some algorithms implicitly assume $p(\bs) > 0$ for all relevant states, meaning the agent can revisit any state during training. Robotics violates this outright — time cannot be rewound. A physical robot that breaks an object or tips over cannot replay that transition from scratch. Algorithms that depend on dense, on-demand revisitation of past states need redesigning, or need explicit data-collection strategies bolted on, before real deployment.

The third is continuity or smoothness: continuous value-function methods and some model-based approaches assume the dynamics and reward are smooth enough for gradient-based updates. Contact-rich manipulation, locomotion on rough terrain, and other physically realistic settings routinely violate this through hard contacts, impacts, and discontinuous friction.

Knowing which assumptions an algorithm requires, and which ones a given platform violates, is the first diagnostic step when a method fails to transfer from simulation to the real world.

Assumptions remain useful as analytical scaffolding, but they are approximations, not deployment guarantees. The stronger workflow for applied research is identifying which assumptions fail first for the target platform, then building explicit mitigations into the algorithm and evaluation protocol.

## The Importance of Embodiment

![From left to right: amoeba, wheeled robot, robot arm, and humanoid. Each richer morphology unlocks a larger accessible behaviour space, shown as a growing bubble of learnable tasks.](figures/morphology-embodiment.svg){width=80% #fig:robot-embodiment}

Embodiment is not peripheral to intelligence; it defines the space of possible interaction. An amoeba, with extremely limited mobility and actuation, can only sample a narrow slice of the world — which restricts what it can learn regardless of algorithm quality.

The same principle applies to robots. A stationary arm, a wheeled base, and a dexterous humanoid, shown in \autoref{fig:robot-embodiment}, each expose different controllable state spaces and affordances. A platform that cannot manipulate objects cannot acquire manipulation-relevant experience; a platform that cannot navigate varied terrain keeps a world model that stays narrow.

Morphology is therefore part of the learning problem, not hardware packaging. Progress toward general-purpose agents depends on aligning algorithm design with embodiment capabilities, because representation, exploration, and skill acquisition are all constrained by what the body can physically do.

Whether humanoid morphology is necessary for general-purpose robotics remains an open question. The humanoid form grants access to environments and tools built for human proportions — doorknobs, staircases, keyboards, chairs — a real advantage for systems meant to operate in homes and offices. Against that, humanoid locomotion is mechanically complex and costly to control, and many tasks that seem to call for a humanoid form can be handled by simpler morphologies with the right end-effector. The answer likely depends on task scope: a narrow-task robot can be purpose-built, while a truly general-purpose agent may eventually need the embodiment flexibility the humanoid form provides.

# What behaviour do Users Want agents to optimize?

![The same room before (messy) and after (tidied), with an identical park visible through the window in both states. A pixel-level goal-image reward would penalise any difference in the outdoor scene — people walking, lighting shifts — even though those changes are entirely outside the agent's control and irrelevant to the task of tidying the room.](figures/goal-image-issues.png){width=90% #fig:goal-image-issues}

Goal images are intuitive, but they often over-specify user intent. \autoref{fig:goal-image-issues} shows how the same goal image admits multiple conflicting interpretations. Optimization tied to pixel-level matching can penalize the agent for irrelevant differences — lighting, background changes, scenery outside a window — even when the true task objective is fully satisfied.

Taken to its extreme, pixel matching implies absurd objectives, such as reconstructing the entire outside world to match the historical scene visible through a window. Nobody means this by "clean my room," but it can still emerge from a poorly aligned reward definition.

The challenge is balancing specificity with flexibility. Text goals tend to be under-specified; image goals tend to be over-specified. A better goal representation captures intent-level constraints and leaves irrelevant variation unconstrained, so the policy optimizes what the user actually cares about rather than accidental visual detail.

## Learning New Skills

![The landscape of skills learned by current systems, divided by category. The majority of learned behaviours reproduce demonstrations or recombine existing human knowledge; only a small frontier involves genuinely novel discovery beyond what is already known.](figures/learning-new-skills.svg){width=90% #fig:learning-new-skills}

Most contemporary progress still emphasizes reproducing known behaviors: imitation learning from expert demonstrations, benchmark repetition, constrained task suites, as \autoref{fig:learning-new-skills} reflects. These are valuable milestones, but they do not test whether an agent can produce genuinely new solutions in an open-ended setting. Both imitation learning and large language models are trained predominantly on existing human knowledge — they are efficient at recombining what people already know, not at generating fundamentally new solutions.

The more ambitious goal is an agent capable of scientific discovery and open-ended problem solving. Designing a more efficient battery is categorically different from cleaning a room: no demonstration dataset contains the optimal solution, the search space is physical chemistry rather than motor control, and evaluation requires novel experimental evidence rather than a task-completion criterion. An agent pursuing such goals would have to act as an autonomous scientific instrument — designing hypotheses, collecting evidence, revising plans iteratively.

Humans are not actually well-suited to this kind of extended, unbiased planning. People anchor on familiar solutions and struggle with exhaustive combinatorial search. Machine learning systems can evaluate large hypothesis spaces systematically, given the right structure. Physical interaction through robotics, planning through search or model-based RL, and broad language priors through foundation models may eventually combine to support genuinely novel discovery — but doing so requires going well beyond the replay-based pipelines that dominate current benchmarks.

This is where continual learning becomes essential. Real deployments carry long tails of unusual cases, shifting constraints, and nonstationary objectives. A system that stops learning after pretraining plateaus quickly; a system that keeps adapting accumulates capability and handles novelty with increasing competence over time.

## Consider the Environment

![Sources of environmental stochasticity and nonstationarity: other agents, natural changes, novel objects, and real-time constraints that do not pause for deliberation.](figures/env-stocasticity.png){width=65% #fig:environment-stochasticity}

Real environments are not static testbeds. \autoref{fig:environment-stochasticity} shows what they actually contain: other agents, shifting conditions, changing constraints, persistent uncertainty. A policy in this setting must be robust not only to noise but to the ongoing nonstationarity that interaction itself generates.

Naive novelty-seeking is not enough here. Useful behavior requires structured adaptation: exploring enough to keep learning, while staying stable enough to preserve task performance and safety. Diversity and chaos are features of the real world, not corner cases to be engineered away.

Timing is a further constraint on deployment. Real-time control does not wait for slow deliberation. If model complexity grows without a matching constraint on latency, performance can collapse even when nominal policy quality looks strong offline. Practical intelligence in robotics has to combine adaptation quality with strict reaction-time discipline.

## What is our reward function?

![A robot learning to construct shelter as an emergent behavior from surprise-minimization objectives: maintaining local order as a proxy for long-term survival.](figures/image-9.png){width=65% #fig:shelter-construction}

Reward specification is one of the hardest unsolved problems in autonomous learning. Even a compelling broad principle — minimizing surprise, maintaining local order — is difficult to translate into a tractable objective that can be optimized at scale.

The biological framing is a useful starting point: agents survive by keeping key state variables within viable ranges despite environmental volatility \citep{friston2009free}. Humans go to considerable lengths to shield themselves from surprise — building homes, and supplying them with water, food, and electricity, is largely an exercise in making the environment more predictable. Could the same motive — preserving order — drive the automatic acquisition of useful behavior in an artificial agent, with no external task reward at all?

Unsupervised reinforcement learning takes this question seriously, and surprise minimization is one instance of it: an agent rewarded simply for reaching predictable, familiar states, with no notion of tasks or goals built in \citep{berseth2019smirl}. Minimizing surprise does not mean sitting still, since the world keeps perturbing the agent away from familiar states; staying predictable requires acting continually and purposefully to return to them. The shelter-construction behavior in \autoref{fig:shelter-construction} shows what this can produce: a simulated agent exposed to changing wind and weather discovers that building a wall around itself keeps its future observations stable, at the cost of some short-term surprise while building it. No task reward, demonstration, or notion of "shelter" was ever given to the agent — the behavior is a side effect of minimizing surprise over its own experience.

This is instructive as much as it is a cautionary tale. Surprise minimization is a genuinely reward-free objective that produces recognizable, useful-looking behavior — but only because this particular environment happened to make orderliness and survival coincide. Nothing in the objective itself points at chores, shelter, or usefulness; a different environment could just as easily reward an agent for hiding in a corner and refusing to look at anything new. This is the general problem with reward design: a broad, elegant principle is not automatically a safe or well-aligned one. Rewards must be computable, aligned with the desired long-horizon outcome, and resistant to shortcut solutions, or they produce behavior that is technically optimal and practically wrong. Reward design is not an implementation detail — it is the central interface between human intent and autonomous behavior.

## The Supports

\begin{figure}[h]
\centering
\input{figures/three-pillars}
\caption{The three foundational pillars of robot learning: deep learning for perception and representation, reinforcement learning for autonomous interaction, and generalization methods for transfer to new settings.}
\label{fig:three-pillars}
\end{figure}

The three pillars in \autoref{fig:three-pillars} — deep learning for perception and representation, reinforcement learning for autonomous interaction, generalization methods for transfer to new settings — are not independent components. They are mutually reinforcing foundations, and all three must function together before a robot can operate competently in the open world.

Deep learning provides the capacity to process high-dimensional, unstructured observations — images, proprioceptive signals — and to learn compact representations that support downstream decision-making. Without strong perception, the policy cannot accurately assess the current state of the world, and neither planning nor reward optimization will function reliably.

Reinforcement learning provides the mechanism for acquiring behavior through interaction rather than explicit programming or manual demonstration. It lets the agent discover solutions that would be impractical to specify in advance, and keep improving past the limits of any available dataset.

Generalization methods — goal conditioning, transfer learning, domain randomization, simulation-to-real transfer — extend competence beyond the specific situations encountered during training. Without generalization, a robot is a sophisticated but narrow specialist: excellent on the exact task and environment it was trained for, and degraded under any variation from it.

Together these three pillars define the scope of modern robot learning research, and the structure of this course. Progress on any one pillar in isolation is not enough; effective robotic systems require all three addressed at once.

## Get Involved and Learn (10%)

\begin{figure}[h]
\centering
\input{figures/causal-graph}
\caption{The causal graph underlying active learning: passive observation is insufficient to disentangle correlation from causation; interventions (actions with observed outcomes) are required to build a correct causal model.}
\label{fig:causal-graph}
\end{figure}

The connection between active participation and learning is not metaphorical — it reflects a deep theoretical result in causal inference \citep{pearl2009causality}, shown in \autoref{fig:causal-graph}. Building an accurate causal model of a domain requires more than passive observation. An agent must intervene: take actions, observe the resulting changes, compare outcomes across conditions. Without intervention, correlation and causation cannot be disentangled, and the model stays a statistical summary of observed patterns rather than a true account of how the world responds to actions.

The same principle applies to learning in a classroom or research setting. Passive attendance exposes a student to information, but it does not guarantee a correct causal model gets acquired. The way to find out whether an understanding is accurate — and to correct it if it is not — is to intervene: ask questions, propose answers, attempt problems, and observe where the responses diverge from expectation.

An early experiment in developmental neuroscience illustrates the stakes. Kittens physically prevented from moving during a critical period of visual development — carried passively rather than allowed to walk — later failed to develop normal depth perception and motor coordination, even though they had been exposed to the same visual scenes as their free-moving littermates. Active interaction with the environment, not mere passive exposure to its sensory outputs, was required to develop calibrated representations and control.

The same principle scales to research. A scientist who only reads papers and never runs experiments, conducts ablations, or tests predictions against real data develops imprecise intuitions that cannot be reliably corrected. Act, observe, update — this intervention loop is the shared mechanism behind reinforcement learning, scientific discovery, and learning in any domain.
