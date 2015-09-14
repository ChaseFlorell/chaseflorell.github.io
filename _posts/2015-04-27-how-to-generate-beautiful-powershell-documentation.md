---
layout: post
title: How to generate beautiful PowerShell documentation
date: 2015-04-27 12:15:35
categories: [powershell]
tags: [documentation, powershell, devops]
---

I'm currently maintaining a suite of powershell modules called [poshBAR](https://github.com/FutureStateMobile/poshBAR), and there's a lot of activity going on in the library right now. The last thing I want to do is write all of the documentation for this library, and then try to remember to edit it when the API changes.

So with this, I began searching around to see if anyone has already created a documentation generator... and yes, there are a few out there. The trouble I had was two fold

 1. It needed to be beautiful to look at.
 2. It needed to be simple to invoke, with sensible command parameters.

With those two in mind, there was one script that I found that did a pretty good job overall. The [example I found](http://poshcode.org/587) was located over at poshcode. It's pretty rough around the edges, but gave me a little kickstart to get what I needed.

With a little help from [Matt](https://stackoverflow.com/users/3829407/matt) on a [StackOverflow Question](http://stackoverflow.com/q/29780709/124069) that I had, I went on to heavily refactor pretty much all of the original example. I split it into two files, a template, and the runner, and I brought in a little Bootstrappyness for beautification. Essentially, all you need to do is import your module, and kick off the script.

```
Import-Module MySpecialModule
.\psDoc.ps1 -moduleName MySpecialModule
```

If you'd like to look at (or improve) the repository, it can be found on [github under psDoc](https://github.com/chaseflorell/psdoc).


*If you've got bootstrap chops, I'd be happy to get a little help, it's one area I'm not great it, and I know it could use a little improvement.*

-----

**Screenshots**
![](https://i.imgur.com/vVIHpP8.png)
![](https://i.imgur.com/H99LOoy.png)
![](https://i.imgur.com/ZJO7Qhj.png)

**EDIT [09.14.2015]:**  
Edited to remove the old gist and instead point to the psDoc repository.
