#!/usr/bin/env python
# coding: utf-8

# In[2]:


import os, shutil, magic


# # STEP 1: Rename all files
# # STEP 2: Once renamed, sort into respective folders

# ### (A) First, create dictionary of all extensions in folder tree

# In[ ]:


import os, shutil, magic

# =============================
# USING DIY EXTENSION-GETTING
# =============================

# directory_in_str = '/Volumes/EHD_5/____play_all/'

# count = 0
# diy_ext = {}
# for subdir, dirs, files in os.walk(directory_in_str):
#     for file in files:
#         count += 1
#         ext = file.split('.')[-1]
#         if ext in diy_ext:
#             diy_ext[ext] += 1
#         else:
#             diy_ext[ext] = 1

# print(count)         

# =============================
# USING FILE MAGIC
# =============================

directory_in_str = '/Volumes/EHD_5/____play_all/'

count = 0
diy_ext = {}
for subdir, dirs, files in os.walk(directory_in_str):
    for file in files:
        filepath = subdir + os.sep + file
        count += 1
        try:
            ext = magic.from_file(filepath, mime=True)
            if ext in diy_ext:
                diy_ext[ext] += 1
            else:
                diy_ext[ext] = 1
        except:
            print('no magic', file)

print('dict length', len(diy_ext))            
print(count)     


# ### (B) Import already "labeled" filetypes

# In[ ]:


import pandas as pd

# =============================
# DIY EXTENSION-GETTING LABELS
# =============================
ext = pd.read_csv('EHD_labeled_extensions_and_filetypes.csv')
ext_dict = dict(zip(ext['0'], ext['1']))
ext_dict

# =============================
# FILE MAGIC LABELS
# =============================
magic_ext = pd.read_csv('EHD_magic_labeled_extensions_and_filetypes.csv')
magic_dict = dict(zip(magic_ext['0'], magic_ext['1']))


# ### (C) Compare that extension dictionary with the one we have already labeled

# In[ ]:


new_dict = {}
for (k,v) in diy_ext.items():
    if k not in magic_dict:
        new_dict[k] = v
        print(k,v)


# ### (D) Update the filetypes we don't already have, with shorthand

# In[ ]:


additional_filetypes = {}        
for (k,v) in new_dict.items():
    print(k, v)
    new_val=input('parent')
    additional_filetypes[k] = new_val


# ### (E) Convert the shorthand

# In[ ]:


new_dict = additional_filetypes
for (k,v) in new_dict.items():
    if v == 'doc' or v == 'docs' or v == 'dof':
        new_dict[k] = '_____DOCUMENTS'
    if v == 'dev':
        new_dict[k] = '_____DEVELOPER'
    if v == 'no' or v == 'unknown' or v == 'app':
        new_dict[k] = '_____OTHER_UNKNOWN'
    if v == 'zip':
        new_dict[k] = '_____ZIP'
    if v == 'image' or v == 'photos' or v == 'photo':
        new_dict[k] = '_____PHOTOS'
    if v == 'media':
        new_dict[k] = '_____MEDIA'
    if v == 'photoshop':
        new_dict[k] = '_____PHOTOSHOP'

new_dict   


# ### (F) Merge the original labeled dictionary with the newly labeled dictionary

# In[ ]:


def merge_two_dicts(x, y):
    z = x.copy()   # start with x's keys and values
    z.update(y)    # modifies z with y's keys and values & returns None
    return z

mega_dict = merge_two_dicts(magic_dict, new_dict)
len(mega_dict)


# In[5]:


# JUST FOR play_all
import pandas as pd
magic_ext = pd.read_csv('EHD_magic_labeled_extensions_and_filetypes_v2.csv')
mega_dict = dict(zip(magic_ext['0'], magic_ext['1']))
mega_dict


# In[1]:


directory_in_str = '/Volumes/EHD_5/____play_all/'
destination = '/Volumes/EHD_5/'

for subdir, dirs, files in os.walk(directory_in_str):
    for file in files:
        filepath = subdir + os.sep + file
        try:
            file_extension = magic.from_file(filepath, mime=True)
            if file_extension in mega_dict:
                parent = mega_dict[file_extension]
                newpath = destination + parent + '/' + file
#                 print(newpath)
                shutil.move(filepath, newpath)
            else:
                print(file_extension)
        except:
            print('-------------------', file)


# In[9]:


directory_in_str = '/Volumes/EHD_5/____play_all/'
destination = '/Volumes/EHD_5/'

for subdir, dirs, files in os.walk(directory_in_str):
    for file in files:
        filepath = subdir + os.sep + file
        try:
            file_extension = magic.from_file(filepath, mime=True)
            if file_extension in mega_dict:
                parent = mega_dict[file_extension]
                newpath = destination + parent + '/' + file
#                 print(newpath)
                shutil.move(filepath, newpath)
            else:
                print(file_extension)
        except:
            print('-------------------', file)


# In[ ]:




