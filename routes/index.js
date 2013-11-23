var fs = require('fs');
var Canvas = require('canvas');

exports.set = function(app) {
  app.get('*', function(req, res) {
    res.setHeader("content-type", "image/png");

    canvas = new Canvas(200, 200)
    ctx = canvas.getContext('2d');

    ctx.font = '30px impact';
    ctx.rotate(.1);
    ctx.fillText("awesome!", 50, 100);

    var te = ctx.measureText('awesome!');
    ctx.strokestyle = 'rgba(0,0,0,0.5)';
    ctx.beginPath();
    ctx.lineTo(50, 102);
    ctx.lineTo(50 + te.width, 102);
    ctx.stroke();


    canvas.pngStream().pipe(res)
  });
}

