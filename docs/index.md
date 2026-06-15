---
layout: default
title: Home
---

<section class="about">
<div class="container" markdown="1">

This course covers the core algorithms and ideas at the intersection of deep learning and robotics,
progressing from supervised imitation learning through model-based planning, policy gradient methods,
value-based RL, goal-conditioned policies, reward learning, and practical deployment concerns.
Slides and book chapters are drawn from three years of the graduate course at Université de Montréal.

</div>
</section>

<section class="wip-notice">
<div class="container">
<p>
  <strong>Programming assignments</strong> for this course are available on
  <a href="https://github.com/milarobotlearningcourse" target="_blank">GitHub (milarobotlearningcourse)</a>.
  Note that the assignments are a work in progress and will continue to be updated.
</p>
</div>
</section>

<section class="lectures-section">
<div class="container">

<h2>Lectures</h2>

{% assign playlist = site.youtube_playlist %}
{% assign sorted_lectures = site.lectures | sort: "num" %}
{% assign tracks = sorted_lectures | map: "track" | uniq %}

{% for track in tracks %}
<div class="track-section">
<h3 class="track-title">{{ track }}</h3>
<div class="cards">
{% for lec in sorted_lectures %}{% if lec.track == track %}
<a class="card card-link" href="{{ lec.url | relative_url }}">
  <div class="card-num">{{ lec.num }}</div>
  <div class="card-body">
    <h4>{{ lec.title }}</h4>
    <div class="card-tags">
      {% if lec.youtube_id %}
        <span class="tag tag-video">Video</span>
      {% else %}
        <span class="tag tag-video">Playlist</span>
      {% endif %}
      {% if lec.slides_url %}<span class="tag tag-slides">Slides</span>{% endif %}
      {% if lec.colab_url %}<span class="tag tag-colab">Colab</span>{% endif %}
      {% if lec.chapter_url %}<span class="tag tag-chapter">Chapter</span>{% endif %}
    </div>
  </div>
</a>
{% endif %}{% endfor %}
</div>
</div>
{% endfor %}

</div>
</section>

<section class="changelog">
<div class="container">
<h2>Changelog</h2>
<ul>
  <li><strong>2026-06-14</strong> — Initial website launch with lecture slides, videos, and readings.</li>
</ul>
</div>
</section>
