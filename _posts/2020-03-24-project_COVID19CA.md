---
layout: single
title: 'COVID19 CA'
tags: covid19 kaggle
---

# KAGGLE COMPETITION:

["Current" Colab](https://colab.research.google.com/drive/1lx-OVp2sjlMgZqpooEYb05gXPBO2hM9v)

[Competition deets here](https://www.kaggle.com/c/covid19-local-us-ca-forecasting-week-1/data)

# FILES:

<div>
{% for file in site.static_files %}
    {% if file.path contains 'covid19' %}
        
            <div>
                <a href="https://danielcaraway.github.io/{{ file.path }}">{{ file.basename }}</a>
            </div>

    {% endif %}
{% endfor %}
</div>

# REFERENCES:

[Stacked bar charts](https://pstblog.com/2016/10/04/stacked-charts)

[NCBI](https://www.ncbi.nlm.nih.gov/labs/virus/vssi/#/virus?SeqType_s=Nucleotide&VirusLineage_ss=Wuhan%20seafood%20market%20pneumonia%20virus,%20taxid:2697049)