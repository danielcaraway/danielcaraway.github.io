--- 
layout: single
title: "Pandas"
permalink: /pandas/
---

# Pandas 

## A semi-cheatsheet? 

#### Subsetting specific columns (or dropping)

```python
new = old.filter(['A','B','D'], axis=1)
new = old.drop('B', axis=1)
```

#### DF to array

[source](https://stackoverflow.com/questions/13187778/convert-pandas-dataframe-to-numpy-array)

```python
df.values
```

#### Sum + Count of Column

```python
df['column']=='yes').sum()
df['column']=='yes').count()

# using .apply
all_df['tokenized_count'] = all_df.apply(lambda x: len(x['tokenized']),axis=1)
```
#### Conditional creation of column
```python
df['color'] = ['red' if x == 'Z' else 'green' for x in df['Set']]

import numpy as np
df_n['accurate'] = np.where(df_n['label'] == df_n['prediction'], 'yes', 'no')
```
[stack overflow](https://stackoverflow.com/questions/19913659/pandas-conditional-creation-of-a-series-dataframe-column)

#### Using lambdas (is this correct?)
```python
def get_tokens(sentence):
    tokens = word_tokenize(sentence)
    clean_tokens = [word.lower() for word in tokens if word.isalpha()]
    return clean_tokens

all_df['tokenized'] = all_df.apply(lambda x: get_tokens(x[0]),axis=1)
all_df['tokenized_count'] = all_df.apply(lambda x: len(x['tokenized']),axis=1)
```