window.onload = function() {
  if( document.getElementById("replay-canvas") == null)
    return;
  var SIZE = 400;
  var BOT_RADIUS = config.bot_radius*SIZE;
  var EXPLOSION_RADIUS = config.explosion_radius*SIZE;
  var frame_index = 0
  var delay = 1000/config.frame_rate;

  var canvas = Raphael("replay-canvas", SIZE, SIZE);
  canvas.rect(0, 0, SIZE-1, SIZE-1);

  var bot1 = canvas.circle(config.bot1.x*SIZE, config.bot1.y*SIZE, BOT_RADIUS);
  bot1.attr("fill", "#f00");
  var bot2 = canvas.circle(config.bot2.x*SIZE, config.bot2.y*SIZE, BOT_RADIUS);
  bot2.attr("fill", "#00f");

  var explosions = [];
  var missiles = {};

  var intervalId = setInterval(function () {

    var frame = frames[frame_index];
    if( frame == undefined ) {
      clearInterval(intervalId);
      return;
    }
    frame_index += 1;

    // move bots
    bot1.animate({cx: frame.bot1.x*SIZE, cy: frame.bot1.y*SIZE}, delay);
    bot1.attr("fill-opacity", frame.bot1.health);
    bot2.animate({cx: frame.bot2.x*SIZE, cy: frame.bot2.y*SIZE}, delay);
    bot2.attr("fill-opacity", frame.bot2.health);

    // draw missiles
    new_missiles = []
    for( var key in frame.missiles ) {
      var missile = frame.missiles[key];
      var old = false;
      for( var id in missiles ) {
        if( id == missile.id ) {
          old = true;
          break;
        }
      }
      if( old ) {
        missiles[missile.id].animate({cx: missile.x*SIZE, cy: missile.y*SIZE}, delay);
      }
      else {
        missiles[missile.id] = canvas.circle(missile.x*SIZE, missile.y*SIZE, 2);
        missiles[missile.id].attr('fill', '#000');
      }
      new_missiles.push(missile.id);
    }
    // remove old missiles
    for( var id in missiles ) {
      var actual = false;
      for( var key in new_missiles ) {
        if( id == new_missiles[key] ) {
          actual = true;
          break;
        }
      }
      if( !actual ) {
        missiles[id].remove();
        delete missiles[id];
      }
    }
    

    // draw explosions
    for( var key in explosions ) {
      explosions[key].remove();
    }
    explosions = [];
    for( var key in frame.explosions ) {
      var point = frame.explosions[key];
      var e = canvas.circle(point.x*SIZE, point.y*SIZE, 0);
      e.attr('fill', '#f40');
      e.attr('fill-opacity', '1');
      e.attr('stroke-opacity', '0');
      e.animate({r: EXPLOSION_RADIUS, fill: '#ff0', 'fill-opacity': 0.5}, delay, ">");
      explosions.push(e);
    }

    // log
    for( var key in frame.log ) {
      var bot = frame.log[key][0];
      var msg = frame.log[key][1];

      if( bot == "bot1" ) {
        bot_name = red_name;
        id = "red-log-entry";
      }
      else {
        bot_name = blue_name;
        id = "blue-log-entry";
      }

      log_entry = document.createElement("div");
      log_entry.innerHTML = "[" + frame.time.toFixed(1) + "] " + bot_name + ": " + msg;
      log_entry.id = id;

      rl = document.getElementById("replay-logger")
      rl.appendChild( log_entry );
      rl.scrollTop = rl.scrollHeight;
    }
  }, delay);
};
