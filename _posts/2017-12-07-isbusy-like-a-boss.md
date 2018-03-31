---
layout: post
title: IsBusy like a Boss
date: 2017-12-07 13:35:22
categories: [xamarin]
tags: [xamarin, xamarin-forms, C#]
---

A while back I ran into a strange scenario where async tasks were causing unexpected results when setting `IsBusy`. The situation was pretty straight forward, I had multiple Commands running at the same time, setting `IsBusy = true` when it starts and `IsBusy = false` when it finished.

{% gist 95b8429d2d572b300c33cfdb69d4ffcd IsBusy_Bad.cs %}

The problem with this is that if you fire both commands at the same time, The first command will set IsBusy back to false while the second command is still running. This would cause my `ActivityIndicator` to be removed from view while the second task was still running.

You can also run into issues where if you set `IsBusy = [true|false]` around async methods that can crash, your IsBusy indicator can get stuck forever

{% gist 95b8429d2d572b300c33cfdb69d4ffcd IsBusy_StuckForever.cs %}

As I was thinking through the problem, I remembered back to my days of working at a sawmill, and the lockout system that we'd use to maintain equipment. Whenever a person needs to go and fix/clean dangerous equipment, they'd turn off the master breaker and put a lock on it. If a second/third/fifth person also needed to work on the same equipment, they'd each add their own lock to the breaker, and as they leave, they'd remove their own lock. The last person to leave would remove their lock and turn the equipment back on, knowing with certainty that no one was left inside.

![Imgur](https://i.imgur.com/IFUT1Vs.jpg)

With this in mind I set off to build a lockout system for my `IsBusy` boolean. You can still directly set `IsBusy = [true|false]`, but better than that, you can use the disposbable `Busy()` method to track multiple calls and lockouts.

{% gist 95b8429d2d572b300c33cfdb69d4ffcd IsBusy_LikeABoss.cs %}

and here's a really simple example of how you'd use it.

{% gist 95b8429d2d572b300c33cfdb69d4ffcd IsBusy_SimpleExample.cs %}

I've also written a few tests to demonstrate more in depth what it might look like.

{% gist 95b8429d2d572b300c33cfdb69d4ffcd IsBusy_Tests.cs %}

So if you're struggling with your `ActivityIndicator` getting stuck on or disappearing when it shouldn't, try the busy lock system and see if it improves.