var fs = require('fs');
var Canvas = require('canvas');

exports.set = function(app) {
  app.get('*', function(req, res) {
    res.setHeader("content-type", "image/jpeg");

    canvas = new Canvas(200, 200)
    ctx = canvas.getContext('2d');
    ctx.fillText("Awesome!", 0, 0);
    canvas.jpegStream().pipe(res)
  });
}

