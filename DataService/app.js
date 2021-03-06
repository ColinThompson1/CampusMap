var express = require('express');
var path = require('path');
var cookieParser = require('cookie-parser');
var logger = require('morgan');

var coursesRouter = require('./routes/courses');
var termsRouter = require('./routes/terms');

var app = express();

app.use(logger('dev'));
app.use(express.json());
app.use(express.urlencoded({ extended: false }));
app.use(cookieParser());
app.use(express.static(path.join(__dirname, 'public')));

app.use('/courses', coursesRouter);
app.use('/terms', termsRouter);

module.exports = app;
