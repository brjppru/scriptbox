$(document).ready(function(){
    $('#yandex-map-form').on('keyup', '#id', function(){
        var id = $(this).val(),
            $result = $('#result'),
            $code = $('#code');

        if (id.length) {
            $result.fadeIn();
            $code.text('<div id="' + id + '" class="map-canvas">');
        } else {
            $result.fadeOut();
        }
    });

    if (typeof ymaps != 'undefined') {
        ymaps.ready(function(){
            $('.map-canvas').each(function(){
                var $canvas = $(this),
                    id = $canvas.prop('id'),
                    url = '/map/' + id + '/';

                $.get(url, function(data){
                        $canvas.css('width', data.width);
                        $canvas.css('height', data.height);

                        map = new ymaps.Map(id, {
                            center: [data.center_lat, data.center_lng],
                            zoom: data.zoom
                        });
                        placemark = new ymaps.Placemark([data.placemark_lat, data.placement_lng]);

                        map.controls.add('zoomControl', { left: 5, top: 5 });
                        map.geoObjects.add(placemark);
                }, 'json');
            });
        });
    }
});
