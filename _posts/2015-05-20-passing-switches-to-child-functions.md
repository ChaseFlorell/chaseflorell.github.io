---
layout: post
title: Passing Switches to Child Functions
date: 2015-05-20 10:10:51
categories: [powershell]
tags: [powershell]
---

Just a quick post to demonstrate how to pass switches to child functions in PowerShell. 

If you're using `[CmdletBinding()]` in your functions, you've enabled additional switches and parameters on your function with almost no effort. These switches include `-verbose` and `-debug` as well as [a few others](http://windowsitpro.com/blog/what-does-powershells-cmdletbinding-do), and because of the way `[CmdletBinding()]` works, you don't need to pass those switchs on down to child functions. You do however need to pass custom switches.

In the example below, I simply demonstrate how switchs work when passing them to sub functions. 

{% gist 4ced2f4638c626fd32e6 %}

As you can see, the `$test` switch is passed down by calling `-test:$test`, and the rest of the switches are magically passed for you. That's all there is to it.