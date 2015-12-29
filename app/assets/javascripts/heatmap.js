var c = $('#heatmap').data('data');

var array = [];

for (var i = c.length - 1; i >= 0; i--) {
  array[array.length] = (new google.maps.LatLng(parseFloat(c[i].lat), parseFloat(c[i].lng)));
}

var map;

function initMap() {
  map = new google.maps.Map(document.getElementById('heatmap'), {
    center: {lat: -2.1649033, lng: -79.9260202},
    zoom: 12,
    dissipating: false,
    radius: 20,
    gradient: gradient
  });

  heatmap = new google.maps.visualization.HeatmapLayer({
    data: array,
    map: map
  });
}

var gradient = [
    'rgba(0, 255, 255, 0)',
    'rgba(0, 255, 255, 1)',
    'rgba(0, 191, 255, 1)',
    'rgba(0, 127, 255, 1)',
    'rgba(0, 63, 255, 1)',
    'rgba(0, 0, 255, 1)',
    'rgba(0, 0, 223, 1)',
    'rgba(0, 0, 191, 1)',
    'rgba(0, 0, 159, 1)',
    'rgba(0, 0, 127, 1)',
    'rgba(63, 0, 91, 1)',
    'rgba(127, 0, 63, 1)',
    'rgba(191, 0, 31, 1)',
    'rgba(255, 0, 0, 1)'
  ];


  
  







