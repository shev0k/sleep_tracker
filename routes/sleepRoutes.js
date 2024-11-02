const express = require('express');
const router = express.Router();
const sleepController = require('../controllers/sleepController.js');

router.post('/sleep', sleepController.createSleepData);
router.get('/sleep/:userId', sleepController.getSleepDataByUserId);
router.get('/sleep', sleepController.getAllSleepData);

module.exports = router;