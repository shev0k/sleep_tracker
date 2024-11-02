const mongoose = require('mongoose');

const sleepDataSchema = new mongoose.Schema({
    duration: Number,
    sleepQualityScore: Number,
    averageHeartRate: Number,
    remSleepDurationPercent: Number,
    lightSleepDurationPercent: Number,
});

const SleepData = mongoose.model('SleepData', sleepDataSchema);

module.exports = SleepData;