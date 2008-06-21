class StatusesController < ApplicationController
  before_filter :authenticate
  @user = ""
  def replies
    @tweets = Tweet.find(:all,:order => "tweets.created_at DESC", :conditions => "tweets.tweet like '@#{@user}%'",:include => :user)
    respond_to do |format|
      format.xml
    end
  end
  def friends_timeline
    @tweets = Tweet.find(:all,:order => "tweets.created_at DESC",:conditions => "tweets.tweet not like '@#{@user}%'",:include => :user)
    respond_to do |format|
      format.xml
      format.html
    end
  end
  def update
    u = User.find_or_create_by_username(@user)
    @tweet = Tweet.new
    @tweet.user = u
    @tweet.tweet = params[:status]
    @tweet.source
    @tweet.save
    respond_to do |format|
      format.xml
    end    
  end
  private
  def verify_authenticity_token
    return true
  end
  def authenticate
    authenticate_or_request_with_http_basic do |user_name, password|
      @user = user_name
      return true
    end
  end
end
