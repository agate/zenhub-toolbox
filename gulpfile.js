var pkg = require('./package.json');
var gulp = require('gulp');
var coffee = require('gulp-coffee');
var concat = require('gulp-concat');
var uglify = require('gulp-uglify');
var header = require('gulp-header');

var PATHS = {
  scripts: {
    src: [ 'src/*.coffee' ],
    dest: 'dest'
  },
};
var BANNER = [
  "// ==UserScript==",
  "// @name         ZenHub Toolbox",
  "// @namespace    https://agate.github.com",
  "// @version      <%= pkg.version %>",
  "// @description  <%= pkg.description %>",
  "// @author       <%= pkg.author %>",
  "// @match        https://github.com/*",
  "// @grant        none",
  "// ==/UserScript==",
  "\n",
].join("\n")

gulp.task('scripts', function() {
  return gulp
  .src(PATHS.scripts.src)
  .pipe(coffee())
  .pipe(header(BANNER, {pkg:pkg}))
  .pipe(concat(pkg.name+".user.js"))
  .pipe(gulp.dest(PATHS.scripts.dest));
});

gulp.task('watch', function() {
  gulp.watch(PATHS.scripts.src, ['scripts']);
});

gulp.task('default', [
  'watch',
  'scripts',
]);
