---
layout: single
title: 'What did I do on June 21, 2019?'
tags: browserjournal
--- 

# Step 1: Get the data from takeout.google.com

# Step 2: Little bit o coding


```python
# get the data
import pandas as pd
bh = pd.read_json('Takeout/Chrome/BrowserHistory.json')
df = pd.DataFrame(list(bh['Browser History']))

# convert the time
from pytz import timezone
western = timezone('US/Pacific')
from datetime import datetime, timedelta, timezone
def get_timestamp(ts):
    epoch = datetime(1970, 1, 1, tzinfo=timezone.utc)
    epoch = epoch.astimezone(western)
    cookie_microseconds_since_epoch = ts
    cookie_datetime = epoch + timedelta(microseconds=cookie_microseconds_since_epoch)
    return(str(cookie_datetime))

def get_times(usec):
    ts = get_timestamp(usec)
    date = ts.split(' ')[0]
    dmy = date.split('-')
    time = ts.split(' ')[1]
    hms = time.split('.')[0].split(':')

    return {
        "date": date, 
        "dmy": dmy, 
        "year": int(dmy[0]), 
        "month": int(dmy[1]), 
        "day": int(dmy[2]), 
        "hms": hms, 
        "hour": int(hms[0]), 
        "min": int(hms[1]), 
        "sec": int(hms[2]) }

appiled_df = df.apply(lambda row: get_times(row.time_usec), axis='columns', result_type='expand')
df = pd.concat([df, appiled_df], axis='columns')

# get the date
june_21 = df[(df['month'] == 6) & (df['day'] == 21)]

# look at the urls visited on that date 
for index, row in june_21.iterrows():
    print(row['url'])

```

also posted on my medium [here](https://medium.com/@yesthisiskendra/using-your-browser-history-as-a-journal-525bd660eb67)