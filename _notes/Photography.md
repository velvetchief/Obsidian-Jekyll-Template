---
title: Photography
category: true
---

<ul>
  {% assign notes = site.notes | sort: "last_modified_at_timestamp" | reverse %}
  {% for note in notes %}
    {% if note.category == "photography" %}
      <li>
        {{ note.last_modified_at | date: "%Y-%m-%d" }} — <a class="internal-link" href="{{ site.baseurl }}{{ note.url }}">{{ note.title }}</a>
      </li>
    {% endif %}
  {% endfor %}
</ul>
