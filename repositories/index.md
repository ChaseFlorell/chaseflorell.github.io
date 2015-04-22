---
layout: page
title: "Repositories"
date: 2015-04-22 -07:00
comments: false
categories: [personal blog]
sharing: false
---

This is a list of my public repositories

<ul>
  {% for repository in site.github.public_repositories %}
    <li><a href="https://github.com/{{ repository.full_name }}">{{ repository.full_name }}</a> - {{repository.description}}</li>
  {% endfor %}
</ul>