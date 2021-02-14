#!/usr/bin/env python
# coding: utf-8

# # PORTFOLIO_SCRAPING_EHD_RENAME_AND_MOVE

# In[19]:


ehd = 'EHD_7'
file_to_flatten = '__2017mac'
directory_in_str = '/Volumes/{}/{}/'.format(ehd, file_to_flatten)
destination = '/Volumes/{}/{}/{}_ALL/'.format(ehd, file_to_flatten, file_to_flatten)

print(directory_in_str, destination)


# In[18]:


# # BEFORE
# directory_in_str = '/Volumes/EHD_7/__pre2011/'
# destination = '/Volumes/EHD_7/__pre2011/__pre2011_ALL/'


# In[14]:


import os, time, shutil

ehd = 'EHD_7'
file_to_flatten = '__2017mac'
directory_in_str = '/Volumes/{}/{}/'.format(ehd, file_to_flatten)
destination = '/Volumes/{}/{}/{}_ALL/'.format(ehd, file_to_flatten, file_to_flatten)

for subdir, dirs, files in os.walk(directory_in_str):
    for file in files:
        filepath = subdir + os.sep + file
        
        time_stamp = ''

        try:
            stat = os.stat(filepath)
            time_stamp = time.strftime('%Y-%m-%d', time.localtime(stat.st_birthtime))
        except:
            print('----',stat.st_mtime)
        
        newfilename = time_stamp + '_' + filepath.split(directory_in_str)[1].replace('/', '__')
        newpath = destination + newfilename
        
        try:
            shutil.move(filepath, newpath)
#             print(filepath, newpath)
        except:
            print('error')


# In[16]:


print(directory_in_str)
for subdir, dirs, files in os.walk(directory_in_str):
    for file in files:
        print(file)


# In[ ]:




