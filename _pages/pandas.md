---
layout: single
title: "Pandas"
permalink: /pandas/
---

# Pandas: An on-the-go "cheat sheet"

# ==================================

## PRO TIP: do a ctrl f first

# ==================================

## ADD A COLUMN FROM A GROUPBY

WHAT IS THIS MAGIC!?
[SO](https://stackoverflow.com/questions/12200693/python-pandas-how-to-assign-groupby-operation-results-back-to-columns-in-parent)
[SPECIFICALLY THIS](https://stackoverflow.com/a/39029294/12357926)

```python
bdata['group_MarketCap'] = bdata.groupby('yearmonth')['MarketCap'].transform('sum')
```

## Select rows whos columns are

```python
df.loc[df['column_name'].isin(some_values)]
```

## Rename column

```python
df=df.rename(columns = {'two':'new_name'})
```

add color to seaborn

```python
palette
```

## Creating multiple columns from an apply

[so](https://stackoverflow.com/questions/16236684/apply-pandas-function-to-column-to-create-multiple-new-columns)

```python
appiled_df = df.apply(lambda row: get_times(row.time_usec), axis='columns', result_type='expand')
df = pd.concat([df, appiled_df], axis='columns')
```

## MERGING

```python
## WHAT THE DOCS SAID
df1.merge(df2, left_on='ds')

## WHAT STACKOVERFLOW SAID (and what worked)
df_merged = pd.merge(df1, df2, how='left', on='ds', suffixes=('_v1', '_v2'))
```

## UNIQUE

Numpy unique

```
>>> a = numpy.array([0, 3, 0, 1, 0, 1, 2, 1, 0, 0, 0, 0, 1, 3, 4])
>>> unique, counts = numpy.unique(a, return_counts=True)
>>> dict(zip(unique, counts))
{0: 7, 1: 4, 2: 1, 3: 2, 4: 1}
Non-numpy way:

Use collections.Counter;

>> import collections, numpy

>>> a = numpy.array([0, 3, 0, 1, 0, 1, 2, 1, 0, 0, 0, 0, 1, 3, 4])
>>> collections.Counter(a)
Counter({0: 7, 1: 4, 3: 2, 2: 1, 4: 1})
```

Percentage missing

```python
df_na = pd.DataFrame(df.isna().sum())
df_na['percent'] = (df_na[0] / df.shape[0]) *100
df_na.sort_values(by="percent", ascending = False)
```

last column to first column

`python cols = list(df.columns) cols = [cols[-1]] + cols[:-1] df = df[cols] df`

`python df1 = df[(df.a != -1) & (df.b != -1)]`

`python deals = weights['! ;) :) half off free crazy deal only $ 80 %'.split()].round(3) * 100 ['! ;) :) half off free crazy deal only $ 80 %'.split()]`

## renaming columns

`python data.rename(columns={'gdp':'log(gdp)'}, inplace=True)`

## merging

`python new_df = pd.merge(A_df, B_df, how='left', left_on=['A_c1','c2'], right_on = ['B_c1','c2'])`

### one way to drop columns

`python newdf = df[df.columns[2:4]]`

### another way

`columns = ['b', 'c'] df1 = pd.DataFrame(df, columns=columns)`

## String Contains? And ignore NA

`df.a.str.contains("foo", na=False)`

## Most efficient way to loop!

[Most efficient way to loop pandas](https://stackoverflow.com/questions/7837722/what-is-the-most-efficient-way-to-loop-through-dataframes-with-pandas/11617194#11617194)

## Converting Column Content

```python

df['color'] = ['red' if x == 'Z' else 'green' for x in df['Set']]
# w.female[w.female == 'female'] = 1
# w.female[w.female == 'male']   = 0

df['Status'][df['Status'] == 'ham'] = 1
df['Status'][df['Status'] == 'spam'] = 0
```

## Replacing non-zeros with ones

```
df.astype(bool).astype(int)
```

## Select columns of groupby by sum

`df.groupby(['Country', 'Item_Code'])[["Y1961", "Y1962", "Y1963"]].sum()`

[SO](https://stackoverflow.com/a/32751412)

#### Problems importing CSV?

Dropping on a conditional

To remove all rows where column 'score' is < 50:

```python
df = df.drop(df[df.score < 50].index)
```

[SO](https://stackoverflow.com/questions/13851535/delete-rows-from-a-pandas-dataframe-based-on-a-conditional-expression-involving)

Had to change delimiter to

```python
dirtyFile = pd.read_csv('dirtyfile.csv',  sep='\t')
```

[see here](https://stackoverflow.com/questions/18039057/python-pandas-error-tokenizing-data)

#### Resetting index

```python
    all_df.reset_index(drop=True,inplace = True)
```

#### Conditionals

```python
conditional_df = all_df[all_df['colname'] == 'val_i_need']
```

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

getting bag of words from column?

```python
def get_bow_from_column(df, column):
    all_column_data = ' '.join(df[column].tolist())
    all_column_fd = Counter(all_column_data.split())
    return all_column_fd

# pos_bow = get_bow_from_column(all_df, 'pos_dict')
```

Tuples to DF

```python
# data in the form of list of tuples
data = [('Peter', 18, 7),
        ('Riff', 15, 6),
        ('John', 17, 8),
        ('Michel', 18, 7),
        ('Sheli', 17, 5) ]


# create DataFrame using data
df = pd.DataFrame.from_records(data, columns =['Team', 'Age', 'Score'])

print(df)
```
