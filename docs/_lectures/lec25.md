---
num: "25"
title: "Data Collection for Robotics"
track: "Behavior Cloning & Imitation"
youtube_id: "o0LR44I1dKI"
slides_url: "https://drive.google.com/file/d/1zkQKAjzYtE4Ohcw2EfRNvK69gpRqGHfH/view"
colab_url:
chapter_url:
readings:
  - url: "https://arxiv.org/abs/2308.12952"
    title: "BridgeData V2: A Dataset for Robot Learning at Scale"
  - url: "https://droid-dataset.github.io/"
    title: "DROID: A Large-Scale In-the-Wild Robot Manipulation Dataset"
  - url: "https://openaccess.thecvf.com/content_ECCV_2018/html/Dima_Damen_Scaling_Egocentric_Vision_ECCV_2018_paper.html"
    title: "Scaling Egocentric Vision: The EPIC-KITCHENS Dataset"
  - url: "https://arxiv.org/abs/2402.10329"
    title: "Universal Manipulation Interface: In-The-Wild Robot Teaching Without In-The-Wild Robots"
description: >
  Data collection strategies for robot learning at scale: teleoperation interfaces,
  crowdsourcing, robot-assisted data collection, and the design principles behind
  large robotics datasets like RT-X and DROID.
---

The quantity and diversity of training data is increasingly the bottleneck for robot learning.
This lecture covers how to collect the right data efficiently — from single-arm teleoperation
to fleet-scale collection across many robots and environments.

### Key topics

- Teleoperation interfaces: VR, kinesthetic teaching, retargeting
- Crowdsourcing robot demonstrations at scale
- Robot-assisted data collection: guided and autonomous collection
- Dataset design: diversity, coverage, and task specification
- Large-scale datasets: RT-X, DROID, Open X-Embodiment
- Connections to offline RL (Lecture 17) and imitation (Lecture 01)
