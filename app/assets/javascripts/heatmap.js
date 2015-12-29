var c = $('#heatmap').data('data');

var array = [];

for (var i = c.length - 1; i >= 0; i--) {
  array[array.length] = (new google.maps.LatLng(parseFloat(c[i].lat), parseFloat(c[i].lng)));
}

var map, heatmap;

function initMap() {
  map = new google.maps.Map(document.getElementById('heatmap'), {
    center: {lat: -2.1649033, lng: -79.9260202},
    zoom: 12,
    dissipating: false,
    radius: 20
  });

  heatmap = new google.maps.visualization.HeatmapLayer({
    data: array,
    map: map
  });
}




  
  







