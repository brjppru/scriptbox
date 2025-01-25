$(document).ready(function(){
    var mapOptions = {
        center: new google.maps.LatLng(55.45, 37.37),
        zoom: 8,
        mapTypeId: google.maps.MapTypeId.ROADMAP
    },
    map = new google.maps.Map(document.getElementById("map_canvas"), mapOptions);
});
