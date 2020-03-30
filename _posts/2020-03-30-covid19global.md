---
layout: single
title: 'COVID19 Global'
tags: covid19 kaggle
---

# KAGGLE COMPETITION:

["Current" Colab](https://colab.research.google.com/drive/1lx-OVp2sjlMgZqpooEYb05gXPBO2hM9v)

[Competition deets here](https://www.kaggle.com/c/covid19-local-us-ca-forecasting-week-1/data)

## GOOGLE DOCS:

[GOOGLE DOC](https://docs.google.com/document/d/1hakPdBy-8GfjuxMmeDYl4ySOmEOK1X0PX0o20LwwFDc/edit)

# HTML FILES:

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

# JUPYTER FILES:

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

# REFERENCES:

[Stacked bar charts](https://pstblog.com/2016/10/04/stacked-charts)

[NCBI](https://www.ncbi.nlm.nih.gov/labs/virus/vssi/#/virus?SeqType_s=Nucleotide&VirusLineage_ss=Wuhan%20seafood%20market%20pneumonia%20virus,%20taxid:2697049)