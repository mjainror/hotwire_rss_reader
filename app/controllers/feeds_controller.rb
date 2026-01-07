class FeedsController < ApplicationController
  before_action :authenticate_user!

  def index
    @feeds = current_user.feeds.order(created_at: :desc)
  end

  def new
    @feed = current_user.feeds.new
  end

  def create
    @feed = current_user.feeds.new(feed_params)

    if @feed.save
      redirect_to @feed, notice: "Feed added successfully!"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @feed = current_user.feeds.find(params[:id])

    response = HTTP.get(@feed.url)
    @entries  = Feedjira.parse(response.to_s).entries
  end

  private

  def feed_params
    params.require(:feed).permit(:title, :url)
  end
end
