class Feed < ActiveRecord::Base
  belongs_to :user
  validates_with GoodnessValidator, fields: [:url]
  validates :url, uniqueness: true

  def self.init(url)
    @feed = Feedjira::Feed.fetch_and_parse(url)

  end

  def self.set_attributes(feed, current_user)
    parsed = Feedjira::Feed.fetch_and_parse(feed.url)
    parsed.title ? feed.title = parsed.title : "undefined"
    feed.user_id = current_user.id
  end

  def self.get_unique_feeds
    all = Feed.all
    urls = all.map { |feed| feed.url }
    urls.uniq!
    urls.map do |u|
      get_feed_object(u)
    end
  end

  def self.get_user_feeds(current_user)
    Feed.all.map { |feed| feed if feed.user_id == current_user.id }.compact
  end

  def self.get_feed_object(url)
    Feed.all.each do |feed|
      return feed if feed.url == url
    end
  end
end