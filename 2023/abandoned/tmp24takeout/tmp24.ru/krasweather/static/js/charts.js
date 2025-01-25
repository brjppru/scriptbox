function chart(target, title, data){
    var $chart = new Highcharts.Chart({
        chart: {
            renderTo: target,
            type: 'spline',
            height: '250'
        },
        title: {
            text: title
        },
        xAxis: {
            type: 'datetime',
            title: 'Время'
        },
        yAxis: {
            title: 'Темература',
            labels: {
                formatter: function() {
                    return this.value + '°C';
                }
            },
            minRange: 2
        },
        series: [{
            name: 'Темература воздуха',
            data: data.data
        },
        {
            name: 'Прогноз погоды',
            data: data.forecast
        }]
    });
}

function add_leading_zero(i) {
    if (i<10) {
        return "0" + i;
    } else {
        return i;
    }
}

function clock() {
    var today = new Date(),
        h = today.getHours(),
        m = add_leading_zero(today.getMinutes()),
        $lastupdate = $('.lastupdate'),
        timefrom;

    $('#clock_hour').text(h);
    $('#clock_minute').text(m);

    if ($lastupdate.length) {
        timefrom = moment($lastupdate.data('date')).fromNow();
        $lastupdate.each(function(){
            $(this).text('(' + timefrom + ')');
        });
    }

    setTimeout(clock, 1000);
}

function init_map() {
    var myMap, myPlacemark,
        canvas_exists = $('#map_canvas').length;
    if (typeof ymaps != 'undefined' && canvas_exists) {
        ymaps.ready(init);
    }

    function init () {
        myMap = new ymaps.Map('map_canvas', {
            center: [56.029535, 92.912137],
            zoom:16
        });
        myPlacemark = new ymaps.Placemark([56.0298, 92.9120]);

        myMap.controls.add('zoomControl', { left: 5, top: 5 });
        myMap.geoObjects.add(myPlacemark);
    }
}

function current_charts() {
    var $charts = $('#charts').length;

    if ($charts) {
        $.ajax({
            url: '/today/',
            dataType: 'json'
        }).done(function(data) {
            chart('day-chart', $('#day-chart').data('caption'), data);
            $('#day_min').text(data.min);
            $('#day_avg').text(data.avg);
            $('#day_max').text(data.max);
        });

        $.ajax({
            url: '/week/',
            dataType: 'json'
        }).done(function(data) {
            chart('week-chart', $('#week-chart').data('caption'), data);
            $('#week_min').text(data.min);
            $('#week_avg').text(data.avg);
            $('#week_max').text(data.max);
        });
    }
}

function year_chart(year, target, title) {
    $.ajax({
        url: '/year/' + year + '/',
        dataType: 'json'
    }).done(function(data){
        var chart = new Highcharts.Chart({
            chart: {
                renderTo: target,
                type: 'spline',
                height: '350'
            },
            title: {
                text: title
            },
            xAxis: {
                type: 'linear',
                title: 'Месяц',
                categories: [
                    '', 'Январь', 'Февраль', 'Март', 'Апрель', 'Май', 'Июнь', 'Июль', 'Август',
                    'Сентябрь', 'Октябрь', 'Ноябрь', 'Декабрь'
                ]
            },
            yAxis: {
                title: 'Темература',
                labels: {
                    formatter: function() {
                        return this.value + '°C';
                    }
                },
                minRange: 2
            },
            series: [{
                name: 'Средняя темература воздуха',
                data: data.avg
            },
            {
                name: 'Ночь',
                data: data.low
            },
            {
                name: 'День',
                data: data.high
            },
            {
                name: 'Прогноз погоды',
                data: data.forecast
            }]
        });
    });
}

function month_chart(year, month, target, title) {
    $.ajax({
        url: '/year/' + year + '/' + month + '/',
        dataType: 'json'
    }).done(function(data){
        var chart = new Highcharts.Chart({
            chart: {
                renderTo: target,
                type: 'spline',
                height: '350'
            },
            title: {
                text: title
            },
            xAxis: {
                type: 'linear',
                title: 'День',
                tickInterval: 1
            },
            yAxis: {
                title: 'Темература',
                labels: {
                    formatter: function() {
                        return this.value + '°C';
                    }
                },
                minRange: 1
            },
            series: [{
                name: 'Средняя темература воздуха',
                data: data.avg
            },
            {
                name: 'Ночь',
                data: data.low
            },
            {
                name: 'День',
                data: data.high
            },
            {
                name: 'Прогноз погоды',
                data: data.forecast
            }]
        });
    });
}

function day_chart(year, month, day, target, title) {
    $.ajax({
        url: '/year/' + year + '/' + month + '/' + day + '/',
        dataType: 'json'
    }).done(function(data){
        var chart = new Highcharts.Chart({
            chart: {
                renderTo: target,
                type: 'spline',
                height: '350'
            },
            title: {
                text: title
            },
            xAxis: {
                type: 'linear',
                title: 'Час',
                allowDecimals: false,
                tickInterval: 1
            },
            yAxis: {
                title: 'Темература',
                labels: {
                    formatter: function() {
                        return this.value + '°C';
                    }
                },
                minRange: 2
            },
            series: [{
                name: 'Средняя темература воздуха',
                data: data.data
            },
            {
                name: 'Прогноз погоды',
                data: data.forecast
            }]
        });
    });
}

function autoreload() {
    setTimeout(function(){
        location.reload();
    }, 5 * 60 * 1000);
}

$(document).ready(function(){
    Highcharts.setOptions({
        global: {
            useUTC: false
        },
        lang: {
            shortMonths: [
                'Янв',
                'Фев',
                'Март',
                'Апр',
                'Май',
                'Июнь',
                'Июль',
                'Авг',
                'Сен',
                'Окт',
                'Ноя',
                'Дек'
            ],
            weekdays: ['Воскресенье','Понедельник','Вторник','Среда','Четверг','Пятница','Суббота']
        }
    });

    autoreload();
    clock();
    current_charts();
});
