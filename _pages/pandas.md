--- 
layout: single
title: "Pandas"
permalink: /pandas/
---

# Pandas 
#### A semi-cheatsheet? 

## Problems Getting 

### one way to drop columns

`python
newdf = df[df.columns[2:4]]
`

### another way

`
columns = ['b', 'c']
df1 = pd.DataFrame(df, columns=columns)
`

## String Contains? And ignore NA

`df.a.str.contains("foo", na=False)`

## Most efficient way to loop!

[Most efficient way to loop pandas](https://stackoverflow.com/questions/7837722/what-is-the-most-efficient-way-to-loop-through-dataframes-with-pandas/11617194#11617194)

## Converting Column Content
```python
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