---
title: "Foundations of Robot Learning: Scaling Learning for Real-World Agents"
author: Glen Berseth
date: Jan 5, 2022
published: false
header-includes: 
    - \input{../defs.md}
---

# Ingredients and Challenges in Real-World (Robot) Learning

![Current robots are deployed in controlled, repetitive settings such as manufacturing, fulfillment, and transportation.](figures/current-robot-use.png){width=60% #fig:current-robot-use}

#### Why Study Robotics?

You might wonder why we have a class on robotics and machine learning. Doesn't it all work perfectly already? We see robotics in the news, and vast sums of money are being invested, which clearly signals that something is still missing. Throughout this course, we will explore why current systems often fall short and what is needed to get them to work as we truly envision. We are in the midst of an interesting revolution, but to understand it, we first need to look at the present.

#### Robots: Common, But Limited

The first key point is that robots are not new. They have been around for a long time and, truthfully, are already all around us, as illustrated in \autoref{fig:current-robot-use}. The first humanoid robot, for instance, was built about 100 years ago.

Today, robots are essential helpers in many key industries:

- Manufacturing: Assembling cars on a factory line.

- Fulfillment: Packaging and sorting items in large warehouses.

- Transportation: Moving items and materials around controlled areas like hospitals or factories.

However, the problem with most of these current robotic systems is that their skills are severely limited.

#### The "Brittleness" of Current Systems

The primary limitation is that most robots operate in highly controlled environments. Think of a car manufacturing plant. The robots attaching doors don't really require "intelligence" or even "eyes"; they are just executing the same, highly repetitive process over and over. The entire manufacturing process has been engineered to such small tolerances that adaptability isn't necessary. This is what we mean when we say they perform pre-scripted behaviors. They have a very limited ability to adapt to anything outside their exact programming.

This limitation makes these systems brittle. For example, in some advanced manufacturing plants, if a single speck of dust enters the building, the entire system may have to be shut down, cleaned, and restarted. Because they cannot adapt to even minor, unexpected changes, these robots are not very reusable and are not truly flexible. This is the gap that modern robotics and machine learning aim to close.

## Robots can be Better Tools

![A range of prospective future robot applications, from household assistance to ecological restoration to flexible manufacturing.](figures/future-robot-use.png){width=60% #fig:future-robot-use}

### Robots as Better Tools for Society
The pursuit of more advanced robotics is not merely a technical challenge; it is an effort to build tools that can materially improve human life and societal resilience. The next generation of robotic systems can address several critical needs, moving beyond simple automation toward genuine augmentation of human capability.

#### Reclaiming Time for Creativity and Care
One of the most profound benefits of advanced robotics is the potential to reclaim human time. By automating mundane or laborious tasks—such as household chores, maintenance, or manual labor—we can free individuals to pursue more creative, intellectual, or restorative activities.

History provides powerful examples of this principle. Albert Einstein, for instance, developed groundbreaking ideas while working at a patent office and using his spare time for deep, creative thought. By reducing the burden of obligatory labor, we can maximize this kind of creative and intellectual space for more people.

This reclaimed time could also be dedicated to large-scale, long-term projects that are currently unfeasible. Consider ecological restoration, where dedicated, long-term care like planting and tending to new forests can revitalize entire landscapes and build richer ecosystems. Advanced robotics could assist in these efforts, allowing more such restorative projects to flourish.

#### Enhancing Human Agency and Support
Robotics can also profoundly enhance human agency, particularly for aging populations or individuals needing assistance. As people get older, daily tasks can become more challenging, and support systems are often strained. Intelligent robotic systems designed to assist with these tasks—from mobility to household management—can provide critical support, allowing for greater independence, dignity, and a higher quality of life.

#### Building Agile and Responsive Production
Our current model of mass production is rigid. While highly efficient at producing large quantities of a single item, it is exceptionally slow and costly to adapt. This inflexibility is a significant liability.

To build a new manufacturing line, for example for an electric car, it can easily take five years to construct the facility and another five years to install and fine-tune the automated systems. This ten-year lag from concept to production is untenable in a world that changes at an accelerating pace. A ten-year plan is often obsolete within three or four years.

Society needs the ability to adjust much faster, whether to respond to a public health crisis that requires the rapid production of vaccines or to adapt to new economic and environmental realities. More intelligent, adaptable robotics are essential for creating a responsive manufacturing base that can be re-tasked quickly.

#### Efficiency in Space and Resource Management
Finally, robotics can help society become far more efficient with its use of space and resources. Several innovative companies are already using robotics to sort and process waste, enabling recycling at a much higher rate of efficiency than manual sorting allows.

This principle extends powerfully to food production. Indoor vertical farming is a prime example of using space more efficiently. Robotics can manage the planting, care, and harvesting in these facilities, making it possible to expand the scale of vertical farming operations. This method is particularly beneficial as it does not rely on pesticides and other chemicals that can contaminate vital water supplies, thus preserving a critical natural resource while increasing food security.

These potential benefits — more time, greater agency, responsive production, and resource efficiency — are compelling, and represent the space of applications illustrated in \autoref{fig:future-robot-use}. They frame the next critical question for the field: how must research advance to achieve these goals at a responsible and effective pace?

## Generalist Robotics Policies

![A Generalist Robotics Policy (GRP): a single agent capable of performing a wide range of tasks across diverse embodiments.](figures/GRP.png){width=70% #fig:grp}

![The tasks-by-morphologies grid: rows represent robot embodiments, columns represent tasks. An ideal GRP achieves high performance across the full grid.](figures/image-14.png){width=55% #fig:morph-task-grid}

A primary inquiry in modern robotics is the design and feasibility of a Generalist Robotics Policy (GRP), illustrated in \autoref{fig:grp}: a single agent that can adapt across many tasks and environments. This objective has motivated decades of research, yet it remains difficult because flexibility, sample efficiency, and stability must all improve together rather than independently.

One concrete way to frame the GRP objective is through the tasks-by-morphologies grid shown in \autoref{fig:morph-task-grid}. Each row of the grid corresponds to a robot embodiment — wheeled platform, robotic arm, humanoid — and each column corresponds to a task such as folding laundry, opening doors, or driving a car. The ideal system achieves high performance across the full grid while sampling as few task-policy combinations as possible. Formally, this corresponds to minimizing cumulative regret across all possible tasks and morphologies. This framing clarifies why generalization, interaction-based learning, and sample efficiency are not independent desiderata: they are jointly required to cover the grid without exhaustively sampling every cell.

To understand why building such a system is hard, it helps to consider the progression of strategies the field has tried. The first approach is pure engineering: a domain expert analyzes a specific task, designs a custom algorithm, and programs fixed behaviors that work within tightly controlled conditions. This produces capable but narrow systems — a robotic arm tuned to assemble exactly one product in one factory, under one set of lighting conditions, with no ability to adapt when any variable changes.

The second approach replaces explicit programming with learning from demonstrations. A dataset of expert behaviors is collected and used to train a policy that can replicate those behaviors, and in favorable conditions generalize across minor variations. This is more flexible than scripted engineering and transfers more naturally across robots and task variants. However, performance remains bounded by the diversity and coverage of the demonstration dataset. Tasks or conditions not represented in the data cannot be handled reliably.

The third approach introduces autonomous interaction: rather than specifying how to behave, the designer specifies what counts as success through a reward function, and the agent improves by acting in the world and receiving feedback. This makes it possible, in principle, to learn behaviors that exceed the quality of any human demonstration and to discover solutions that were not anticipated during system design.

For a system to be genuinely generalist across this progression, three capabilities are foundational. First, it must generalize beyond the exact situations seen in training, ideally across both tasks and embodiments. Second, it must learn from interaction so performance can continue improving after deployment rather than freezing at dataset limits. Third, it must support practical task and reward specification so human intent can be communicated precisely enough for reliable control.

Contextual understanding is the mechanism that connects these capabilities. A monolithic policy that treats all actions as equally relevant in all situations is usually too broad and computationally unstable. More effective agents condition decisions on environment context, narrowing the action set to what is relevant in the present situation. This preserves broad competence while maintaining tractable decision-making.

# Notation Setup

![A deep network policy $\pi(\ba_t, \bo_t, \theta)$ mapping raw image observations to discrete or continuous actions.](figures/vgg16-policy-choice.png){width=95% #fig:vgg16-policy}

\autoref{fig:vgg16-policy} shows a concrete instance of this mapping: raw image input passes through a deep network to produce an action selection — turning left or right. To make the notation operational, state and observation are treated as distinct objects with different informational content. In robotics, state is often represented by numerical quantities such as joint angles, link velocities, and orientation terms (for example, quaternions). These features characterize the robot's proprioceptive configuration and connect naturally to classical configuration-space formulations~\citep{schwartz1983piano}.

Using this notation, we denote state as $\bs_t$, observation as $\bo_t$, discrete action as $\da_t$, continuous action as $\ba_t$, and policy parameters as $\theta$. The policy $\pi$ maps available information to an action distribution, and learning corresponds to updating $\theta$ so expected return increases.

The central distinction is informational completeness. A state representation ideally contains the full decision-relevant description at time $t$, whereas an observation is the sensor-level view available to the agent and is often partial. A camera frame, for example, may contain rich visual structure but still omit physically important information outside the field of view.

This leads to two standard formulations. When the policy conditions on full state, we typically frame the problem as an MDP. When the policy conditions on partial observations, we are in a POMDP setting and must handle latent information over time. In practice, notation in papers is not always consistent, but the distinction remains essential for interpreting assumptions and algorithm behavior.

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

Notation in robot learning reflects the field's mixed lineage. Reinforcement learning conventions are strongly influenced by Bellman-style dynamic programming (\autoref{fig:bellman}), where symbols such as $\at$, $\ot$, and $\st$ are common. Robotics and control, however, often follow the Pontryagin-style notation (\autoref{fig:pontryagin}), where action and state appear as $u_t$ and $x_t$.

Neither notation is inherently better; they encode closely related concepts through different historical traditions. The practical implication is that readers must translate fluently across papers to avoid mistaking symbolic differences for conceptual differences.

This translation burden is part of what makes robot learning interdisciplinary. Progress requires comfort with machine learning, reinforcement learning, control theory, and parts of physics, each of which contributes its own assumptions and formal language.

## State vs Observation

![State features $\bs_t$: joint angles, link velocities, and other proprioceptive quantities describing the robot's configuration.](../lec01-SupervisedLearning/figures/character_features.png){width=45% #fig:state-features}

![Observation features $\bo_t$: raw pixel images from a camera. True state generally cannot be inferred from a single frame.](../lec01-SupervisedLearning/figures/saywerWithTowel.png){width=90% #fig:observation-features}

In practical robotics, state variables are numerical descriptors of configuration and dynamics: joint angles, link velocities, orientation terms, and related quantities. As illustrated in \autoref{fig:state-features}, these features represent the robot's proprioceptive condition and connect directly to configuration-space reasoning in classical robotics~\citep{schwartz1983piano}.

Observations, by contrast, are the sensor measurements available to the agent. In many modern systems this means pixels, as shown in \autoref{fig:observation-features}. Images provide rich scene information, but from a single frame velocity, contact forces, and motion direction often cannot be inferred unambiguously.

This distinction matters because learning difficulty depends on observability. State-based control can often exploit near-Markov structure directly, while observation-based control must infer latent state from incomplete evidence.

## Markov Property

![The Markov property expressed as a factor graph: once the current state $\st$ and action $\at$ are known, earlier variables can be marginalized for next-step prediction.](../lec01-SupervisedLearning/figures/MarkovProperty.png){width=95% #fig:Markov-Property}

The Markov property states that the current state contains all information required to choose an optimal action. Under this condition, the policy does not need the full interaction history; conditioning on the present state is sufficient for optimal decision-making.

This assumption is powerful because it simplifies optimization and analysis. In fully observed settings, algorithms can exploit Markov structure directly. In partially observed settings, however, the observation may not be Markov, so the agent must infer latent state from history or learned memory before acting.

The factor-graph view in \autoref{fig:Markov-Property} expresses this compression explicitly: once current state and action are known, earlier variables can be marginalized for next-step prediction and control. A large portion of practical RL can be interpreted as recovering useful Markov structure when raw observations are incomplete.

## Deep Reinforcement Learning (RL with Non-Linear Function Approximitors)

![The deep RL loop: image observation enters a deep network, an action is produced, the environment returns a reward, and gradients update the network weights.](figures/image-2.png){width=95% #fig:deep-rl-overview}

To place deep reinforcement learning in context, it helps to consider three broad strategies for programming a robot to perform a task. \autoref{fig:deep-rl-overview} illustrates the full loop: image input, deep network, action output, and reward feedback.

The first is explicit engineering: a robotics engineer analyzes the task in full detail, designs a custom algorithm, and programs the robot with pre-scripted behaviors that work within tightly controlled tolerances. This approach can achieve high precision in fixed environments but produces brittle systems that fail under even minor variation. The process is slow — commissioning a single industrial robot cell can take years — and the resulting programs cannot be reused across different tasks or layouts.

The second is imitation learning: instead of programming behavior directly, the system learns from examples. A human demonstrates the desired behavior — either by teleoperating the robot or by providing recordings — and the policy is trained to reproduce those demonstrations. This is more flexible than explicit programming: the same training framework applies regardless of the specific task, and the data can in principle transfer across different robots and environments. The central limitation is that performance is bounded by the scope and diversity of the demonstrations.

The third is deep reinforcement learning. Rather than providing demonstrations, the designer specifies what success and failure mean — the reward function — and the robot learns by interacting with the environment. Deep RL replaces the manual feature engineering that characterized earlier robotics with a general function approximator, typically a deep neural network, that accepts raw observations such as images and outputs actions such as joint torques. At each step, the reward function evaluates the quality of the action taken, and the gradient is propagated back through the network to increase the probability of actions that led to higher reward. Over many iterations, this process converges toward a policy that achieves the specified objective without requiring human-scripted movement primitives.

The power of this approach is its scope: any task that can be described through a reward function is potentially learnable, including tasks whose optimal strategies are not known to the designer in advance. The limitation, which this course addresses at length, is that the resulting policies are often specific to the exact conditions seen during training. Small changes in object appearance, lighting, or arrangement — differences that humans would not notice — can cause policy failure. Deep RL agents also require far more interaction data than humans typically need to acquire comparable competence.

These three limitations — poor generalization, difficulty scaling to larger models, and high data requirements — motivate the core research agenda of this course.

# Generalization/Reuse

![Adding a single pixel to an input image is a trivial perturbation, yet it can break a policy trained without explicit robustness objectives.](figures/image-11.png){width=45% #fig:noisy-state}

Generalization is one of the most overused and underdefined terms in robotics. In discussion, people often say a model "generalizes" without specifying what changed, by how much, and whether performance remained meaningfully high. \autoref{fig:noisy-state} illustrates this directly: adding a single pixel to an input image is a trivial perturbation, yet if it breaks a policy the model is not robust in any practical sense. But the opposite confusion also appears: we sometimes call very small perturbations "unseen tasks" when they may simply be noisy versions of the same state.

A more concrete illustration comes from everyday manipulation. When a person visits an unfamiliar kitchen, they encounter cups, glasses, and mugs they have never seen before. They do not pause to wonder whether to adjust their grasp — the task of lifting and drinking from a vessel transfers automatically. Current robot policies frequently fail in exactly this setting. A policy trained on a specific coffee mug may work reliably for that object but fail completely when presented with a differently shaped or colored mug, even though the underlying manipulation task is identical. The policy has overfit to the precise visual and dynamic properties of its training object rather than to the invariant structure of the task.

The deeper issue is that "in-distribution" and "out-of-distribution" are not binary labels with universal boundaries. Whether a change counts as out-of-distribution depends on task semantics, not pixel distance. A different cup color may be completely irrelevant for a grasping task but highly relevant for a color-sorting task. This is why careful definitions matter: robust to what, under what assumptions, and evaluated by which operational metric?

For this course, we hold a high standard for generalization claims. It is not sufficient to show modest performance on small perturbations. The relevant question is whether the policy remains capable when the world changes in the ways real deployments fail: sensor artifacts, object diversity, background variability, and small but consequential context shifts. Only then does "generalization" become a meaningful scientific claim rather than a vague aspiration.

## Finding the Right Representation 

![Invariance and equivariance as representation design principles: a good representation is invariant to nuisance factors and equivariant to task-relevant transformations \citep{lukacs2021sesn}.](figures/image-12.png){width=90% #fig:equivariance-invariance}

Improving generalization begins with representation design. A representation should be invariant to factors the agent should ignore and equivariant to transformations that preserve meaningful structure, as illustrated in \autoref{fig:equivariance-invariance}. Invariance and equivariance are not aesthetic mathematical ideas here; they directly determine whether a policy survives ordinary deployment noise.

The cat-camera example captures this intuition clearly: moving the camera closer changes nearly every pixel, but not the underlying identity of the object. A good representation should preserve that identity and prevent brittle decisions tied to accidental image details. In control settings, this extends beyond recognition: the representation should preserve dynamics-relevant structure while suppressing irrelevant variation.

This also reveals why representation choices are tied to assumptions. If the representation fails to factor out nuisance variability, the practitioner compensates by assuming a static environment, controlled lighting, fixed backgrounds, or narrow task settings. A better-structured representation relaxes those assumptions without sacrificing performance. In practice, representation quality is often the difference between a demo system and a deployable system.

## Connecting Experiences Together

![Trajectory composition \citep{Ghugare2024-xh}: partial trajectories in a dataset can be stitched together to form novel routes between unseen start-goal pairs.](figures/image-13.png){width=65% #fig:trajectory-composition}

Invariance alone does not produce capable agents; systems also need to reuse information aggressively. Humans do this constantly. We do not relearn how to leave home, navigate streets, and enter a building from first principles each day. We compose prior experience and adapt it to the current context, even when weather, timing, and surface details differ.

Trajectory composition is the concrete control analogue, shown in \autoref{fig:trajectory-composition}. If an agent has a dataset of partial routes, it should be able to stitch those fragments into a novel plan between unseen start-goal pairs. This is intuitive on road networks, where intersections define obvious compositional structure. In robotics trajectories, however, overlap and compatibility are often latent, noisy, and high-dimensional, so stitching becomes a difficult representation-and-planning problem.

The Montreal navigation analogy highlights the goal: avoid brute-force coverage of every start-end combination. If data reuse is strong, a finite dataset can support broad transfer. If it is weak, the system remains sample-inefficient and brittle. This is one of the central scientific questions in scalable robot learning: how to transform trajectory logs from "many isolated episodes" into reusable, compositional knowledge.

## Taskable Agents

![Scaling goal-conditioned policies with language \citep{Jang2022-uu}: a single policy conditioned on text goals can generalize across a broad task distribution.](figures/image-15.png){width=90% #fig:goal-conditioned-scaling}

A central design decision for taskable agents is how goals are represented. \autoref{fig:goal-conditioned-scaling} shows how a single policy conditioned on language goals can be scaled across a broad range of task specifications. The naive strategy — one policy per task — quickly becomes memory-inefficient, hard to maintain, and scientifically unsatisfying because it prevents transfer. If each task has its own network, shared perception and control structure is wasted, and adding new tasks scales poorly.

The intermediate strategy is a shared policy with an explicit task context variable, such as one-hot conditioning. This already helps by forcing parameter sharing and reducing duplication. But one-hot conditioning does not naturally generalize to unseen tasks without hand-engineered similarity or manual task indexing.

This motivates richer goal representations, including language and multimodal conditioning. The objective is not only to select among known tasks, but to represent task intent in a way that supports extension and reuse.

An interesting perspective emerges from large language models: evidence suggests that LLMs may already implement an informal version of this structure internally. Certain chunks of the network appear to activate preferentially for specific topic domains — recipe questions, code problems, factual lookup — behaving like implicit sub-policies that are selected by the input context. If this characterization is correct, it means that scaling a single large model over broad text data may organically produce a kind of task-specialized decomposition, without explicit hierarchical design.

Whether this implicit decomposition transfers cleanly to physical control remains an open question. Robotics has extensive experience with explicitly hierarchical policies, but those architectures frequently suffer at the interfaces between levels — the seams where high-level intent must translate to low-level motor commands. Achieving a single large model that handles all levels of abstraction fluidly, while still representing meaningful task-specific structure internally, remains one of the central open problems in generalist robot learning.

## Good Results

The demonstration clips are important because they show that language- and goal-conditioned policies can execute nontrivial manipulation tasks with meaningful success. Behaviors such as placing a banana in a bowl or placing a bottle in a tray indicate that scaling behavior cloning plus richer conditioning can produce practical capabilities, not just toy outcomes.

Still, chapter-quality interpretation requires caution. Demo videos establish possibility, not reliability. A successful clip does not reveal failure rate under perturbation, robustness to object diversity, long-horizon consistency, or recovery from error states. Tooling fragility can also interfere with communication itself — media embedding failures in demo slides are a reminder that real workflows are messy even before deployment.

The right conclusion is therefore balanced: these systems are already useful and impressive in constrained settings, but they remain far from open-world competence. The research challenge is to turn episodic success into systematic capability across environments, users, and task variations.

## Conditioning on Text

![SayCan \citep{saycan2022arxiv} combines language model scoring with robot value functions to ground language instructions in physically feasible action selection.](../lec12-1-LanguageGoalConditionedRL2/figures/saycan.png){width=90% #fig:saycan}

Text is an attractive goal interface because it is low-friction, expressive, and scalable for data collection. The policy $\pi(\at | \st, \text{``Get me a snack"}, \theta)$ takes a natural language string as part of its input, making flexible goal specification possible without requiring a goal image. \autoref{fig:saycan} illustrates one approach to grounding language goals in robot action selection by combining value functions with language model scoring. Compared with producing high-quality goal videos, writing text prompts is much cheaper and easier to standardize. This matters operationally: if we want broad datasets, the goal interface itself must not become a bottleneck.

Another practical advantage is that text can describe desired outcomes that do not yet exist in the dataset. A user can request "fold the laundry" or "clean the room" even when no exact target image is available. In this sense, language supports specification before demonstration, which can expand the task space available to learning algorithms.

Yet text does not solve everything. Performance still depends on how language grounding connects to perception and control. If the model's semantic interpretation is disconnected from physical execution, task completion may be shallow or inconsistent. Text conditioning should be viewed as a powerful interface layer, not a replacement for embodied interaction learning.

## Why Does Text Conditioning Work?

Text conditioning works because large language models encode broad statistical structure about goals, objects, and human intent. This gives agents a flexible symbolic channel for task specification and compositional instructions. In practice, this often makes language a stronger goal descriptor than brittle one-hot encodings.

The grounding problem, however, remains unresolved: linguistic tokens are not physical objects. A "cup" in text is not automatically linked to grasp points, mass distribution, friction, or motion constraints. Likewise, "clean the room" leaves unresolved choices about precision, coverage, and acceptable outcomes. Language can encode purpose, but dynamics live in embodied interaction.

That is why multimodal systems are not optional for robust robotics. Vision, proprioception, and other sensors provide the closed-loop information needed for control, while language supplies high-level intent. Good systems integrate these modalities so that semantic goals constrain action selection without pretending that language alone contains enough information for physically grounded behavior. PaLM-E \citep{driess2023palme} is a representative example of this direction, combining a large language model with visual encoders to produce policies conditioned on both image observations and natural language instructions.

## Where Does the Data Come From?

![Robotics data sources span teleoperation, third-person video, and autonomous interaction; the challenge is assembling enough diversity for stable abstraction learning.](figures/image-16.png){width=70% #fig:robotics-data}

The core data issue in robotics is not raw scarcity but structure, diversity, and accessibility. As \autoref{fig:robotics-data} suggests, there is enormous interaction data in the world — from industrial robots, mobile platforms, and teleoperated systems — but much of it is siloed, weakly labeled, or difficult to transfer across embodiments. Data volume is large, yet usable learning signal remains hard to assemble.

Teleoperation remains attractive because it guarantees physically realizable trajectories for the target platform. That reliability is valuable, but expensive at scale. Third-person human video offers abundance and variety, yet introduces embodiment mismatch: what humans can do may not map directly to robot dynamics or morphology.

The strategic objective is to collect enough diversity that agents discover stable object and task abstractions — seeing enough diversity to realize there is "no diversity" at the right conceptual level. In other words, the model should stop memorizing superficial variation and start learning classes, structure, and controllable dynamics.

# Autonomous Learning Systems (DeepRL)

When curated demonstrations are insufficient, the agent must become an active data collector. This is the motivation for autonomous learning systems: rather than waiting for humans to provide every trajectory, the robot interacts with the environment, evaluates outcomes through rewards, and incrementally improves policy behavior.

Framed this way, reinforcement learning is not merely an optimization module appended to perception; it is a full data-generation and adaptation pipeline. The "infinity-shot" framing is useful here: if the system can safely keep interacting, it can eventually solve many tasks that were never explicitly demonstrated, provided reward design and exploration are appropriate.

The practical challenge is therefore engineering, not philosophy: can we build autonomous loops that are stable, sample-efficient, and safe enough for deployment? If yes, autonomous interaction becomes the mechanism that scales data collection beyond manual imitation and enables continual adaptation in real environments. ReLMM \citep{realmm} is a concrete illustration of this approach, demonstrating a robot that autonomously collects experience and improves its manipulation policy through self-supervised interaction.

## Autonomous Learning

![An unstructured real-world environment where autonomous learning must operate: cluttered, variable, and lacking manual resets \citep{squirrel2013project}.](figures/image.png){width=55% #fig:cluttered-env}

![The reinforcement learning loop: the agent takes an action $\at$, the environment transitions to $\bs_{t+1}$ and emits reward $r_t$, and the policy is updated to favor higher-return actions.](figures/image-1.png){width=60% #fig:rl-loop}

Learning from interaction matters because it closes the loop between decision and consequence. Instead of imitating static datasets forever, the agent acts, receives feedback, and updates behavior in response to the environment it actually inhabits. This is essential in robotics, where deployment conditions differ from collection conditions and edge cases are unavoidable.

The loop itself is conceptually simple — take action, observe next state, compute reward, reinforce better choices, as depicted in \autoref{fig:rl-loop} — but operationally deep. \autoref{fig:cluttered-env} illustrates the kind of unstructured environment where autonomous learning must operate. It couples perception, control, credit assignment, and planning under uncertainty. This is why RL is often described as a microcosm of the broader AI problem: nearly every major learning challenge appears inside one recurring process.

From a systems perspective, the implication is clear. Making this loop robust and data-efficient yields a general mechanism for adaptation. Without it, systems remain trapped in brittle imitation pipelines that fail when the world shifts even slightly.

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

A useful unifying view of deep RL is trajectory-centric. A policy induces a distribution over trajectories through interaction with environment dynamics, as formalized in \autoref{eq:path-prob}, and optimization seeks to maximize expected cumulative reward over that distribution, as given in \autoref{eq:sum-reward}. This framing is more informative than thinking only in terms of one-step losses or isolated predictions.

It clarifies what we mean by robust performance: not merely accurate local estimates, but sustained high return under long-horizon execution. In robotics, small local errors compound over time, so trajectory-level reasoning is the right granularity for evaluating progress.

This perspective also provides a diagnostic tool. When methods fail, we can ask whether they misestimate values, mis-handle distribution shift, underexplore state space, or produce unstable policy updates. Returning to the trajectory objective repeatedly helps separate superficial metric gains from genuine control improvements.

## Is Reinforcement Learning Data Hungry?

![A deep network policy maps observations to actions; the data efficiency question is how many environment interactions are needed before this mapping becomes reliable.](figures/vgg16-policy-choice.png){width=90% #fig:data-hungry-policy}

A useful starting point is the contrast between supervised learning and reinforcement learning at the level of data structure, illustrated architecturally in \autoref{fig:data-hungry-policy}. Supervised learning assumes independent and identically distributed (IID) samples: each example is drawn from a fixed distribution, and the order in which examples arrive does not affect the training signal. In practice this assumption is rarely perfectly satisfied, but it is a good enough approximation that supervised learning can be applied widely and reliably.

Reinforcement learning never enjoys this assumption. Every transition the agent collects depends on the policy that generated it, which in turn depends on all prior updates. The agent cannot go back and re-sample a state it visited last week; that exact state of the world no longer exists. Data is therefore sequentially correlated, policy-dependent, and non-stationary throughout training. These properties undermine the convergence arguments that make supervised learning tractable.

Beyond the IID issue, deep RL is often described as data-hungry because many algorithms require repeated exposure to similar states before converging. But the sharper framing is data utilization, not only data volume. Given a fixed dataset, how effectively can the algorithm extract reusable signal? If update rules cannot absorb information already present in replay, the system appears data-hungry even when sufficient evidence is already available.

This distinction matters for research priorities. Some failures are exploration failures, but many are optimization and credit-assignment failures over existing data. Improving data reuse can therefore produce large sample-efficiency gains without changing exploration budgets, and without requiring exploration to be solved first.

## How can Reinforcement Learning be Better Fed?

![The data hierarchy (LeCun 2018): unsupervised and self-supervised signals vastly outnumber labeled reward signals, yet RL methods often fail to exploit the unlabeled majority.](../lec17-OfflineRL/figures/lecun-cake){width=70% #fig:lecun-cake}

The "better fed" question asks whether RL's sample complexity is fundamental or partly self-inflicted through weak replay efficiency. \autoref{fig:lecun-cake} frames this through the analogy of cake, icing, and cherries: the vast majority of useful signal lies in the unlabeled or self-supervised regime, and current RL methods often fail to exploit it. In many settings, interaction data is expensive, but algorithms still fail to fully exploit what they already collected.

Supervised learning achieves strong efficiency partly by revisiting static datasets many times. Deep RL often cannot do this safely: repeated optimization on replay can destabilize value estimates and induce policy collapse. As a result, data that should be informative is effectively underused.

Improving how RL is fed means increasing useful passes over replay while maintaining stability. If each transition contributes more gradient signal before being discarded, we reduce real-world interaction costs and move closer to practical autonomous learning.

# Can Reinforcement Learning Eat More?

![Squeezing every useful gradient from collected experience: the goal is to maximize replay ratio while avoiding value divergence.](figures/image-18.png){width=65% #fig:replay-efficiency}

A central asymmetry between supervised learning and deep RL is replay stability. Supervised models often tolerate many epochs over the same data; deep RL models frequently diverge when replay is pushed too aggressively. \autoref{fig:replay-efficiency} captures the goal: extracting every useful gradient from collected data before discarding it. This makes RL paradoxically bad at one of the most valuable forms of learning efficiency.

On-policy methods are stable but data-limited, often reusing each batch only a small number of times. Off-policy methods increase reuse by learning from behavior generated by older policies, but this introduces distribution mismatch and bootstrapping instability. This is a constant balancing act between reuse and divergence.

The long-term objective is therefore explicit: increase replay ratio and model capacity while controlling instability. Progress on this front is not a minor optimization; it is foundational for making RL viable in data-constrained robotic domains.

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

Conceptually, this should let the learner squeeze much more signal from each expensive interaction.

The key parameter is replay ratio, often denoted by $k$, which measures how many gradient updates are performed per unit of newly collected data. In an ideal world, we would push $k$ very high and continue improving until learning saturates. In practice, higher replay often amplifies value overestimation, distribution mismatch, and bootstrapping artifacts.

Much of modern deep RL can be interpreted as controlled attempts to raise effective replay safely: better targets, regularization, conservative updates, and representation stabilization. The engineering goal is simple to state but hard to achieve: maximize learning per sample without crossing the divergence boundary.

## How can RL scale?

![Stochastic policy-ascent dynamics become harder to control as model capacity increases, creating instability that does not appear at smaller scales \citep{hui2018rlopt}.](figures/image-5.png){width=70% #fig:scaling-instability}

In RL, scaling is not just a parameter-count question; it is an optimization-dynamics question. \autoref{fig:scaling-instability} shows how stochastic policy-ascent dynamics become harder to control as model capacity grows. Larger networks can represent richer behaviors, but they also increase sensitivity to update noise when data is non-IID and continuously shifting. This is why methods that scale well in supervised learning can become unstable in online RL.

The stochastic policy-ascent intuition is helpful: every update changes the action distribution, and with high-capacity models those shifts can be unexpectedly large. If the policy moves too far in one step, data collected under prior behavior no longer matches the current policy well, and learning degrades.

Current mitigation strategies include network resets \citep{Nikishin2022-sb}, constrained updates \citep{Tang2024-bg}, and pretrained model priors \citep{Zeng2024-zq}. These methods help, but robust evidence remains uneven across algorithm families. Value-based pipelines have seen more scaling wins than pure policy-gradient systems, where variance and instability remain major bottlenecks.

## How Well Does Deep RL Work?

Deep RL methods differ not only in implementation but in objective alignment. Value-based methods optimize Bellman-consistency surrogates, which are useful but only indirectly related to true return maximization in nonlinear regimes. This helps explain why low value error does not always translate into strong control behavior.

Model-based methods face a related disconnect. Improving world-model prediction quality can be valuable, but better one-step prediction does not automatically imply better policy performance unless planning and control exploit that model correctly. The gap is practical: a model can be made more accurate without any guarantee of improved return.

Policy-gradient methods are attractive because they optimize return more directly, but that benefit comes with high variance and sensitivity to update stability. The broader lesson is that no family is universally superior; each introduces different trade-offs between objective fidelity, sample efficiency, and optimization robustness.

## Reinforcement Learning Assumptions

A recurring theme in robot learning is assumption mismatch. Three assumptions appear most frequently in the theoretical foundations of deep RL, and all three are routinely violated in real robotic settings.

The first is full observability: many value-function algorithms assume the policy conditions on the complete state $\st$ rather than a partial observation $\bo_t$. In practice, sensors are occluded, time-varying, and noisy. The standard mitigation is to add recurrent memory — typically an LSTM — so the policy can integrate evidence over time rather than acting on a single frame. This helps, but it shifts the problem from observability to credit assignment over long histories.

The second is episodic resettability, or ergodicity: some algorithms implicitly assume that $p(\bs) > 0$ for all relevant states — that is, the agent can revisit any state during training. In robotics this fails because time cannot be rewound. A physical robot that breaks an object or tips over cannot replay that transition from scratch. Algorithms that depend on dense, on-demand revisitation of past states must be redesigned or supplemented with explicit data-collection strategies for real deployment.

The third is continuity or smoothness: continuous value-function methods and some model-based approaches assume the dynamics and reward are smooth enough to support gradient-based updates. Contact-rich manipulation, locomotion on rough terrain, and other physically realistic settings routinely violate this through hard contacts, impacts, and discontinuous friction.

Recognizing which assumptions a given algorithm requires, and which are violated by a given platform, is the first diagnostic step when methods fail to transfer from simulation to the real world.

Assumptions are still useful as analytical scaffolding, but they should be treated as approximations, not deployment guarantees. For applied research, a stronger workflow is to identify which assumptions fail first for the target platform and build explicit mitigation strategies into the algorithm and evaluation protocol.

## The Importance of Embodiment

![Different robot morphologies — stationary arm, wheeled base, humanoid — expose different controllable state spaces and constrain what behaviors and abstractions can be learned.](figures/image-3.png){width=65% #fig:robot-embodiment}

Embodiment is not peripheral to intelligence; it defines the space of possible interaction. The amoeba thought experiment makes this vivid: with extremely limited mobility and actuation, an agent can only sample a narrow slice of the world, which restricts what it can learn regardless of algorithm quality.

The same principle applies to robots. As shown in \autoref{fig:robot-embodiment}, a stationary arm, a wheeled base, and a dexterous humanoid each expose different controllable state spaces and affordances. If a platform cannot manipulate objects, it cannot acquire manipulation-relevant experience; if it cannot navigate varied terrain, its world model remains narrow.

For this reason, morphology should be treated as part of the learning problem, not merely hardware packaging. Progress toward general-purpose agents depends on aligning algorithm design with embodiment capabilities, because representation, exploration, and skill acquisition are all constrained by what the body can physically do.

The question of whether humanoid morphology is necessary for general-purpose robotics remains open. The humanoid form grants access to environments and tools designed for human proportions — doorknobs, staircases, keyboards, chairs — which is a meaningful advantage for systems meant to operate in homes and offices. Against this, humanoid locomotion is mechanically complex and costly to control, and many tasks that benefit from a humanoid form can be partially addressed with simpler morphologies equipped with appropriate end-effectors. The answer likely depends on task scope: a narrow-task robot can be purpose-built, while a truly general-purpose agent may eventually require the embodiment flexibility that the humanoid form provides.

# What behaviour do Users Want agents to optimize?

![A goal image often over-specifies intent: the user wants a clean room, but pixel-level matching can inadvertently penalize irrelevant changes like outdoor scenery visible through a window.](../talk-RobotLearning/figures/GoalImageIssues.png){width=85% #fig:goal-image-issues}

Goal images are intuitive, but they often over-specify user intent. \autoref{fig:goal-image-issues} illustrates how the same goal image can be interpreted in multiple conflicting ways. If optimization is tied to pixel-level matching, the agent may be penalized for irrelevant differences — lighting, background changes, or scenery outside a window — even when the true task objective is satisfied.

In extreme form, pixel matching can imply absurd objectives, such as implicitly reconstructing the entire outside world to match the historical scene visible through a window. This is not what users mean by "clean my room," but it can still emerge from poorly aligned reward definitions.

The challenge is balancing specificity with flexibility. Text goals are often under-specified, while image goals are often over-specified. Better goal representations should capture intent-level constraints and leave irrelevant variation unconstrained, so policies optimize what users actually care about rather than accidental visual details.

## Learning New Skills

![The landscape of skills learned by current systems: a large portion consists of reproducing demonstrations or human knowledge, with limited capacity for genuinely novel discovery.](figures/image-7.png){width=65% #fig:learning-new-skills}

Much of contemporary progress still emphasizes reproducing known behaviors: imitation learning from expert demonstrations, benchmark repetition, and constrained task suites, as reflected in \autoref{fig:learning-new-skills}. These are valuable milestones, but they do not fully test whether an agent can produce genuinely new solutions in open-ended settings. Critically, both imitation learning and large language models are trained predominantly on existing human knowledge — they are efficient at recombining what people already know, not at generating fundamentally new solutions.

The more ambitious goal is to build agents capable of scientific discovery and open-ended problem solving. Consider the goal of designing a more efficient battery. This is categorically different from cleaning a room: there is no known optimal solution in any demonstration dataset, the search space involves physical chemistry rather than motor control, and evaluation requires novel experimental evidence rather than task completion criteria. An agent capable of pursuing such goals would need to act as an autonomous scientific instrument — designing hypotheses, collecting evidence, and revising plans iteratively.

Humans are not actually well-suited to this kind of extended, unbiased planning. We are prone to anchoring on familiar solutions and struggle with exhaustive combinatorial search. Machine learning systems, by contrast, can evaluate large hypothesis spaces systematically if given appropriate structure. The combination of physical interaction through robotics, planning through search or model-based RL, and broad language priors through foundation models may eventually support genuinely novel discovery — but it requires going substantially beyond the replay-based pipelines dominant in current benchmarks.

This is where continual learning becomes essential. Real deployments include long tails of unusual cases, shifting constraints, and nonstationary objectives. Systems that stop learning after pretraining will plateau quickly; systems that continue to adapt can accumulate capabilities and handle novelty with increasing competence over time.

## Consider the Environment

![Sources of environmental stochasticity and nonstationarity: other agents, natural changes, novel objects, and real-time constraints that do not pause for deliberation.](figures/image-8.png){width=65% #fig:environment-stochasticity}

Real environments are not static testbeds. As illustrated in \autoref{fig:environment-stochasticity}, they contain other agents, shifting conditions, changing constraints, and persistent uncertainty. In this setting, policies must be robust not only to noise but to ongoing nonstationarity generated by interaction itself.

This is why naive novelty-seeking is insufficient. Useful behavior requires structured adaptation: the agent should explore enough to learn, but remain stable enough to preserve task performance and safety. Diversity and chaos are features of the real world, not corner cases.

A further deployment constraint is timing. Real-time control does not wait for slow deliberation. If model complexity grows without latency control, performance can collapse even when nominal policy quality appears high offline. Practical intelligence in robotics therefore combines adaptation quality with strict reaction-time discipline.

## What is our reward function?

![A robot learning to construct shelter as an emergent behavior from surprise-minimization objectives: maintaining local order as a proxy for long-term survival.](figures/image-9.png){width=65% #fig:shelter-construction}

Reward specification is one of the hardest unsolved problems in autonomous learning. Even when broad principles are compelling — such as minimizing surprise or maintaining local order — they are difficult to translate into tractable objectives that can be optimized at scale.

The biological framing is insightful: agents survive by keeping key state variables within viable ranges despite environmental volatility \citep{friston2009free}. This naturally motivates behaviors like the shelter construction shown in \autoref{fig:shelter-construction} — an emergent outcome of surprise-minimization objectives \citep{berseth2019smirl} — as well as resource management and predictive control. In robotics terms, it suggests objectives that reward stability and resilience rather than narrow one-step gains.

However, elegant principles are not enough. Rewards must be computable, aligned with desired long-horizon outcomes, and resistant to shortcut solutions. Poorly specified rewards produce behavior that is technically optimal but practically wrong. The chapter-level takeaway is clear: reward design is not an implementation detail; it is the central interface between human intent and autonomous behavior.

## The Supports

![The three foundational pillars of robot learning: deep learning for perception and representation, reinforcement learning for autonomous interaction, and generalization methods for transfer.](figures/three-key-components.png){width=80% #fig:three-pillars}

The three pillars illustrated in \autoref{fig:three-pillars} — deep learning for perception and representation, reinforcement learning for autonomous interaction, and generalization methods for transfer to new settings — are not independent components. They form mutually reinforcing foundations that must all function together before a robot can operate competently in the open world.

Deep learning provides the capacity to process high-dimensional, unstructured observations such as images and proprioceptive signals, and to learn compact representations that support downstream decision-making. Without strong perception, the policy cannot accurately assess the current state of the world, and neither planning nor reward optimization will function reliably.

Reinforcement learning provides the mechanism for acquiring behavior through interaction rather than through explicit programming or manual demonstration. It allows the agent to discover solutions that would be impractical to specify in advance and to continue improving beyond the limits of any available dataset.

Generalization methods — including goal conditioning, transfer learning, domain randomization, and simulation-to-real transfer — provide the means to extend competence beyond the specific situations encountered during training. Without generalization, a robot is a sophisticated but narrow specialist: it performs well on the exact task and environment for which it was trained, and degrades under any variation.

Together these three pillars define the scope of modern robot learning research, and together they define the structure of this course. Progress on any one pillar in isolation is insufficient; effective robotic systems require all three to be addressed simultaneously.

## Get Involved and Learn (10%)

![The causal graph underlying active learning: passive observation is insufficient to disentangle correlation from causation; interventions (actions with observed outcomes) are required to build a correct causal model.](figures/causal-graph.png){width=55% #fig:causal-graph}

The connection between active participation and learning is not metaphorical — it reflects a deep theoretical result in causal inference, illustrated in \autoref{fig:causal-graph}. To build an accurate causal model of a domain, passive observation is insufficient. An agent must make interventions: take actions, observe the resulting changes, and compare outcomes across conditions. Without intervention, correlation and causation cannot be disentangled, and the model remains a statistical summary of observed patterns rather than a true account of how the world responds to actions.

The same principle applies to learning in a classroom or research setting. Passive attendance exposes a student to information, but it does not guarantee that a correct causal model is acquired. The way to find out whether an understanding is accurate — and to correct it if it is not — is to make interventions: ask questions, propose answers, attempt problems, and observe where the responses diverge from expectation.

An early experiment in developmental neuroscience illustrates the stakes. Kittens that were physically prevented from moving during a critical period of visual development — carried passively rather than allowed to walk — later failed to develop normal depth perception and motor coordination, even though they had been exposed to the same visual scenes as their free-moving littermates. Active interaction with the environment, not mere passive exposure to its sensory outputs, was required to develop calibrated representations and control.

This principle scales to research. A scientist who only reads papers and never runs experiments, conducts ablations, or tests predictions against real data will develop imprecise intuitions that cannot be reliably corrected. The intervention loop — act, observe, update — is the shared mechanism behind reinforcement learning, scientific discovery, and learning in any domain.
