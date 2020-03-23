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

