# frozen_string_literal: true

module Jekyll
  class TagPage < Page
    def initialize(site, base, tag)
      @site = site
      @base = base
      @dir = "tags/#{Utils.slugify(tag)}"
      @name = "index.html"

      self.process(@name)
      self.read_yaml(File.join(base, '_layouts'), 'tag.html')
      self.data['tag'] = tag
      self.data['title'] = tag
      self.data['permalink'] = "/tags/#{Utils.slugify(tag)}/"
    end
  end

  class TagGenerator < Generator
    safe true

    def generate(site)
      all_tags = []
      site.collections['notes'].docs.each do |note|
        tags = note.data['tags']
        if tags
          all_tags.concat(tags)
        end
      end

      all_tags.uniq.each do |tag|
        site.pages << TagPage.new(site, site.source, tag)
      end
    end
  end
end
