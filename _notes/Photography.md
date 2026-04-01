---
title: Photography
category: true
---

<ul>
  {% assign notes = site.notes | sort: "date" | reverse %}
  {% for note in notes %}
    {% if note.category == "photography" %}
      <li>
        {{ note.date | date: "%Y-%m-%d" }} — <a class="internal-link" href="{{ site.baseurl }}{{ note.url }}">{{ note.title }}</a>
        {% if note.type == "gallery" %}
          <span class="type-label">gallery</span>
        {% else %}
          <span class="type-label">writing</span>
        {% endif %}
      </li>
    {% endif %}
  {% endfor %}
</ul>
