#!/usr/bin/env python
# coding: utf-8

# # Recommender

# In[2]:


import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns
sns.set_style('white')


# In[3]:


df = pd.read_csv('u.data', sep="\t")
columns = ['userid', 'item_id', 'rating', 'timestamp']
df.columns = columns


# In[4]:


movietitles = pd.read_csv('Movie_Id_Titles')


# In[5]:


df = pd.merge(df, movietitles, on='item_id')


# ## Make a "ratings" df

# In[6]:


df.groupby('title')['rating'].mean()


# In[7]:


ratings = pd.DataFrame(df.groupby('title')['rating'].mean())


# In[8]:


ratings['number_of_ratings'] = df.groupby('title')['rating'].count()


# In[10]:


sns.jointplot(x="rating", y="number_of_ratings", data=ratings, alpha=0.5)


# # Recommending Similar Movies

# In[13]:


movie_matrix = df.pivot_table(index="userid", columns="title", values="rating")
movie_matrix


# # Sort the ratings

# In[14]:


ratings.sort_values('number_of_ratings', ascending=False).head(10)


# In[15]:


starwars_user_ratings = movie_matrix['Star Wars (1977)']


# In[16]:


liarliar_user_ratings = movie_matrix['Liar Liar (1997)']


# ## corrwith()

# In[17]:


movie_matrix.corrwith(starwars_user_ratings)


# In[20]:


similar_to_starwars = movie_matrix.corrwith(starwars_user_ratings)


# In[21]:


corr_starwars = pd.DataFrame(similar_to_starwars, columns=['Correlation'])
corr_starwars.dropna(inplace=True)


# In[22]:


corr_starwars.head()


# # Remove movies with less than 100 reviews

# In[23]:


corr_starwars = corr_starwars.join(ratings['number_of_ratings'])


# In[24]:


corr_starwars


# # ===== 2-03-21 Starting Over

# In[2]:


import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns
sns.set_style('white')


# In[15]:


# 1. Read in the data, change separator to tab
# 2. Create an array of new column names
# 3. Assign that array to our columns

df = pd.read_csv('u.data', sep="\t")
columns = ['user_id', 'item_id', 'rating', 'timestamp']
df.columns = columns


# In[16]:


df.head()


# ## OH NO! How do we know what movies these are, just by the id!?

# In[17]:


# 1. Read in the item_id to movie_title df
# 2. Merge 
movietitles = pd.read_csv('Movie_Id_Titles')
df = pd.merge(df, movietitles, on="item_id")


# ## Ok, how do we get JUST the ratings?

# In[20]:


ratings = pd.DataFrame(df.groupby('title')['rating'].mean())
ratings.head()


# ## Ok, but, this is almost useless if only one person has rated the movie, right?

# ## So, we should also get number of ratings, for posterity

# In[22]:


ratings['number_of_ratings'] = df.groupby('title')['rating'].count()


# In[24]:


ratings.head()


# # PART TWO: Now we are on to recommending similar movies

# In[29]:


# 1. Make a matrix (like an excel pivot table)


# In[28]:


movie_matrix = df.pivot_table(index="user_id", columns="title", values="rating")
movie_matrix.head()


# In[30]:


# 2. Pick our movies
# 3. Get the ratings for only those movies 
starwars_ratings = movie_matrix['Star Wars (1977)']
liarliar_ratings = movie_matrix['Liar Liar (1997)']


# In[33]:


similar_to_starwars = movie_matrix.corrwith(starwars_ratings)


# In[36]:


corr_with_starwars = pd.DataFrame(similar_to_starwars, columns=['correlation'])
corr_with_starwars


# In[40]:


sw_df = corr_with_starwars.join(ratings['number_of_ratings'])


# In[42]:


sw_df = sw_df[sw_df['number_of_ratings'] >= 100 ]


# In[44]:


sw_df = sw_df.sort_values('correlation', ascending=False)


# In[45]:


sw_df


# ## Now, we're going to do the same thing with Liar Liar
# 
# 1. get all Liar Liar movies
# 2. Get correlation
# 3. Get number of ratings
# 4. 

# In[46]:


df


# In[47]:


liar_liar = df[df['title'] == 'Liar Liar (1997)']
liar_liar


# In[48]:


df_matrix = df.pivot_table(index="user_id", columns="title", values="rating")
df_matrix


# In[49]:


df_m_sw = df_matrix['Star Wars (1977)']


# In[53]:


df_m_sw_corr = df_matrix.corrwith(df_m_sw)


# In[55]:


df_m_sw_corr = pd.DataFrame(df_m_sw_corr, columns=['correlation'])
df_m_sw_corr


# In[58]:


df_m_sw_corr_with_ratings = df_m_sw_corr.join(ratings)


# In[59]:


df_m_sw_corr_with_ratings


# In[60]:


df_m_sw_corr_with_ratings = df_m_sw_corr_with_ratings[df_m_sw_corr_with_ratings['number_of_ratings'] >= 100]


# In[61]:


df_m_sw_corr_with_ratings.sort_values('correlation',ascending=False)


# ## NOW with Liar Liar

# In[81]:


# 1. Make a matrix 
df_matrix = df.pivot_table(index="user_id", columns="title", values="rating")
# 2. Get JUST Liar Liar  
df_matrix_ll = df_matrix['Liar Liar (1997)']
# 3. Compare everything in the matrix to Liar Liar column
df_matrix_ll_corr = df_matrix.corrwith(df_matrix_ll)
# 4. Turn that into a df so we can add things like 'ratings'
df_matrix_ll_corr_df = pd.DataFrame(df_matrix_ll_corr, columns=['correlation'])
# 5. Using a join (because our index -- title -- is the same for both dfs, add ratings)
df_matrix_ll_corr_df_with_ratings = df_matrix_ll_corr_df.join(ratings)
# 6. Remove anything with number of ratings < 100
df_matrix_ll_corr_df_with_ratings = df_matrix_ll_corr_df_with_ratings[df_matrix_ll_corr_df_with_ratings
                                                                      ['number_of_ratings'] >= 100]
# 7. Sort
df_matrix_ll_corr_df_with_ratings_sorted = df_matrix_ll_corr_df_with_ratings.sort_values('correlation', 
                                                                                         ascending=False)


# In[82]:


df_matrix_ll_corr_df_with_ratings_sorted


# In[78]:


# IN SHORT
dfm = df.pivot_table(index="user_id", columns="title", values="rating")
ll = dfm['Liar Liar (1997)']
dfm_ll = pd.DataFrame(dfm.corrwith(ll), columns=['correlation'])
dfm_ll = dfm_ll.join(ratings)
dfm_ll = dfm_ll[dfm_ll['number_of_ratings'] >= 100].sort_values('correlation', ascending=False)
dfm_ll


# In[ ]:




