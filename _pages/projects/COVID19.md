---
title: "COVID19"
permalink: /projects/COVID19/
---


## FILES: 

<div>
{% for file in site.static_files %}
    {% if file.path contains 'covid19' %}
        
            <div>
                <a href="https://danielcaraway.github.io/{{ file.path }}">{{ file.basename }}</a>
            </div>

    {% endif %}
{% endfor %}
</div>


## INSPIRATION

[NYTimes](https://www.nytimes.com/interactive/2020/us/coronavirus-us-cases.html)

## SUPPORT MATERIAL


## POSTS TAGGED

{% capture site_tags %}{% for tag in site.tags %}{{ tag | first | downcase }}#{{ tag | first }}{% unless forloop.last %},{% endunless %}{% endfor %}{% endcapture %}
{% assign tag_hashes = site_tags | split:',' | sort %}
<ul class="list-group">
{% for hash in tag_hashes %}
  {% assign keyValue = hash | split: '#' %}
  {% capture tag_word %}{{ keyValue[1] | strip_newlines }}{% endcapture %}
  <li class="list-group-item">
    <a href="/tags/{{ tag_word }}">
      {{ tag_word }}
      <span class="badge pull-right">{{ site.tags[tag_word].size }}</span>
    </a>
  </li>
{% endfor %}
</ul>

