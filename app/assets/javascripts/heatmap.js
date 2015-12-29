data = $('#heatmap').data('data');

var map;
function initMap() {
  map = new google.maps.Map(document.getElementById('heatmap'), {
    center: {lat: -2.1649033, lng: -79.9260202},
    zoom: 12
  });

  heatmap = new google.maps.visualization.HeatmapLayer({
    data: getPoints(data),
    map: map
  });
}


function getPoints(data){
  var points = [],
      str = 'new google.maps.LatLng';
  data.forEach(function(d) {
    points.push(new google.maps.LatLng(d.lat, d.lng));

  });
  return points;

}



