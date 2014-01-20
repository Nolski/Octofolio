mongoose = require("mongoose")
Admin = require './models/admin'

init = (app, config) ->
  db = mongoose.connection
  db.on "error", console.error.bind(console, "Mongo connection error:")
  db.once "open", callback = ->
    console.log "Mongo DB connected!"
    configAdmin = new Admin(
      username : "admin"
      password : config.password)
    Admin.remove {}, () ->
      configAdmin.save()

  mongoose.connect "mongodb://localhost:27017/Octofolio"
  db

module.exports = init

