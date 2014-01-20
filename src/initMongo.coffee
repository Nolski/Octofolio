mongoose = require("mongoose")

init = (app, config) ->
  db = mongoose.connection
  db.on "error", console.error.bind(console, "Mongo connection error:")
  db.once "open", callback = ->
    console.log "Mongo DB connected!"
    configAdmin = new app.admin(
      username : config.username
      password : config.password)
    configAdmin.save()

  mongoose.connect "mongodb://localhost:27017/Octofolio"
  db

module.exports = init