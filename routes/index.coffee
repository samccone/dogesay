
Doge   = require '../presentors/doge'

exports.set = (app) ->
  app.get '/', (req, res) -> res.render 'index'
  app.get '*', Doge
