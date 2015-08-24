###
This is no automated test script if you were expecting that
It is basically just a script that I use for testing new featues in my module
###

# Node modules
fs = require 'fs'
http = require 'http'

# Multiqueue
multiq = require '../'

# Default interval test
multiq.setDefaultInterval 250
multiq.create 'intervalTest'
console.log multiq.queues


multiq.queues.intervalTest.add ->
	console.log 'yo1'
multiq.queues.intervalTest.add ->
	console.log 'yo2'
multiq.queues.intervalTest.add ->
	console.log 'yo3'