# This is no automated test script if you were expecting that
# It is basically just a script that I use for testing my module

# Node modules
fs = require 'fs'
http = require 'http'

# Multiqueue
multiq = require '../'

# Add item to default queue
multiq.create 'myQ', 100, 1

req = (cb) ->
	console.log this # `this` contains information about the queue and the function. Not sure I want to keep this but for now it'll do

	r = http.get 'http://jsonplaceholder.typicode.com/posts/1', (res) ->
		data = ''
		res.on 'data', (d) ->
			data += d

		res.on 'end', ->
			cb no, data

	r.on 'error', cb

handler = (err, result) ->
	if err
		return console.error err[err.length - 1]

	console.log result

multiq.add req, handler, 'myQ'


multiq.queues.default.add (callback) ->
	a = 1 + 1
	callback false, a
, (err, result) ->
	console.log(result)

