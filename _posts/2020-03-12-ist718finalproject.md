---
layout: single
title: 'IST718 Final Project'
tags: ist718 lab 
---

# Final Project

## HOW TO:

* Step 1: Freak out because there is so much information
* Step 2: Calm down because you've got this
* Step 3: Start small

## PRESENTATION: 

<iframe src="https://docs.google.com/presentation/d/e/2PACX-1vTpk5aPVmo7zRT0iyXmEopwMh_bUuBc5j4sO3qZkiG6OaDkFYxmu0ORlsiyWArX8tMIf9zZGguswAqt/embed?start=false&loop=false&delayms=5000" frameborder="0" width="960" height="569" allowfullscreen="true" mozallowfullscreen="true" webkitallowfullscreen="true"></iframe>

## FILES: 

<div>
{% for file in site.static_files %}
    {% if file.path contains 'ist718finalproject' %}
        
            <div>
                <a href="https://danielcaraway.github.io/{{ file.path }}">{{ file.basename }}</a>
            </div>

    {% endif %}
{% endfor %}
</div>
