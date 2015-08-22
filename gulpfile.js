var gulp = require('gulp'),
	coffee = require('gulp-coffee');

gulp.task('compile', function(){
	var folders = ['', '/test'];

	for(var i = 0; i < folders.length; i++){
		folder = folders[i];

		gulp.src('./src' + folder + '/*.coffee')
			.pipe(coffee({bare: true}))
			.pipe(gulp.dest('.' + folder))
	}
});

gulp.task('default', ['compile'], function() {
	gulp.watch('./src/**/*.coffee', ['compile']);
});