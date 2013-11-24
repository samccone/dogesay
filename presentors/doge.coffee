fs     = require 'fs'
Canvas = require 'canvas'
canvas = null
ctx    = null
config = {
  fontSize: 100
  wordsPerLine: 2
  lineIndents: [0, .15, .40, .10, 0, .30]
}

module.exports = (req, res) ->
  res.setHeader "content-type", "image/png"

  fs.readFile __dirname+"/../doge.jpeg", (err, d) ->
    message = formatMessage(req.path.split("/").slice(1))
    canvas  = new Canvas(500, 500)
    ctx     = canvas.getContext('2d')

    img     = new Canvas.Image
    img.src = d

    ctx.drawImage img, 0, 0, 500, 500

    drawMessage message
    canvas.pngStream().pipe(res)


formatMessage = (message) ->
  hold      = []
  formatted = []
  message.forEach (w) ->
    hold.push w
    if hold.length % config.wordsPerLine is 0
      formatted.push(hold.join(" "))
      hold = []

  formatted.push(hold.join(" ")) if hold.length
  formatted

drawMessage = (messages) ->
  lastHeight = 0

  messages.forEach (m, i) ->
    ctx.font = "#{config.fontSize}px Comic Sans"
    size     = ctx.measureText(m)
    step     = 0

    while size.width > canvas.width - config.lineIndents[i]*canvas.width and ++step < config.fontSize
      ctx.font = "#{config.fontSize - step}px Comic Sans"
      size     = ctx.measureText(m)

    ctx.fillText m, config.lineIndents[i]*canvas.width, size.emHeightAscent + i * lastHeight + config.lineHeight * ++i
    lastHeight = size.emHeightAscent
