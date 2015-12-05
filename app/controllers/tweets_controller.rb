class TweetsController < ApplicationController
  def index
    @tweets = Tweet.by_pic.rows
  end

  def mentioned
    most_mentioned = Tweet.by_most_mentioned.reduce.group_level(1)
    @tweets = most_mentioned.rows.sort_by{ |a| a['value']}.reverse.take(10)
  end

  def hashtags
    hashtags = Tweet.hashtag.reduce.group_level(1)
    @tweets = hashtags.rows.sort_by{ |a| a['value']}.reverse.take(20)
  end

end
