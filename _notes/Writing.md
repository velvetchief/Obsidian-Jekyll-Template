---
title: Writing
category: true
---

<p class="topics-label">Topics</p>
<div class="topics-list">
  {% assign topic_names = "ai, building, career, education, food, hospitality, ideas, photography, recipes, startups, tools, writing" | split: ", " %}
  {% for topic in topic_names %}
    <a class="internal-link" href="{{ site.baseurl }}/tags/{{ topic }}/">{{ topic }}</a>{% unless forloop.last %},{% endunless %}
  {% endfor %}
</div>

<ul>
  {% assign notes = site.notes | sort: "last_modified_at_timestamp" | reverse %}
  {% for note in notes %}
    {% unless note.hidden == true or note.category == true %}
      <li>
        {{ note.last_modified_at | date: "%Y-%m-%d" }} — <a class="internal-link" href="{{ site.baseurl }}{{ note.url }}">{{ note.title }}</a>
      </li>
    {% endunless %}
  {% endfor %}
</ul>
