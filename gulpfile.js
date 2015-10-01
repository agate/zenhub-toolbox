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
  "// @namespace    me.honghao",
  "// @version      0.1",
  "// @description  Tools for ZenHub",
  "// @author       Hao Hong",
  "// @match        https://github.com/*",
  "// @grant        none",
  "// ==/UserScript==",
  "\n",
].join("\n")


gulp.task('scripts', function() {
  return gulp
  .src(PATHS.scripts.src)
  .pipe(coffee())
  .pipe(header(BANNER))
  .pipe(concat('all.min.js'))
  .pipe(gulp.dest(PATHS.scripts.dest));
});

gulp.task('watch', function() {
  gulp.watch(PATHS.scripts.src, ['scripts']);
});

gulp.task('default', [
  'watch',
  'scripts',
]);
