express = require "express"
github = require 'octonode'
config = require '../config'
path = require 'path'
http = require 'http'

app = express()

client = github.client()
ghme   = client.me();
ghuser = client.user(config.user);



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
);



repos = (client.repo("#{config.user}/#{repo}") for repo in config.repos)

http.createServer(app).listen(app.get('port'), ()->
  console.log("Express server listening on port " + app.get('port'));
)
#ghissue : client.issue("#{config.user}/#{repo}")
#ghpr : client.pr("#{config.user}/#{repo}")


app.get('/manage', (req, res) ->
    res.render('login')
)

app.post('/manage', (req, res) ->
    username= req.body.username
    password = req.body.password

    client = github.client({
        username: username,
        password: password
    })


    client.get('/user/repos', {}, (err, status, body, headers) ->
        res.send err.statusCode, err.headers.status if err
        repos = (repo for repo in body when repo.private == false)
        console.log repos[0]
        res.render('manage', repos: repos)
    )
)
