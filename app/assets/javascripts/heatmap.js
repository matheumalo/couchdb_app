data = $('#heatmap').data('data');

var latlng = getPoints(data);

var map;

function initMap() {
  map = new google.maps.Map(document.getElementById('heatmap'), {
    center: {lat: -2.1649033, lng: -79.9260202},
    zoom: 12
  });

  heatmap = new google.maps.visualization.HeatmapLayer({
    data: latlng,
    map: map
  });
}


function getPoints(data){
  var array = [];
  data.forEach(function(d) {
    array.push(new google.maps.LatLng(parseFloat(d.lat), parseFloat(d.lng)));
  });
  return array;

}






