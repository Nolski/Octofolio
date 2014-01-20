module.exports = (app, github) ->
  app.get('/manage', (req, res) ->
    res.render('login')
  )

  app.post('/manage', (req, res) ->
    console.log req.body
    username= req.body.username
    password = req.body.password

    app.client = github.client({
      username: username,
      password: password
    })


    app.client.get('/user/repos', {}, (err, status, body, headers) ->
      if err
        app.client = null
        return res.send err.statusCode, err.headers.status
      app.repos = (repo for repo in body when repo.private == false)
      console.log app.repos[0]
      res.redirect('/Octofolio')
    )
  )