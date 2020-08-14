---
layout: single
title: "tiktok-flask"
tags: tiktok flask python selenium
---

The "Automate TikTok Daily Data Pulls" Problem Continues.

Quick reminder --

## INSTIGATOR:

OMG TIKTOKAPI IS SO EXCITING!

## PROBLEMS:

(see 8/12 daily log for round 1 of problems)

## MORE PROBLEMS (Let's call them... obstacles so we can feel more positive)

PROBLEM:

I have a script. I want it to run daily.

SOLUTION:

Local cron jobs!

PROBLEM:

These only run when your computer is on.

SOLUTION:

Computer is usually on so this shouldn't be a problem, right?

PROBLEM:

_WRONG -- WHAT IF THE COMPUTER IS NOT ON AND WE MISS THAT CRUCIAL DAY OF DATA!?? (this is what my head is saying)_

SOLUTION:

A web browser!! Just spin up a web browser and use node cron!

SIDE NOTE: I actually got this working and felt pretty baller for a second before realizing...

PROBLEM:

The TikTokApi (the unofficial one created by a computer science student) refuses to run anywhere outside of the virtual environment I created for it in V1

SOLUTION:

Google "how to run jupyter notebook inside a virtual environment"

PROBLEM:

None of these methods seem to work...????

SOLUTION:

Peek at the TikTokApi code so you can see what's happening under the hood. Oh! We can read it! This is excellent!! Maybe I can try just running the file like he has it here!

PROBLEM:

The API relies on selenium which uses a "web driver" -- essentially something that fakes user input in a web browser.

SOLUTION:

Install selenium! Run the test code from [here](https://selenium-python.readthedocs.io/getting-started.html) (but change .Firefox() to .Chrome())

PROBLEM:

error -- 'chromedriver needs to be in path'

SOLUTION:

Download [chromedriver](https://sites.google.com/a/chromium.org/chromedriver/downloads) directly into the virtual environment bin folder [thank you, Miske for this helpful answer!](https://stackoverflow.com/a/59780334/12357926)

PROBLEM:

"This driver only supports Chrome 85"

SOLUTION:

Download the driver for the chrome we DO have, which is 84

PROBLEM:

... can any of this work on heroku!? Can Heroku even HAVE web drivers!?

SOLUTION:

[MY DUDE](https://medium.com/@mikelcbrowne/running-chromedriver-with-python-selenium-on-heroku-acc1566d161c)

I haven't tried all of this yet, but once I figure out something that Selenium actually does (something small) you can bet your booty that I will be trying it.
