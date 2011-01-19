function replayer() {
  var SIZE = 400;
  var BOT_RADIUS = config.bot_radius*SIZE;
  var EXPLOSION_RADIUS = config.explosion_radius*SIZE;
  var frame_index = 0
  var delay = 1000/config.frame_rate;

  var canvas = Raphael("canvas", SIZE, SIZE)
  canvas.rect(0, 0, SIZE-1, SIZE-1);

  var bot1 = canvas.circle(config.bot1.x*SIZE, config.bot1.y*SIZE, BOT_RADIUS).attr("fill", "#f00");
  var bot2 = canvas.circle(config.bot2.x*SIZE, config.bot2.y*SIZE, BOT_RADIUS).attr("fill", "#00f");

  var explosions = [];
  var missiles = {};

  var intervalId = setInterval(function () {
    if( $('#canvas').length == 0 ) {
      clearInterval(intervalId);
      return;
    }

    var frame = frames[frame_index];
    if( _(frame).isUndefined() ) {
      clearInterval(intervalId);

      var fade_time = 10*delay;
      canvas.rect(0, 0, SIZE-1, SIZE-1).attr({fill:"#fff", stroke:"#000", "fill-opacity":"0.0"})
              .animate({"fill-opacity":"0.7"}, fade_time/4);
      canvas.text(SIZE/2, SIZE/2, "Конец").attr({font: "1px Tahoma, Verdana, Arial, sans-serif"})
              .animate({"font-size":50}, fade_time, "elastic");
      return;
    }
    frame_index += 1;

    // move bots
    bot1.animate({cx: frame.bot1.x*SIZE, cy: frame.bot1.y*SIZE}, delay).attr("fill-opacity", frame.bot1.health);
    bot2.animate({cx: frame.bot2.x*SIZE, cy: frame.bot2.y*SIZE}, delay).attr("fill-opacity", frame.bot2.health);

    // draw missiles
    new_missiles = []
    _(frame.missiles).each(function(missile) {
      var old = _(_(missiles).keys()).any(function(id) {
        return id == missile.id;
      });

      if( !old ) {
        missiles[missile.id] = canvas.circle(missile.x*SIZE, missile.y*SIZE, 2).attr('fill', '#000');
      } else {
        missiles[missile.id].animate({cx: missile.x*SIZE, cy: missile.y*SIZE}, delay);
      }
      new_missiles.push(missile.id);
    });
    // remove old missiles
    _(_(missiles).keys()).each(function(m) {
      if( new_missiles.indexOf(parseInt(m)) == -1 ) {
        missiles[m].remove();
        delete missiles[m];
      }
    });


    // draw explosions
    _(explosions).each(function(e) {
      e.remove();
    });
    explosions = _(frame.explosions).map(function(point) {
      return canvas.circle(point.x*SIZE, point.y*SIZE, 0)
                      .attr({'fill':'#f40','fill-opacity':'1','stroke-opacity':'0'})
                      .animate({r: EXPLOSION_RADIUS, fill: '#ff0', 'fill-opacity': 0.5}, delay, ">")
    });

    // log
    _(frame.log).each(function(f) {
      var bot = f[0];
      var msg = f[1];

      if( bot == "bot1" ) {
        bot_name = red_name;
        colored_class = "red";
      } else {
        bot_name = blue_name;
        colored_class = "blue";
      }

      log_entry = $("<div></div>")
                      .html( "[" + frame.time.toFixed(1) + " s] " + bot_name + ": " + msg)
                      .addClass(colored_class);
      $("#logger").append( log_entry ).scrollToBottom();
    });
  }, delay);
};
