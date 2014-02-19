# mapsndata.py, modeled on hello.py from flask quickstart
#   pylint likes lots of docstrings, in a bit
#   can run pychecker, pyflakes, & pep8 on this as well
# see ~/.pylintrc to get fine control over pylint errors

"""Flask Quickstart"""

# how do we log to an error file of some kind?
#   check out the standard logger module & use a logger configuration file
# currently session, g not used; in a bit
# the Flask class is our WSGI (& Werkzeug) app
from flask import Flask, url_for, render_template, request, session, redirect, escape
app = Flask(__name__)

@app.route('/')
def index():
    """Start point"""
    # logger shows on the server output
    app.logger.debug("testing index route for mapsndata")
    if 'username' in session:
        return "Logged in as '%s'." % escape(session['username'])
    return 'You are not logged in..'

# registration forms shown in flask standard patterns
@app.route('/users/')
def user_search():
    """Search for users"""
    return "Search for users"

# implication of this is that the name is unique
@app.route('/user/<username>')
def show_user_profile(username):
    """Return user profile"""
    return "User %s" % username

@app.route('/user/<int:user_id>')
def show_user_by_id(user_id):
    """Return user profile by id"""
    return "User# %d" % user_id

@app.route('/login', methods=['GET', 'POST'])
def login():
    """Login routine"""
    # where does 'request' come from?
    #   supplied by Flask
    #       in this case, how to tell pylint about this?
    if request.method == 'POST':
        session['username'] = request.form['username']
        return redirect(url_for('index'))
    return '''
        <form action="" method="post">
            <p><input type=text name=username>
            <p><input type=submit value=Login>
        </form>
'''

@app.route('/logout')
def logout():
    """Remove the username from the session if it is there"""
    session.pop('username', None)
    return redirect(url_for('index'))

app.secret_key = '{\xa4\x8d\xc5\x0bw\xbap\n\xd3:\xc8\xb5\xf9xu\xd0=\xee\x89u\x84\xd1\x83'

@app.route('/maps/')
def map_search():
    """Search for maps"""
    return "Search for maps"

@app.route('/map/<int:map_id>')
def show_map_by_id(map_id):
    """Return map from id"""
    return "Map# %d" % map_id

# implication of this is that the name is unique
@app.route('/map/<map_name>')
def show_map_by_name(map_name):
    """Return map from map name"""
    return "Map %s" % map_name

# static pages:
#   how to use url_for? -- it just returns a string
#       -- url_for('static', filename='about.html')
#       -- url_for('static', filename='contact.html')
@app.route('/about')
def about_page():
    """Show About page"""
    # note that url_for will toss up a werkzeug error
    #   if the file does not exist,
    #   -- this is not just string level stuff
    tag = url_for('static', filename='about.html')
    return "About this site:  page is %s " % tag

@app.route('/contact')
def contact_page():
    """Show contact page"""
    return "Contact us"

# does this hello page work?
@app.route('/hello')
@app.route('/hello/<name>')
def hello(name=None):
    """Test out Jinja2 templates"""
    # use Template Inheritance to setup headers, footers, & other standard elements...
    return render_template('hello.html', name=name)

@app.route('/missing')
def missing_page():
    """Show Missing page"""
    tag = url_for('static', filename='missing.html')
    return "Missing page for this site:  page is %s " % tag

# 404 error management covered on page 22 of Flask document
if __name__ == '__main__':
    # app.run turns on the server!
    # can be called as: app.run(host='0.0.0.0')
    #   -- is port= allowed?
    app.debug = True    # could also call as app.run(debug=True), same thing
    # how to set the port from the environment?
    app.run(host='127.0.0.1', port=8000)
