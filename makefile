# makefile for hello

# setup rules for pylint, pychecker (& pymetrics, if we ever get that to work)
# vi settings for python are bad for makefile, as they turn tabs into spaces

project	= mapsndata
browser = Firefox.app
url = "http://127.0.0.1"
port = 5000
page = $(url):$(port)/

include ../common/rules.mk

lint: $(pys)

test: makefile $(pys)
	open -a $(browser) $(page)

# ^C to break out of server
# server has a 'reloader' which reloads hello.py whenever it is changed, 
# 	cute, but also a bit unnerving
server:
	python $(project).py
#
# 	foreman is a ruby script that works with heroku but but caches a bit too aggressively for development
# 		-- foreman works by kicking off gunicorn
server2: 
	foreman start

#	gunicorn is what heroku uses itself, like foreman, caches a bit too aggressively
server3:
	gunicorn mapsndata:app

include ../common/targets.mk
