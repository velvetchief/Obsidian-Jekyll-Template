---
title: Projects
category: true
---

<ul>
  {% assign notes = site.notes | sort: "date" | reverse %}
  {% for note in notes %}
    {% if note.category == "projects" or note.tags contains "projects" %}
      <li>
        {{ note.date | date: "%Y-%m-%d" }} — <a class="internal-link" href="{{ site.baseurl }}{{ note.url }}">{{ note.title }}</a>
      </li>
    {% endif %}
  {% endfor %}
</ul>
