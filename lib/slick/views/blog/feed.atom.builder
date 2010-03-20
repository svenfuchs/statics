atom_feed do |feed|
  feed.title(page_title)
  feed.updated(section.contents.first.published_at)
 
  section.contents[0, 25].each do |post|
    feed.entry(post, :url => url(post), :id => url(post)) do |entry|
      entry.title(post.title)
      entry.content(post.body, :type => 'html')
      entry.updated(post.published_at.to_time.xmlschema)
      entry.published(post.published_at.to_time.xmlschema)
      entry.author do |author|
         author.name(config[:author])
      end
    end
  end
end