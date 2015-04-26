(function() {
  $(function() {
    var all_height, all_width, canvas, data, height, svg, time_extent, time_scale, width, x_margin, y_extent_high, y_margin, y_scale, y_scale_reverse;
    $('#graph').text('');
    data = [
      {
        year: 2011,
        value: 200
      }, {
        year: 2013,
        value: 150
      }, {
        year: 2014,
        value: 180
      }, {
        year: 2015,
        value: 180
      }
    ];
    console.log(data);
    canvas = d3.select('#graph');
    x_margin = 0;
    y_margin = 50;
    all_width = 700;
    all_height = 500;
    width = all_width - x_margin * 2;
    height = all_height - y_margin * 2;
    y_extent_high = d3.extent(data, function(d) {
      return d.value;
    });
    y_scale = d3.scale.linear().domain([0, y_extent_high[1]]).range([height - y_margin, 0 + y_margin]).nice();
    y_scale_reverse = d3.scale.linear().domain([0, y_extent_high[1]]).range([height - y_margin, 0 + y_margin]).nice();
    time_extent = d3.extent(data, function(d) {
      return new Date(d.year, 1, 1);
    });
    time_scale = d3.time.scale().domain(time_extent).range([x_margin, width]).nice();
    svg = canvas.append('svg').attr({
      width: all_width,
      height: all_height
    });
    return svg.selectAll('circle').data(data).enter().append('circle').attr({
      cx: function(d) {
        return time_scale(new Date(d.year, 1, 1));
      },
      cy: function(d) {
        return y_scale_reverse(d.value);
      },
      r: 5,
      fill: 'red',
      stroke: 'black'
    });
  });

}).call(this);
