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
    view :by_profile,:map =>"function(doc) {
      var name = doc.tweet_data.user.screen_name;
        if (name){
        emit(doc._id, name);
      }
    }"
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

    # Identify if the tweet have coordinate
    view :by_coordinates, :map => 'function(doc) {
        if (doc.tweet_data.coordinates){
          bounding_box = [[-80.0990009,-2.2873981],[-80.0990009,-2.0173767],[-79.8608184,-2.0173767],[-80.0990009,-2.2873981],[-80.0990009,-2.2873981]]
          point = doc.tweet_data.coordinates.coordinates;
          if (inside_box(point,bounding_box)) {
    emit(doc.tweet_data._id, point);
  }
          
      }'+ INSIDE_BOX +
    '}'

  end
end

