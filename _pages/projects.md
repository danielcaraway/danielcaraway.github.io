---
title: 'Projects'
permalink: /projects/
---

## CURRENT:

1. Donna Data
2. EHD
3. DIR/YIR/Texts

## BACKLOG:

4. Tableau?
5. Nest-analyzer
6. KendraMSDS /SYR portfolio

## IN PROGRESS

<ul>
    {% for page in site.pages %}
        {% if page.path contains 'projects' %}
            <li>{{page.title}}</li>
        {% endif %} 
    {% endfor %} 
</ul>

# ALL

<ul>
    {% for page in site.pages %}
        <li>{{page.title}}</li>
    {% endfor %} 
</ul>

[IST718_FinalProject](https://danielcaraway.github.io/support_material/IST718_FinalProject.md)

[Flask + d3 App](https://ist718031230.herokuapp.com/)

https://anvil.works/learn/examples/dashboard
