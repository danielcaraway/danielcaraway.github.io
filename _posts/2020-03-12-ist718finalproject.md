---
layout: single
title: 'IST718 Final Project'
tags: ist718 lab 
---

# Final Project

<div>
{% for file in site.static_files %}
    {% if file.path contains 'ist718finalproject' %}
        
            <div>
                <a href="https://danielcaraway.github.io/{{ file.path }}">{{ file.path }}</a>
            </div>

    {% endif %}
{% endfor %}
</div>
