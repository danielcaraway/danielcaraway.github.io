--- 
layout: single
title: "How to get historical NCAA data"
tags: howto
---

I just want a simple historical record of wins and losses. 
Kaggle isn't helpful.
Google isn't helpful.
Reddit isn't helpful. 


Or, maybe I'm just really bad at googling? Maybe I simply do not understand enough about college football to understand what I should be asking the internet in order to get what I need from the internet.

TL;DR: I did a lot of scraping today.

THE GOOD NEWS: After some serious hunting, I found stats.ncaa.org

THE BAD NEWS: The urls are intentionally de-coupled from school names (to dissuade scraping, one presumes)

THE GOOD NEWS: After SERIOUS digging on stats.ncaa.org I found a page that listed the schools with links to a more serious "school" page that contained what I can only assume is the internal ncaa reference number that is used in the urls for historical data

THE BAD NEWS: One cannot simply copy and paste these urls

THE GOOD NEWS: One CAN copy the data, including the links, into excel

THE BAD NEWS: The links don't show up as hyperlinks so I cannot get the hidden number from the URL like I hoped

THE GOOD NEWS: I can write a quick VBA script to make a function called GetURL and create a new column with this naked URL and export the csv and then split on the backslashes etc to get this very sacred number

THE BAD NEWS: Upon testing my urls with my new sacred numbers, I get a 403 error -- the url is It is protected by a redirect (to dissuade scraping again, one presumes)

THE GOOD NEWS: Python requests handles redirects

THE BAD NEWS: Even with the requests package, still getting a 403 error, even though I can clearly access it via my browser

THE GOOD NEWS: I can fake my headers and pretend to be a browser trying to access the page

THE BAD NEWS: There are many tables with a ton of different headings and information

THE GOOD NEWS: I discovered that I can use requests + pd.read_html and skip beautiful soup entirely to turn tabular data into data frames!!

THE BAD NEWS: This takes a long time and I haven't thought of a "natural" way to display the data -- what happens when I want to get the offensive points of LSU? How can I add just offensive points to my table? 

THE GOOD NEWS: I didn't have a beer tonight so I could be sharp and focus all my energies on this 

THE BAD NEWS: It is still running...

THE GOOD NEWS: I've also found Championship data

THE BAD NEWS: I still haven't spent any quality time thinking of how I might solve for missing values, which is arguably far more important than this endless quest for more data

THE GOOD NEWS: I will eventually use these URLS to get more historical data as well... which more people might not have...

THE BAD NEWS: It is my turn to clean the cat litter




