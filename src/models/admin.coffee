mongoose = require("mongoose")
bcrypt = require "bcrypt-nodejs"

schema = new mongoose.Schema(
  username: String,
  password: String
)


schema.statics =
  hash_password : (raw_passwd, cb) ->
    # CB takes err hash
    bcrypt.hash raw_passwd, null, null, cb

schema.methods =
  check_password : (raw_passwd, cb) ->
    #CB takes err res
    console.log this
    bcrypt.compare(raw_passwd, @password, cb)


schema.pre "save", (done) ->
  thisAdmin = @
  Admin.hash_password( thisAdmin.password, (err, hash) ->
    thisAdmin.password = hash
    done()
  )

Admin = mongoose.model("Admin", schema)

module.exports = Admin