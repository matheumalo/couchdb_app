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
  end
end

