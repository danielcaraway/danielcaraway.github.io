---
layout: single
title: 'Getting Texts from Screenshots with Python'
---

1. Download photos with text
2. Run this script (replace `AmazonPhotos` with your own folder name)

```python
try:
    from PIL import Image
except ImportError:
    import Image
import pytesseract

import os
filelist=os.listdir('AmazonPhotos')

for file in filelist[:]:
    filename = str(file).split('.')[0]+'.txt'
    my_image = 'AmazonPhotos/'+file
    file = open(filename, "w")
    text_from_image = pytesseract.image_to_string(Image.open(my_image))
    file.write(text_from_image)
    file.close()
    print(file)
```