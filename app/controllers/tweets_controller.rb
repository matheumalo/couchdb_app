

class TweetsController < ApplicationController
  def index
    most_mentioned = Tweet.by_most_mentioned.reduce.group_level(1)
    most_mentioned_rows = most_mentioned.rows.sort_by{ |a| a['value']}.reverse.take(10)

    hashtags = Tweet.hashtag.reduce.group_level(1)
    hashtags_rows = hashtags.rows.sort_by{ |a| a['value']}.reverse.take(20)

    source = Tweet.by_source.reduce.group_level(1)
    source_rows = source.rows.sort_by{ |a| a['value']}.take(10)

    @tweets = Hash["most_mentioned" => most_mentioned_rows, "hashtags" => hashtags_rows, "source" => source_rows]
    @total = Tweet.all_tweets.count
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
      marker.infowindow tweet['info']

    end
  end


private
  def to_gmaps_coordinates(rows)
    coord_array = []
    rows.each do |row|
      coordinates_hash = {}
      coordinates_hash['lng'] = row['value'][0][0]
      coordinates_hash['lat'] = row['value'][0][1]
      coordinates_hash['info'] = row['value'][1]
      coord_array.push(coordinates_hash)
    end
    return coord_array
  end

   def gmaps4rails_infowindow
      "<p>#{self.info}<p>"
   end
end
