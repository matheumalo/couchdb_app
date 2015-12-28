require 'couchrest_model'

class Tweet < CouchRest::Model::Base
  
  property :_id, String
  property :tweet_data, String
  property :lat, Float
  property :lng, Float

  

  design do

    REDUCE_SUM = "function(keys, values, rereduce) {
          return sum(values);
        }"

    INSIDE_BOX = 'function inside_box (point, bbox) {
    
    // http://www.ecse.rpi.edu/Homepages/wrf/Research/Short_Notes/pnpoly.html
    
    var x = point[0], y = point[1];
    
    var inside = false;
    
    for (var i = 0, j = bbox.length - 1; i < bbox.length; j = i++) {
        var xi = bbox[i][0], yi = bbox[i][1];
        var xj = bbox[j][0], yj = bbox[j][1];
        
        var intersect = ((yi > y) != (yj > y))
            && (x < (xj - xi) * (y - yi) / (yj - yi) + xi);
        if (intersect) inside = !inside;
    }
    
    return inside;
};'
    view :all_tweets ,:map =>'function(doc) {
        if (doc.tweet_data){
        emit(doc._id, 1);
      }
    }'
    # Displays screen_name and profile image url
    view :by_pic,:map =>"function(doc) {
      var name = doc.tweet_data.user.screen_name;
      var profile_pic = doc.tweet_data.user.profile_image_url;
      if (name && profile_pic){
        emit(name,profile_pic);
      }
    }"
    # Most Mentioned User
    view :by_most_mentioned,:map => 'function(doc) {
    if(doc.tweet_data.place.country_code == "EC"){
    if(doc.tweet_data.entities){
        if(doc.tweet_data.entities.user_mentions){
            doc.tweet_data.entities.user_mentions.forEach(function(user){
                emit("@"+user.screen_name, 1)
            });
        }
    }
  }
    }',:reduce => REDUCE_SUM
    
    # All mentioned hash tag topics
    view :hashtag, :map => 'function(doc) {
    if(doc.tweet_data.place.country_code == "EC"){
    if(doc.tweet_data.entities){
        if(doc.tweet_data.entities.hashtags){
            doc.tweet_data.entities.hashtags.forEach(function(hashtag){
                emit("#"+hashtag.text.toLowerCase(),1)
            });
        }
    }
  }
}', :reduce => REDUCE_SUM

    # Source use for tweeting
    view :by_source, :map => 'function(doc) {
        if (doc.tweet_data.source){
        emit(doc.tweet_data.source, 1);
      }
    }', :reduce => REDUCE_SUM

    #most frequently tweeted hour
    view :tweets_per_hour, :map => 'function(doc) {
  date = new Date(Date.parse((doc.tweet_data.created_at)));
  weekday = getWeekday(date.getDay())
  hour = date.getHours()
  emit([weekday,hour], 1)
}

function getWeekday(day){
  switch(parseInt(day)){
    case 0:
      return "domingo"
    case 1:
      return "lunes"
    case 2:
      return "martes"
    case 3:
      return "miercoles"
    case 4:
      return "jueves"
    case 5:
      return "viernes"
    case 6:
      return "sabado"
    default:
      return "no definido"
  }
}', :reduce => REDUCE_SUM


    # Identify if the tweet have coordinate
    view :by_coordinates, :map => 'function(doc) {
        if (doc.tweet_data.coordinates){
          coordinates = doc.tweet_data.coordinates.coordinates
          text = doc.tweet_data.text
      emit(doc.tweet_data._id, [coordinates, text]);
        }
      }'

  end
end

