# Node modules
fs = require 'fs'
http = require 'http'

# Multiqueue
q = require '../'

# Add item to default queue
q.create 'myQ', 100, 1

req = (cb) ->
	console.log @queue.length

	r = http.get 'http://jsonplaceholder.typicode.om/posts/1', (res) ->
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

for i in [0..20]
	q.add req, handler, 'myQ'