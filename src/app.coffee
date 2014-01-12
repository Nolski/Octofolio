express = require "express"
github = require 'octonode'
config = require '../config'
path = require('path');
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

app.get("/dylansoctofolio", (req, res)->

  repos[0].info(

    (err, status, body, headers)->
      res.json body
  );

)

app.get('/manage', (req, res) ->
	res.render('manage')
)
