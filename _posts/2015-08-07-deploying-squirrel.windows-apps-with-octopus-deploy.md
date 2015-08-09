---
layout: post
title: Deploying Squirrel.Windows apps with Octopus Deploy
date: 2015-08-07
tags: [devops, automation, squirrel.windows, octopus deploy]
categories: [devops]
---
[jump to tutorial](#heres-my-tutorial-on-deploying-squirrelwindows-apps-via-octopus-deploy)

A while back I was assigned the task of automating the deployment of one of our WPF applications here at TransCanada. The app was already built to use ClickOnce, but unfortunately the implementation was quite lacklustre. The process of deploying this application was to select the release environment from the Visual Studio dropdown, and build the app for the environement. This (unfortunatey) flies in the face of solid devops practices where we should be building once and deploying everywhere.

Let me start by saying automating the deployment of a desktop application is hard, like, really hard. I went down the path of deploying the ClickOnce via Octopus Deploy, and I had a relatively solid solution. Unfortunately it wasn't all that clean, and I was fighting with msbuild targets, and a few other nagging issues. ClickOnce is really designed to work best when built via MSBuild, and I don't use MSBuild during deployments, only compilation.

![Imgur](http://i.imgur.com/1ohHdkT.png)

Anyways, I let it sit for a while, and then decided to re-visit it a couple of weeks back. It was at that time that I figured "hell with it", and I ripped out ClickOnce and replaced it with [@paulcbetts](https://twitter.com/paulcbetts)'s [Squirrel.Windows](https://github.com/squirrel/squirrel.windows). In Paul's own words, squirrel is "like ClickOnce but Works". This is truely (IMO) ***the way*** to deploy desktop applications. It's still hard to integrate into the CI pipeline, but still far easier than it's ClickOnce counterpart.

Preamble
=====

Let me first say that at the time of this writing, there are a couple of gotcha's to be aware of.

 1. Nuget doesn't allow packages (.nupkg) or manifests (.nuspec) to be bundled inside another package.
 2. I haven't found a clean way to rename shortcuts based on the target environement.
 
 Also, if you're not deploying to multiple environments for Dev, QA, UAT, Production... this tutorial probably isn't for you. Simply `--releaseify` your app and push it to where it needs to go. This tutorial will show you how to get it going through the entire delivery pipeline, and allow the app to be installed multiple times (once per environment) on a single machine.
 
 Lastly, I'm using [psake](https://github.com/psake/psake) and [poshBAR](https://github.com/futurestatemobile/poshBAR) for build and deployment. A number of these commands won't be available without these modules, but you can always view the source to see what's going on.
 
Here's my tutorial on deploying Squirrel.Windows apps via Octopus Deploy
=====

Step 1: Setting up your build / deploy scripts
-----

1) Create a nuspec manifest for your application's deployment. The contents of this package is what **Octopus Deploy** will use during deployment.

 - You'll notice a couple of additional tools inside the nuspec manifest. During the deployment process we need access to `nuget.exe`, `squirrel.com`, `XmlTransform.exe`, and `OpenSSL.exe`.
 
{% gist c84f3e9e2dd7c1c4ba87 myApp.nuspec %}
 
2) Create an [environmentName].xml file. This file will contain a lot of deployment info, and is required by poshBAR

 - NOTE: it's ok to have the cert file in here as this is only a local environment, we have some magic to set your official certs in production.

{% gist c84f3e9e2dd7c1c4ba87 local.xml %}

3) Create an icon.ico, a splashscreen.gif, and a web.config that'll be bundled into the nuspec.

{% gist c84f3e9e2dd7c1c4ba87 web.config %}
 
4) Create a build script

{% gist c84f3e9e2dd7c1c4ba87 build.ps1 %}

5) Create another nuspec manifest for your squirrel deployment.

 - NOTE: this cannot have the extension `.nuspec` becuase it's being bundled into another nuget package. I've instead used `.cepsun` (this is the nuget limitation listed above.)
 - NOTE: the contents **MUST** live in the `lib\net45` directory.

{% gist c84f3e9e2dd7c1c4ba87 myApp.cepsun %}

6) Create a deploy.ps1 script for your octopus deployments

{% gist c84f3e9e2dd7c1c4ba87 deploy.ps1 %} 

Step 2: Getting Squirrel to auto-update in your application
-----

At this point, your build and deploy scripts are ready to go. Now you need to prepare your actuall application with Squirrel.

1) Install Squirrel.Windows into your application via nuget.org

    > Install-Package squirrel.windows

2) Create a simple updater class to manage your squirrel updates.

{% gist c84f3e9e2dd7c1c4ba87 SquirrelUpdater.cs %}

3) Add a couple of additional config variables to your app.config
 
 {% gist c84f3e9e2dd7c1c4ba87 app.config %}
 
4) Create transform files for your environment (app.[environmentname].config), and include the environment specific details.

 {% gist c84f3e9e2dd7c1c4ba87 app.local.config %}

5) At the appropriate time in your application, call the async method.

 - be sure to do it at a point where you're not interrupting your users experience.

    await SquirrelUpdater.Update();
	
At this point, you're finally ready to deploy. Just get your nupkg artifact into octopus deploy, and deploy it to your specific environment.
	
PS: If you'd rather just look at a demo solution, I'll be posting one shortly that encompases everything detailed above. I'll update the blog post when it's ready.

PPS: If you run into issues with these instructions, just [drop me a line](https://github.com/ChaseFlorell/chaseflorell.github.io/issues/new) and I'll be sure to point you in the right direction. I'll be sure to update this post with our findings as well.