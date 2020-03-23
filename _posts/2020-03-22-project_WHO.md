---
layout: single
title: 'PROJECT WHO'
tags: beautifulsoup ocr
---

# STEP 1:

```python
import requests
import lxml.html as lh
import pandas as pd
from bs4 import BeautifulSoup as bs

url = "https://www.who.int/emergencies/diseases/novel-coronavirus-2019/situation-reports/"

page = requests.get(url)
soup= bs(page.content, "html.parser")

content_block = soup.find(id="PageContent_C006_Col01")
content_block.findAll('a')

urls = [x['href'] for x in content_block.findAll('a') if 'docs' in x['href']]
```

# STEP 2: Convert the pdfs to csvs

## Single file conversion

```console
camelot --format csv --output ./foo.csv --pages 1-end lattice sitrep56.pdf 
```

## Multi file conversion
(we did this in ocr_corona2)

```console
for d in *; do
    if [[ $d == *.pdf ]] ; then
        echo "${d%%.*}"
        camelot --format csv --output ./${d%%.*}.csv --pages 1-end lattice $d
    fi
done
```

# STEP 3: Merge the CSVS

```python
import os
import pandas as pd
entries = os.listdir('test_csvs/')
li = []
for entry in entries:
    if '.csv' in entry:
        num = entry.split('sitrep-')[1].split('-')[0]
        date = entry.split('-')[0]
        f = pd.read_csv('csvs/'+entry, index_col=None, header=0)
        if f.shape[1] == 7:
            if 'Total' in f.columns[0]:
                f.columns = ['country', 'total_confirmed', 'total_new', 'total_deaths', 'total_new_deaths', 'transmission_class', 'days_since_report']
                f['date'] = date
                li.append(f)

frame = pd.concat(li, axis=0, ignore_index=True)
grouped = pd.DataFrame(frame.groupby(['country', 'date','total_deaths']).sum())
grouped
```

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


