var express = require('express');
var router = express.Router();

/* GET courses listing. */
router.get('/', function(req, res, next) {
    res.sendFile(`course-data/terms.json`, {root: './public'})
});

module.exports = router;