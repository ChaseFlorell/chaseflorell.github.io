---
layout: page
title: "Contributors"
date: 2015-04-22 -0700
comments: false
categories: [personal blog]
sharing: false
---

## Contributors

This blog was originally forked from the [drvy/minimal-block](https://github.com/drvy/minimal-block) theme.

The lovely people listed here have contributed directly to my blog. If you want to see yourself in this list, send me a pull request!

Every post in my blog has an edit link that lets you edit the blog post directly in the browser and automatically sends me a pull request.

Or [visit my repository]({{site.github.repository_url}}) and send me a pull
request the old fashioned way.

<ul>
{% for contributor in site.github.contributors %}
  <li>
    <img src="{{ contributor.avatar_url }}" width="32" height="32" /> <a href="{{ contributor.html_url }}">{{ contributor.login }}</a>
  </li>
{% endfor %}
</ul>

<sup>*this page was 'borrowed' from [Phil Haack](http://haacked.com)*</sup>
