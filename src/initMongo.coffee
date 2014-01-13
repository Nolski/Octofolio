mongoose = require "mongoose"

init = ->
    db = mongoose.connection;
    db.on("error", console.error.bind(console, "Mongo connection error:"))
    db.once("open", callback = ->
        return console.log("Mongo DB connected!")
    )
    mongoose.connect('mongodb://localhost:27017/records')
    return db

module.exports = {
        init: init
}
