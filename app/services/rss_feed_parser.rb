require "ostruct"

class RssFeedParser
  attr_accessor :response, :response_entries

  def initialize(feed)
    @feed = feed
    
    res = HTTP.get(@feed.url)
    @response = Feedjira.parse(res.to_s)
    @response_entries  = @response.entries
  end

  def entries
    @response_entries.map do |entry|
      OpenStruct.new(
        feed_name: @feed.title,
        feed_image: @feed.image_url,
        feed_url: @feed.url,
        feed_title: @response.title,
        feed_description: @response.description,
        feed_image_url: (@response.image rescue nil)&.url,
        author: entry.author,
        categories: entry.categories,
        entry_id: entry.entry_id,
        published: entry.published,
        summary: entry.summary,
        title: entry.title,
        url: entry.url
      )
    end
  end
end
