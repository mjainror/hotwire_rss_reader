class FeedsController < ApplicationController
  before_action :authenticate_user!

  def index
    @feeds = current_user.feeds.order(created_at: :desc)

    @entries = @feeds.first(3).flat_map do |feed|
      entries  = RssFeedParser.new(feed).entries
      
      entries if entries.present?
    end.compact
    
    @entries.sort_by! { |entry| -entry.published.to_i }
  end

  def new
    @feed = current_user.feeds.new
  end

  def create
    @feed = current_user.feeds.new(feed_params)

    if @feed.save
      response = HTTP.get(@feed.url)
      parsed_data  = Feedjira.parse(response.to_s)
      if (parsed_data.image rescue nil).present?
        @feed.update(image_url: parsed_data.image.url)
      end

      redirect_to @feed, notice: "Feed added successfully!"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @feeds = current_user.feeds.order(created_at: :desc)
    @feed = current_user.feeds.find(params[:id])
    
    @entries = RssFeedParser.new(@feed).entries
  end

  private

  def feed_params
    params.require(:feed).permit(:title, :url)
  end
end
