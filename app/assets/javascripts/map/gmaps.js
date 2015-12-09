
$(window).load(function() {
  loadScript();
});

var map;


function initialize() {
        
  var mapOptions = {
          center: new google.maps.LatLng(-2.1834723,-79.901731,14),
          zoom: 14,
          mapTypeId: google.maps.MapTypeId.NORMAL,
          panControl: true,
          scaleControl: false,
        };
        // initializing map
        map = new google.maps.Map(document.getElementById("map-canvas"),mapOptions);
}


var marker;
function createMarker(coords, map, title){
  marker = new google.maps.Marker({
    position: coords,
    map: map,
    title: title
  });
}

function createImage(url){
  var image = {
    url: url,
    // This marker is 32 pixels wide by 32 pixels tall.
    size: new google.maps.Size(32, 32),
    // The origin for this image is 0,0.
    origin: new google.maps.Point(0,0),
    // The anchor for this image is the base of the flagpole at 0,32.
    anchor: new google.maps.Point(0, 32)
  };
  return image;
}

function createCustomMarker(coords,map,title){
  marker = new google.maps.Marker({
    position: coords,
    map: map,
    title: title,
    icon: createImage("/assets/icon.png")
  });
}

function createInfoWindow(text){
  var infowindow = new google.maps.InfoWindow({
    content: text
  });
  return infowindow;
}

function loadScript() {
  console.log("map loading ...");
  var script = document.createElement('script');
  script.type = 'text/javascript';
  //'https://maps.googleapis.com/maps/api/js?v=3.exp&key=AIzaSyBJYFdplGeKUUEmGZ-vL4ydiSZ09Khsa_o&sensor=false&libraries=drawing'
  script.src = 'https://maps.googleapis.com/maps/api/js?v=3.22' +
    '&key=AIzaSyCtSvttGCu7KaM6UYrL6SpyS6kZ1DH2b6s'+
    '&libraries=drawing'+
    '&callback=initialize';
  document.body.appendChild(script);
}

