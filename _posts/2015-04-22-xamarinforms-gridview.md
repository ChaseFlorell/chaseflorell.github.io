---
layout: post
title: Xamarin.Forms GridView
date: 2015-03-14 10:53:22
categories: [xamarin, xamarin-forms]
tags: [xamarin, xamarin-forms, gridview]
---

So I've decided to take a stab at blogging. Not sure how well I'll do, but I get asked often enough for help that I figure I ought to share the knowledge as best I can.

I get asked on a semi-regular basis on how to implement a GridView on Xamarin.Forms. I've done this successfully in two projects now, and although it's not totally bindable, it'll get the job done for most use cases.  I tried using the [XLabs](https://github.com/XLabs/Xamarin-Forms-Labs) GridView, but I really had a difficult time getting it to [work properly](https://forums.xamarin.com/discussion/30612/cant-xlabs-gridview-to-update-binding).

So here it is, it's fully implemented in the PCL, so there is **no custom renderer** to deal with.

{% gist 803b7caa94b005eba749 %}

If anyone is up for adding full Binding support, I'd be more than thrilled.

--- 

here are a few examples of my last two apps using a gridview.

![Imgur](https://i.imgur.com/Qd8alh7.png) 
![Imgur](https://i.imgur.com/tCzBPc0.png) 
![Imgur](https://i.imgur.com/JFxguYL.png)