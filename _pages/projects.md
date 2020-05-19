---
title: "Projects"
permalink: /projects/
---

## IN PROGRESS

<ul>
    {% for page in site.pages %}

        {% if page.path contains 'projects' %}
            <li>{{page.title}}</li>
        {% endif %} 
    {% endfor %} 
</ul>

[IST718_FinalProject](https://danielcaraway.github.io/support_material/IST718_FinalProject.md)

[Flask + d3 App](https://ist718031230.herokuapp.com/)

https://anvil.works/learn/examples/dashboard

