fs     = require 'fs'
Canvas = require 'canvas'

module.exports = (req, res) ->
  res.setHeader "content-type", "image/png"

  fs.readFile __dirname+"/../doge.jpeg", (err, d) ->
    canvas  = new Canvas(200, 200)
    ctx     = canvas.getContext('2d')

    img     = new Canvas.Image
    img.src = d

    ctx.drawImage img, 0, 0, 200, 200

    ctx.font = '30px impact'
    ctx.rotate .1
    ctx.fillText req.path.split("/").join(" "), 50, 100

    te = ctx.measureText 'awesome!'
    ctx.strokestyle = 'rgba(0,0,0,0.5)'
    ctx.beginPath()
    ctx.lineTo(50, 102)
    ctx.lineTo(50 + te.width, 102)
    ctx.stroke()


    canvas.pngStream().pipe(res)
