Admin = require '../models/admin'

module.exports = (app, github) ->
    app.get('/manage', (req, res) ->
        return res.redirect('/admin') unless req.session.logedIn
        res.render('login')
    )

    app.post('/manage', (req, res) ->
        return res.redirect('/admin') unless req.session.logedIn
        username= req.body.username
        password = req.body.password

        app.client = github.client({
            username: username,
            password: password
        })


        app.client.get('/user/repos', {}, (err, status, body, headers) ->
            if err
                app.client = null
                return res.send err.statusCode, err.message
            app.repos = (repo for repo in body when repo.private == false)
            console.log app.repos[0]
            res.redirect('/Octofolio')
        )
    )

    #Handles admin settings
    app.get('/admin', (req, res) ->
            return res.redirect('/manage') if req.session.logedIn
            res.render('admin')
    )

    # Handles local user login
    app.post('/admin', (req, res) ->
            return res.redirect('/manage') if req.session.logedIn
            Admin.findOne("admin", (err, adminUser) ->
                adminUser.check_password(req.body.password, (err, pwCheck) ->
                    return res.send 401 unless pwCheck
                    req.session.logedIn = true
                    res.redirect '/manage'
                )
            )
#            req.session.
#            authenticate('Admin', req.body.password)
    )
