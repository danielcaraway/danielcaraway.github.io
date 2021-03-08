---
layout: single
title: EHD Notes
permalink: /EHD/
---

<div>
<h1> HTML FILES </h1>
{% for file in site.static_files %}
    {% if file.path contains 'EHD' %}
        {% if file.extname contains '.html' %}
            <div><a href="https://danielcaraway.github.io/{{ file.path }}">{{ file.basename }}</a></div>
        {% endif %}
    {% endif %}
{% endfor %}
</div>
<hr>
<br>
<div>
<h1> PYTHON FILES </h1>
{% for file in site.static_files %}
    {% if file.path contains 'EHD' %}
        {% if file.extname contains '.py' %}
            <div><a href="https://danielcaraway.github.io/{{ file.path }}">{{ file.basename }}</a></div>
        {% endif %}
    {% endif %}
{% endfor %}
</div>
<hr>
<br>
<div>
<h1> CSV </h1>
{% for file in site.static_files %}
    {% if file.path contains 'EHD' %}
        {% if file.extname contains '.csv' %}
            <div><a href="https://danielcaraway.github.io/{{ file.path }}">{{ file.basename }}</a></div>
        {% endif %}
    {% endif %}
{% endfor %}
</div>

<!-- {{ t | downcase }} -->

<div>
<h1> POSTS WITH TAGS </h1>
<ul>
{% for tag in site.tags %}
{% assign t = tag | first %}
{% assign posts = tag | last %}
{% for post in posts %}
  {% if post.tags contains 'EHD' %}
  <li>
    <a href="{{ post.url }}">{{ post.title }}</a>
    <span class="date">{{ post.date | date: "%B %-d, %Y"  }}</span>
  </li>
  {% endif %}
{% endfor %}
</ul>
{% endfor %}
</div>
