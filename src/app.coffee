express = require "express"
github = require 'octonode'
config = require '../config'
path = require 'path'
http = require 'http'
mongo = require 'mongoskin'
octoDB = {}

app = express()
app.admin = require('./models/admin')
db = require('./initMongo')(app, config)

client = github.client()
ghme   = client.me();
ghuser = client.user(config.user);
repos = []

app.configure(()->
    app.set('port', process.env.PORT || 3000);
    app.set('views', __dirname + '/views');
    app.set('view engine', 'jade');
    app.use(express.favicon());
    app.use(express.logger('dev'));
    app.use(express.bodyParser());
    app.use(express.methodOverride());
    app.use(app.router);
    app.use(express.static(path.join(__dirname, 'public')));
    require('./routes/manage')(app, github)
    require('./routes/Octofolio')(app, github)
);

#Connect to database
db = mongo.db('127.0.0.1:27017/Octofolio')

#Create webserver
http.createServer(app).listen(app.get('port'), ()->
    console.log("Express server listening on port " + app.get('port'));
)


