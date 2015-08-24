q = {}

# Default config
defaults =
	interval: 1000
	limit: 1

# Helper functions
#   t(): returns current timestamp
t = -> new Date().getTime()

# Creates a new queue
#   id: string ID of the queue
#   interval: time between executions
#   limit: maximum tries
create = (id, interval, limit) ->

	# Do nothing if queue already exists
	return false if q[id]?

	# Assign default values if interval or limit are not set (or are not numbers)
	interval = defaults.interval if not isFinite interval
	limit = defaults.interval if not isFinite limit

	# Interval must be larger than 0
	interval = 1 if interval < 1

	# Limit must be larger than 0
	limit = 1 if limit < 1

	# Create queue object
	q[id] =
		interval: interval
		limit: limit
		timer: null
		last_called: 0
		queue: []

# Sets interval of a specified queue
#   newInterval: the new interval
#   id: string ID of the queue
setInterval = (newInterval, id = 'default') ->

	# Do nothing if interval is not a valid number
	return false if not isFinite newInterval or newInterval < 1

	# Set interval
	q[id].interval = newInterval

# Sets interval of a specified queue
#   newLimit: the new limit
#   id: string ID of the queue
setLimit = (newLimit, id = 'default') ->

	# Make sure limit is a number
	return false if not isFinite newLimit or newLimit < 1

	# Set limit
	q[id].limit = newLimit

# Sets default interval for new queues
#   interval: the default interval
setDefaultInterval = (interval) ->
	return if not isFinite interval or interval < 1
	defaults.interval = interval

# Sets default limit for new queues
#   limit: the default limit
setDefaultLimit = (limit) ->
	return if not isFinite limit or limit < 1
	defaults.limit = limit




# Adds a function to the queue
#   function: function to be executed
#   callback: will be called when function is executed
#   id: string ID of the queue
add = (fn, cb, id = 'default') ->

	# Create queue if it doesn't exist yet
	if not q[id]?
		create id

	# Add function to queue
	q[id].queue.push
		tries: 0
		fn: fn
		cb: cb
		errors: []

	# Try to execute
	tryNext id


# Tries to execute the next function in the queue
#   id: string ID of the queue
tryNext = (id) ->

	# Do nothing if id is not set
	return false if not id?

	# Calculate when the next function in the queue can be called
	next = q[id].last_called - (t() - q[id].interval)

	# If next is in the future, set timeout to try again later
	if next > 0
		fn = -> tryNext(id)
		q[id].timer = setTimeout fn, next
		return

	# Check if anything's in the queue
	if q[id].queue.length > 0

		# Get function
		item = q[id].queue.splice(0, 1)[0]

		# Callback handler
		cb = (err = no) ->

			# If something went wrong, add error to item
			if err
				item.errors.push err

				# If we hit the retry limit, execute callback function with errors
				item.tries++
				if item.tries is q[id].limit
					item.cb(item.errors)

				# Otherwise, add item back to queue and try again
				else
					q[id].queue.push item
					tryNext id

			# Error is empty, pass all other return values on to callback
			else
				args = (a for i, a of arguments)

				item.cb.apply null, args


		# Update last called property
		q[id].last_called = t()

		# Execute function
		item.fn.apply
			queue:
				id: id
				length: q[id].queue.length
			tryNo: item.tries + 1
		, [cb]


# Create default queue
create 'default'

module.exports =
	add: add
	create: create
	setInterval: setInterval
	setLimit: setLimit
	setDefaultInterval: setDefaultInterval
	setDefaultLimit: setDefaultLimit

# Make queues accessible through `.queues`
Object.defineProperty module.exports, 'queues',
	get: ->
		obj = {}
		for id of q
			obj[id] =
				interval: q[id].interval
				length: q[id].queue.length
				limit: q[id].limit

				# Adds a new function to this queue
				add: (fn, cb) ->
					add fn, cb, id

				# Sets the interval of this queue
				setInterval: (newInterval) ->
					setInterval newInterval, id

				# Sets the retry limit of this queue
				setLimit: (newLimit) ->
					setLimit newLimit, id

		return obj