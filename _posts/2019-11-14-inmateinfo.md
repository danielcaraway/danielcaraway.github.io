---
layout: single
title: 'Get Inmate Info'
---

## How to get inmate info from a photo of a written document?

```python
import requests
import pandas as pd
from io import BytesIO
try:
    from PIL import Image
except ImportError:
    import Image
import pytesseract

df = pd.read_csv('V1_with_statements.csv')
jpgs = df[df['Offender Information'].str.contains('.jpg', na=False)]

def get_img(img_url):
    return requests.get(img_url)

def write_txt(my_image, txt_file):
    file = open(txt_file, "w")
    text_from_image = pytesseract.image_to_string(Image.open(BytesIO(my_image.content)))
    file.write(text_from_image)
    file.close()
    return text_from_image

def get_photo_data(url, id_num, fn, ln):
    try:
        filename = 'img_text_'+str(id_num)+ '_' + fn + '_' + ln + '.txt'
        my_image = get_img('https://www.tdcj.texas.gov/death_row/'+ url)
        text_from_image = write_txt(my_image, filename)
        print(url, filename)
        return text_from_image
    except:
        return "couldn't get image text"

new_df = jpgs.copy()
new_df['Photo Info'] = jpgs.apply(lambda x: get_photo_data(x['Offender Information'], x['TDCJNumber'], x['First Name'], x['Last Name']), axis=1)    
new_df.to_csv('V3_with_photo_data.csv')

```