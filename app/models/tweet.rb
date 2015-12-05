require 'couchrest_model'

class Tweet < CouchRest::Model::Base
  
  property :_id, String
  property :tweet_data, String
  

  design do
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
    view :by_most_mentioned,:map => "function(doc) {
    if(doc.tweet_data.entities){
        if(doc.tweet_data.entities.user_mentions){
            doc.tweet_data.entities.user_mentions.forEach(function(user){
                emit('@'+user.screen_name, 1)
            });
        }
    }
    }",:reduce => "function(keys, values, rereduce) {
          return sum(values);
        }"
  end
end

