# Multiqueue
A simple Node.JS function queuing module with multiple queues

[![NPM version](https://img.shields.io/npm/v/multiqueue.svg?style=flat-square)](https://www.npmjs.com/package/multiqueue)
[![Dependencies](https://img.shields.io/david/woubuc/multiqueue.svg?style=flat-square)](https://david-dm.org/woubuc/multiqueue)
[![Github issues](https://img.shields.io/github/issues/woubuc/multiqueue.svg?style=flat-square)](https://github.com/woubuc/multiqueue/issues)

## What it does
This module allows you to have multiple queues with functions that will be processed one at a time at a set interval. Each queue operates independently from the others.

## Basic Usage

Install the module through npm

```
npm install multiqueue --save
```

Require the module in your code

```Javascript
var multiq = require('multiqueue');
```

Add a function to the queue

```Javascript
multiq.add(function(callback){
	var a = 1 + 1; // Or you could, you know, do something useful instead
	callback(false, a);
}, function(err, data){
	console.log(data); // 2
});
```

If there are no other functions in the queue, this function will run right away. Otherwise it will be added to the end of the queue, and it will be executed as soon as the previous functions have been processed.

That's it, basically.

## Queues
Out of the box Multiqueue uses the `default` queue, which has the default interval of 1 second.

You can add a custom queue easily by using the `create` method.

```Javascript
multiq.create('myQueue');
```

This will create a new queue called `myQueue`. You can then use this queue by adding the queue ID as an additional parameter to the multiqueue functions.

```Javascript
multiq.add(function(callback){
	var a = 1 + 1; // Or you could, you know, do something useful instead
	callback(false, a);
}, function(err, data){
	console.log(data); // 2
}, 'myQueue');
```


## Error handling & retrying
If something goes wrong, Multiqueue can try to run your function again. This may be useful if you are doing stuff that can fail sometimes, but succeed others (e.g. HTTP requests). The default queue does not retry, but when you create a custom queue you can set the retry limit to pretty much whatever you want.

**Note:** Retries are removed from their position in the queue and re-added to the end of the queue.

When a function in the queue fails, the error message is passed along to the callback function. The `err` argument in the callback function will be an array containing the error messages from each try.


## API

### Create
```Javascript
multiqueue.create(queueID [, interval][, limit]);
```

This will create a new queue with the specified queueID.

Argument | Type   | Description
---------|--------|-------------
queueID  | String | ID of the queue
interval | Number | Interval in milliseconds between each function in the queue _(default: `1000`)_
limit    | Number | How many times to retry a failing function before returning an error _(default: `1`)_


### Add
```Javascript
multiqueue.add(function, callback [, queueID]);
```

This will add a function to the specified queue.

Argument | Type     | Description
---------|----------|-------------
function | Function | Function to run. It takes one argument, `callback`, which should be called when the function has completed.
callback | Function | This will be called when the function has completed. It has the standard Node arguments `err` and `data`.
queueID  | String   | ID of the queue _(default: `'default'`)_


### Queue Properties

#### Set Interval
```Javascript
multiqueue.setInterval(interval [, queueID]);
```

This sets the interval of the specified queue

Argument | Type   | Description
---------|--------|-------------
interval | Number | Interval in milliseconds between each function in the queue
queueID  | String | ID of the queue _(default: `'default'`)_


#### Set Limit
```Javascript
multiqueue.setInterval(limit [, queueID]);
```

This sets the retry limit of the specified queue

Argument | Type   | Description
---------|--------|-------------
limit    | Number | How many times to retry a failing function before returning an error
queueID  | String | ID of the queue _(default: `'default'`)_


### Default Values

#### Set Default Interval
```Javascript
multiqueue.setDefaultInterval(interval);
```

This sets the default interval for new queues

Argument | Type   | Description
---------|--------|-------------
interval | Number | Interval in milliseconds between each function in the queue


#### Set Default Limit
```Javascript
multiqueue.setDefaultLimit(limit);
```

This sets the default limit for new queues

Argument | Type   | Description
---------|--------|-------------
limit    | Number | How many times to retry a failing function before returning an error


### Queues
```Javascript
multiqueue.queues
```

This will return an object containing information about the queues.

`console.log(multiq.queues);` will output (with only the `default` queue):

```Javascript
{
	default: {
		interval: 1000,
		length: 0,
		limit: 1,
		add: [Function],
		setInterval: [Function],
		setLimit: [Function]
	}
}
```

The functions in each queue object are the same as the main multiqueue functions of the same name, except that you don't need the queueID argument.

## Credits, copyright, etc
Created by me. Feel free to use this code, change it, do whatever you want with it, all I ask is that you let me know cause I'm interested in seeing my code being used by others. Pull requests are welcome, as are ideas for new features, and be sure to report any problems or bugs so that I can fix them.

This module is under development by me, and will be expanded as I see fit. I developed this because I needed this specific functionality so as the requirements grow and the project for which I need it expands, so will this module.