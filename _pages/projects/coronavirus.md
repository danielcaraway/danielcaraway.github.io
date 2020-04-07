---
title: "CORONAVIRUS"
permalink: /projects/coronavirus/
---



## SUPPORT MATERIAL

### INSPIRATION

[NYTimes](https://www.nytimes.com/interactive/2020/us/coronavirus-us-cases.html)

### DATA 

[NYTimes Data](https://github.com/nytimes/covid-19-data)

## FILES: 

### HTML FILES:

<div>
{% for file in site.static_files %}
    {% if file.path contains 'covid19' %}
        {% if file.extname contains '.html' %}
            <div>
                <a href="https://danielcaraway.github.io/{{ file.path }}">{{ file.basename }}</a>
            </div>
        {% endif %}
    {% endif %}
{% endfor %}
</div>

### JUPYTER FILES:

<div>
{% for file in site.static_files %}
    {% if file.path contains 'covid19' %}
        {% if file.extname contains '.ipynb' %}
            <div>
                <a href="https://danielcaraway.github.io/{{ file.path }}">{{ file.basename }}</a>
            </div>
        {% endif %}
    {% endif %}
{% endfor %}
</div>

### POSTS TAGGED 2

{% capture site_tags %}{% for tag in site.tags %}{{ tag | first | downcase }}#{{ tag | first }}{% unless forloop.last %},{% endunless %}{% endfor %}{% endcapture %}
{% assign tag_hashes = site_tags | split:',' | sort %}
<ul class="list-group">
{% for hash in tag_hashes %}
  {% assign keyValue = hash | split: '#' %}
  {% capture tag_word %}{{ keyValue[1] | strip_newlines }}{% endcapture %}
    {% if tag_word contains 'covid' %}
        <li class="list-group-item">
            <a href="/tags/#{{ tag_word }}">
            {{ tag_word }}
            <span class="badge pull-right">{{ site.tags[tag_word].size }}</span>
            </a>
        </li>
      {% endif %}
{% endfor %}
</ul>