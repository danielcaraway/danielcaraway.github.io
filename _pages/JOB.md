---
layout: single
title: Job Notes
permalink: /job/
---

# SUCCESS LOOKS LIKE:

Having a job at a company I admire with a team that I can learn from and grow with

## POSTS:

<div>
<h1> POSTS WITH JOB TAGS </h1>
<ul>
{% for post in site.posts %}
  {% if post.tags contains 'job' %}
  <li>
    <a href="{{ post.url }}">{{ post.title }}</a>
    <span class="date">{{ post.date | date: "%B %-d, %Y"  }}</span>
  </li>
  {% endif %}
{% endfor %}
</ul>
</div>

## POSTS:

<div>
<h1> Class Deliverables </h1>
{% for file in site.static_files %}
    {% if file.path contains 'JOB/' %}
        {% if file.extname contains '.html' %}
            <div><a href="https://danielcaraway.github.io/{{ file.path }}">{{ file.basename }}</a></div>
        {% endif %}
    {% endif %}
{% endfor %}
</div>
## NOTES:

### CURRENTLY LOOKING AT:

- AWS
- TWITTER
- CAPITAL GROUP
