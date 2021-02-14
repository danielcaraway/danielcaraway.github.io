---
layout: single
title: EHD Notes"
permalink: /EHD/
---

<div>
<h1> Testing this thing </h1>
{% for file in site.static_files %}
    {% if file.path contains 'EHD' %}
        {% if file.extname contains '.py' %}
            <div><a href="https://danielcaraway.github.io/{{ file.path }}">{{ file.basename }}</a></div>
        {% endif %}
    {% endif %}
{% endfor %}
</div>
