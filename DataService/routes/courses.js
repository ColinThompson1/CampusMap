var express = require('express');
var router = express.Router();

/* GET courses listing. */
router.get('/:courseId', function(req, res, next) {
    res.sendFile(`course-data/courses-${req.params.courseId}.json`, {root: './public'})
});

module.exports = router;