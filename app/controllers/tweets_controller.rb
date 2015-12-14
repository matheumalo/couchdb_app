

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

  def source
    source = Tweet.by_source.reduce.group_level(1)
    @tweets = source.rows.sort_by{ |a| a['value']}.reverse
  end

  def coordinates
    @tweets = to_gmaps_coordinates(Tweet.by_coordinates.rows)
    @hash = Gmaps4rails.build_markers(@tweets) do |tweet, marker|
      marker.lat tweet['lat']
      marker.lng tweet['lng']
    end
  end


private
  def to_gmaps_coordinates(rows)
    coord_array = []
    rows.each do |row|
      coordinates_hash = {}
      coordinates_hash['lng'] = row['value'][0]
      coordinates_hash['lat'] = row['value'][1]
      coord_array.push(coordinates_hash)
    end
    return coord_array
  end
end
