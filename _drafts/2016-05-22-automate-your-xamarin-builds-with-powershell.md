---
layout: post
title: Automate your Xamarin Builds with PowerShell
date: 2016-05-22
tags: [powershell, xamarin, devops]
categories: [xamarin]
---

Working in a .NET shop with all .NET developers, I feel it prudent to build out our build and release pipeline using tools that the developers will be familiar with. With this in mind, I've set out to script our entire process using PowerShell as much as possible, and only venturing outside of PowerShell when absolutely necessary.

If you were not aware, I maintain a tool called [PoshBar](https://github.com/futurestatemobile/poshbar), and I'm going to be using that in conjunction with [psake](https://github.com/psake/psake) to be aiding in some of the more tedious tasks. If you're not familiar with paske and *tasks*, I do suggest you take a quick look.

Ok, so the first thing I need to do is build the iOS and Android apps using MSBuild.

 {% gist 107383aa5cab5d145a44c05e138b8c86 posh-short.ps1 %}

> note: MSBuild doesn't actually drop your ipa into the specified output directory, so you'll need to bring it out of your `bin/iPhone/release` folder.

<!-- -->

> note: you'll see a reference to `PlistPal.Console.exe`. That's simply a tool I wired up to help edit version numbers. I'll have that linked at the bottom of this post.

Once the app is built, then you simply package it along with all of your required deployment tools into a nupkg artifact