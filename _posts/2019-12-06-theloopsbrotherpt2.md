---
layout: single
title: 'THE LOOPS BROTHER PT2'
tags: testing 
---

<div>
<h1> Testing this thing </h1>
{% for file in site.static_files %}
    {% if file.path contains 'all_html' %}
        {% if file.extname contains '.html' %}
            <a href="https://danielcaraway.github.io/{{ file.path }}">{{ file.path }}</a></br>
        {% endif %}
    {% endif %}
{% endfor %}
</div>