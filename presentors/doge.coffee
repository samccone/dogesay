fs     = require 'fs'
Canvas = require 'canvas'
Font   = Canvas.Font
canvas = null
ctx    = null
caopt  =
  max: 500 * 1024 # ~500M
  length: (n) -> n.length
  maxAge: 1000 * 60 * 60
cache  = require('lru-cache')(caopt)
config =
  fontSize: 100
  wordsPerLine: 2
  lineHeight: 0
  lineIndents: [0, .15, .40, .10, 0, .30]
  colors: ["#dd7c5c", "#000", "#cdd156", "#7a9fba", "#b996ae"]
  width: 680
  height: 510
  maxsize: [1280,960]
  fontFamily: "comicSans"
images =
  base: # default
    name: 'reallybigdoge.jpeg'
    size: [680,510]
  dogecoin:
    name: 'dogecoin.png'
    size: [300,300]
  dogeface:
    name: 'doge.jpeg'
    size: [264,264]
  moon:
    name: 'moon.jpg'
    size: [1024,576]


module.exports = (req, res) ->

  res.setHeader "content-type", "image/png"

  doge = images[req.query.image] || images.base

  if /^\d+(?:x\d+)?$/i.test(req.query.size)
    [width,height] = req.query.size.split(/x/i)
    width = Math.min(parseInt(width), config.maxsize[0])
    if height
      height = Math.min(parseInt(height), config.maxsize[1])
    else
      height = width * (doge.size[1] / doge.size[0])

  width ||= doge.size[0]
  height ||= doge.size[1]

  cachekey = [req.path,doge.name,width,height].join()

  if cache.has(cachekey)
    res.end(cache.get(cachekey))
  else
    fs.readFile "#{__dirname}/../images/"+doge.name, (err, d) ->
      message = formatMessage(req.path.split("/").slice(1))
      canvas  = new Canvas(width, height)
      ctx     = canvas.getContext('2d')

      img     = new Canvas.Image
      img.src = d

      ctx.addFont(new Font("comicSans", "#{__dirname}/../fonts/cs.ttf"))

      ctx.drawImage img, 0, 0, width, height

      drawMessage message
      cache.set(cachekey, canvas.toBuffer())
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

    ctx.fillStyle = config.colors[~~(Math.random() * config.colors.length)]
    ctx.fillText m,
      config.lineIndents[i]*canvas.width,
      size.emHeightAscent + heightStack + config.lineHeight * ++i

    heightStack += config.fontSize - step
