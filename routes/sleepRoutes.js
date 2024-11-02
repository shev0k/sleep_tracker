const express = require('express');
const router = express.Router();
const sleepController = require('../controllers/sleepController.js');

router.post('/sleep', sleepController.createSleepData);
router.get('/sleep', sleepController.getAllSleepData);
router.get('/sleep/totalScore', sleepController.getTotalScore);
router.get('/sleep/:userId', sleepController.getSleepDataByUserId);

module.exports = router;