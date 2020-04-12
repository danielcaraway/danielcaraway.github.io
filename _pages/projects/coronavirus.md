---
title: "CORONAVIRUS"
permalink: /projects/coronavirus/
---

## CURRENT STATUS


### JUST MARCH

<div class="flourish-embed flourish-bar-chart-race" data-src="visualisation/1897466" data-url="https://flo.uri.sh/visualisation/1897466/embed"><script src="https://public.flourish.studio/resources/embed.js"></script></div>

### SINCE JAN

<div class="flourish-embed flourish-bar-chart-race" data-src="visualisation/1897175" data-url="https://flo.uri.sh/visualisation/1897175/embed"><script src="https://public.flourish.studio/resources/embed.js"></script></div>

### PER CAPITA (in progress, obviously)

<div class="flourish-embed flourish-bar-chart-race" data-src="visualisation/1897673" data-url="https://flo.uri.sh/visualisation/1897673/embed"><script src="https://public.flourish.studio/resources/embed.js"></script></div>

## SUPPORT MATERIAL

### INSPIRATION

[NYTimes](https://www.nytimes.com/interactive/2020/us/coronavirus-us-cases.html)

### DATA 

[NYTimes Data](https://github.com/nytimes/covid-19-data)
[SRK Kaggle Data](https://www.kaggle.com/sudalairajkumar/novel-corona-virus-2019-dataset)

### KAGGLE NOTEBOOKS

[SEIR-HCD By Datasaurus](https://www.kaggle.com/anjum48/seir-hcd-model)
[LightGBM](https://www.kaggle.com/osciiart/covid19-lightgbm/data)
[Guy with Worldometer charts at the end](https://www.kaggle.com/binhlc/sars-cov-2-exponential-model-week-2)
[Current most popular notebok -- Patrick Sanchez](https://www.kaggle.com/saga21/covid-global-forecast-sir-model-ml-regressions)
[Inspired by Datasaurs](https://www.kaggle.com/super13579/covid-19-global-forecast-seir-visualize/data#SEIR-&-PR-Model-for-COVID19-Global-forecast)


### OTHER

[Math of Epidimecs -- Intro to SIR Model](https://www.youtube.com/watch?v=Qrp40ck3WpI)
[3Blue1Brown Simulating epidemic](https://www.youtube.com/watch?v=gxAaO2rsdIs)
[Pandas -- cummax](https://www.kaggle.com/c/covid19-global-forecasting-week-1/discussion/139172)
[Simple multi-line chart](https://python-graph-gallery.com/122-multiple-lines-chart/)
.ravel()

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

[Currently useless google doc](https://docs.google.com/document/d/1hakPdBy-8GfjuxMmeDYl4ySOmEOK1X0PX0o20LwwFDc/edit)

### LOG 

4/9/20
left off locally here 
* COVID19_KAGGLE_BREAKING_DOWN_WK3_SUBMISSION
* COVID19_KAGGLE_WK3_QUICK_EDA
* KAGGLE_WK3
* [COLAB](https://colab.research.google.com/drive/1aUEdPSt6C3mW2NpYbT5DxRt4BPksfQKR#scrollTo=PlGeMDSvBgsC)