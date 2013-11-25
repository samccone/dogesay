fs     = require 'fs'
Canvas = require 'canvas'
canvas = null
ctx    = null
config =
  fontSize: 100
  wordsPerLine: 2
  lineHeight: 0
  lineIndents: [0, .15, .40, .10, 0, .30]
  width: 500
  height: 500
  fontFamily: "Comic Sans"

module.exports = (req, res) ->
  res.setHeader "content-type", "image/png"

  fs.readFile __dirname+"/../doge.jpeg", (err, d) ->
    message = formatMessage(req.path.split("/").slice(1))
    canvas  = new Canvas(config.width, config.height)
    ctx     = canvas.getContext('2d')

    img     = new Canvas.Image
    img.src = d

    ctx.drawImage img, 0, 0, config.width, config.height

    drawMessage message
    canvas.pngStream().pipe(res)

removeExtension = (message) ->
  l = message.length - 1
  if ~message[l].indexOf('.')
    message[l] = message[l].slice(0, message[l].indexOf('.'))
  message

formatMessage = (message) ->
  hold      = []
  formatted = []
  removeExtension(message).forEach (w) ->
    hold.push decodeURI(w)
    if hold.length % config.wordsPerLine is 0
      formatted.push(hold.join(" "))
      hold = []

  formatted.push(hold.join(" ")) if hold.length
  formatted

drawMessage = (messages) ->
  heightStack = 0

  messages.forEach (m, i) ->
    ctx.font = "#{config.fontSize}px #{config.fontFamily}"
    size     = ctx.measureText(m)
    step     = 0

    while size.width > canvas.width - config.lineIndents[i]*canvas.width and ++step < config.fontSize
      ctx.font = "#{config.fontSize - step}px #{config.fontFamily}"
      size     = ctx.measureText(m)

    ctx.fillText m,
      config.lineIndents[i]*canvas.width,
      size.emHeightAscent + heightStack + config.lineHeight * ++i

    heightStack += config.fontSize - step
