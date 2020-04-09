#!/usr/bin/env python
# coding: utf-8

# # COVID19 KAGGLE WK3 QUICK EDA

# In[3]:


import pandas as pd
import numpy as np

## GLOBAL WK3
train_file = "https://raw.githubusercontent.com/danielcaraway/COVID19/master/WK3_0407/train.csv"
test_file = "https://raw.githubusercontent.com/danielcaraway/COVID19/master/WK3_0407/test.csv"
sub_file = "https://raw.githubusercontent.com/danielcaraway/COVID19/master/WK3_0407/submission.csv"

train = pd.read_csv(train_file)
test = pd.read_csv(test_file)
sub = pd.read_csv(sub_file)

## Using Country for Province_State when entry doesn't have Province_State
def use_country(state, country):
    if pd.isna(state):
        return country
    else:
        return state

train['Province_State'] = train.apply(lambda x: use_country(x['Province_State'], x['Country_Region']), axis=1)
test['Province_State'] = test.apply(lambda x: use_country(x['Province_State'], x['Country_Region']), axis=1)

## Converting Date column to a datetime type
train['Date'] = pd.to_datetime(train['Date'])
test['Date'] = pd.to_datetime(test['Date'])


# ## Quick look at California

# In[21]:


import matplotlib.pyplot as plt
import seaborn as sns; sns.set()

ca = train[train['Province_State'] == 'California']
df = ca.copy()
graph_df = df[['Date', 'ConfirmedCases', 'Fatalities']]
data = pd.melt(graph_df, id_vars=['Date'], value_vars=['ConfirmedCases','Fatalities'])
data.head()
ax = sns.lineplot(x="Date", y="value",
                  hue="variable", style="variable", data=data)


# #### The first few days aren't super helpful, let's ditch those with < 0 

# ## Removing Entries where ConfirmedCase < 0 

# In[22]:


train = train[train['ConfirmedCases'] > 0]


# In[23]:


def quick_graph(column, location):
    df = train[train[column] == location]
    graph_df = df[['Date', 'ConfirmedCases', 'Fatalities']]
    data = pd.melt(graph_df, id_vars=['Date'], value_vars=['ConfirmedCases','Fatalities'])
    data.head()
    ax = sns.lineplot(x="Date", y="value",
                      hue="variable", style="variable", data=data)
    plt.title(location)


# In[24]:


quick_graph('Country_Region','Italy')


# In[25]:


quick_graph('Country_Region','US')


# In[26]:


quick_graph('Country_Region','Spain')


# In[ ]:





# In[ ]:





# In[ ]:




