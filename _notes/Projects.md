---
title: Projects
category: true
---
{% assign notes = site.notes | sort: "last_modified_at_timestamp" | reverse %} {% for note in notes %} {% if note.category == "projects" %}- {{ note.last_modified_at | date: "%Y-%m-%d" }} — [{{ note.title }}](app://obsidian.md/%7B%7B%20site.baseurl%20%7D%7D%7B%7B%20note.url%20%7D%7D)
{% endif %} {% endfor %}