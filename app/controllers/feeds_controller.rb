class FeedsController < ApplicationController

  before_action :authenticate_user!, only: [:create, :new, :edit, :update, :destroy]
  before_action :set_feed, only: [:show, :edit, :update, :destroy]

  def index
    @feed
  end

  def create
    @feed = Feed.new(feed_params)
    if @feed.valid?
      Feed.set_attributes(@feed, current_user)
    end
    if @feed.save
      redirect_to @feed
    else
      redirect_to root_path
      flash[:alert] = "#{@feed.errors.full_messages[0]}"
    end
  end

  def show
    @user = User.find(@feed.user_id)
    @parsed = Feed.init(@feed.url)

  end

  def edit
  end

  def update
  end

  def destroy
    @feed.destroy
    redirect_to root_path
  end

  private
  def set_feed
    @feed = Feed.find(params[:id])
  end

  def feed_params
    params.require(:feed).permit(:title, :url, :description)
  end

end