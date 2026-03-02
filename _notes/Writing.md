---
title: Writing
category: true
---

<ul>
  {% assign notes = site.notes | sort: "last_modified_at_timestamp" | reverse %}
  {% for note in notes %}
    {% unless note.hidden == true or note.category == true %}
      {% if note.category == "writing" or note.category == nil or note.category == false %}
        <li>
          {{ note.last_modified_at | date: "%Y-%m-%d" }} — <a class="internal-link" href="{{ site.baseurl }}{{ note.url }}">{{ note.title }}</a>
        </li>
      {% endif %}
    {% endunless %}
  {% endfor %}
</ul>
