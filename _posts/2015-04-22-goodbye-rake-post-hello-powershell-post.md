---
layout: post
title: Goodbye [rake post], Hello PowerShell [post]
date: 2015-04-22 14:28:16
categories: [devops, powershell]
tags: [personal-blog, devops, jekyll]
---

Since I just got all setup with my [jekyll](http://jekyllrb.com/) on my [Github Pages](https://pages.github.com) personal blog, I was trying to figure out a quick way to generate new blog entries from the command line. I'm a huge fan of all things Microsoft (don't shot me), and therefore have made a personal decision to not install [ruby](https://www.ruby-lang.org/en/) on my personal dev machine. So, in the template for jekyll that I found, there's a nice little `rakefile` that has made it super simple to create new entries by simply calling `rake post title="Hello World"`... but alas, I don't have rake available to me (and nor do I want it).

My solution was to first ask the almighty Google if anyone had already made a powershell module for this... guess what, there is. I based my initial idea off of the [aigarsdz/create.ps1](https://gist.github.com/aigarsdz/6071059) gist, and then modified it a little. I decided to make it a module that I can drop into my `$env:USERPROFILE\Documents\WindowsPowerShell\Modules` folder. This way it can be called from anywhere, and doesn't need to be checked into the repository. Doing this also allows me to create an alias for it (read: I'm lazy).

-----

The first thing to do was add it to my "personal" modules. So inside the `Modules` directory is a folder called `Personal`, and inside that is a powershell module called `personal.psm1`. I've shortened it for clarity. All it's doing is dot-invoking the jekyll.ps1 script and exporting the modules (currently only one). From here I've modified the script referenced above.

{% gist f0bd9d0b342e2540a510 %}

Simply drop this script into your `Modules\Personal` directory, invoke it from your `personal.psm1`, and reload your shell. Now you can easily add a new post by entering the following command (with the optional `$draft` parameter).

    > post "name of my post" [-draft]
