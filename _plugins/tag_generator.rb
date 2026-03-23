module Jekyll
  class TagPageGenerator < Generator
    safe true

    def generate(site)
      all_items = site.posts.docs.dup
      site.collections.each do |name, collection|
        next if name == 'posts'
        all_items += collection.docs
      end

      tags = all_items.flat_map { |item| item.data['tags'] || [] }.uniq

      tags.each do |tag|
        site.pages << TagPage.new(site, site.source, tag)
      end
    end
  end

  class TagPage < Page
    def initialize(site, base, tag)
      @site = site
      @base = base
      @dir  = File.join('tags', Jekyll::Utils.slugify(tag))
      @name = 'index.html'

      self.process(@name)
      self.data                  = {}
      self.data['layout'] = 'tag'
      self.data['tag']    = tag
      self.data['title']  = "Tag: #{tag}"
    end
  end
end
