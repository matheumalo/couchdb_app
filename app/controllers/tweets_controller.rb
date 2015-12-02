class TweetsController < ApplicationController
  def index
    @tweets = Tweet.by_pic.rows
  end
end
