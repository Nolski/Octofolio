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

# Renders login page for github
app.get('/login', (req, res) ->
    console.log(octoDB)
    res.render('login')
)

#Handles repo management
app.get('/manage', (req, res) ->
    res.render('manage', repos: repos)
)

#Handles admin settings
app.get('/admin', (req, res) ->
    res.render('admin')
)

# Handles local user login
app.post('/admin', (req, res) ->
    #TODO: Handle local user login
    authenticate('Admin', req.body.password)
)
# Handles github user login
app.post('/manage', (req, res) ->
    username= req.body.username
    password = req.body.password

    client = github.client({
        username: username,
        password: password
    })

    client.get('/user/repos', {}, (err, status, body, headers) ->
        repos = (repo for repo in body when repo.private == false)
        console.log repos[0]
        res.render('manage', repos: repos)
    )
)

authenticate = (username, password) ->
    console.log("octoDB: ", octoDB)

