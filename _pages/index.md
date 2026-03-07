---
layout: page
title: Home
id: home
permalink: /
---

{% assign about = site.notes | where: "title", "About Me" | first %}
{{ about.content }}
