---
layout: single
title: 'Getting Text from Images with Python'
---

# Adventures with OCR!

1. Download the goods

``` console
brew install tesseract
```

2. Create and activate virtual environment


```console
python3 -m venv ocr-env
source ocr-virt/bin/activate
```

3. Pip install `pytesseract` (which should also download PIL -- Python Image Library)

```console
pip install pytesseract
```

RUN TEST:

``` python
try:
    from PIL import Image
except ImportError:
    import Image
import pytesseract

print(pytesseract.image_to_string(Image.open('crime.jpg')))
```
