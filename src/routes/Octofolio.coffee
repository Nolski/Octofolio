module.exports = (app, github) ->
  app.get('/Octofolio', (req, res) ->
    return res.send 500, "Admin hasn't added git account" unless app.client
    res.render('manage', repos: app.repos)
  )


