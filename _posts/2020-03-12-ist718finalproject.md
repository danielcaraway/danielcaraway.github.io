---
layout: single
title: 'IST718 Final Project'
tags: ist718 lab 
---

# Final Project

## Step 1: Freak out because there is so much information

## Step 2: Calm down because you've got this

## Step 3: Start small

<div>
{% for file in site.static_files %}
    {% if file.path contains 'ist718finalproject' %}
        
            <div>
                <a href="https://danielcaraway.github.io/{{ file.path }}">{{ file.basename }}</a>
            </div>

    {% endif %}
{% endfor %}
</div>
