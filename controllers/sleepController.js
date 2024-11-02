const SleepData = require('../models/SleepData');

const { 
    calculateSleepQuality,
    calculateAverageHeartRate,
    calculateRemSleep,
    calculateLightSleep
} = require('../business/sleepManager');

// POST /sleep - Add sleep data
const createSleepData = async (req, res) => {
    try {
        const { accelerometerReadings, heartRateReadings, duration } = req.body;

        const sleepEntry = new SleepData({
            duration,
            sleepQualityScore: calculateSleepQuality(accelerometerReadings, heartRateReadings, duration),
            averageHeartRate: calculateAverageHeartRate(heartRateReadings),
            remSleepDurationPercent: calculateRemSleep(accelerometerReadings),
            lightSleepDurationPercent: calculateLightSleep(accelerometerReadings),
        });

        const savedSleepEntry = await sleepEntry.save();
        res.status(201).json(savedSleepEntry);
    } catch (error) {
        res.status(500).json({ message: 'Error saving sleep data', error });
    }
}

// GET /sleep/:userId - Get sleep data for a user
const getSleepDataByUserId = async (req, res) => {
    const { userId } = req.params;

    try {
        const userSleepData = await SleepData.find({ userId });
        if (userSleepData.length > 0) {
            res.json(userSleepData);
        } else {
            res.status(404).json({ message: 'No sleep data found for this user' });
        }
    } catch (error) {
        res.status(500).json({ message: 'Error retrieving sleep data', error });
    }
}

// GET /sleep - Get all existing sleep data
const getAllSleepData = async (req, res) => {
    try {
        const allSleepData = await SleepData.find();
        res.status(200).json(allSleepData);
    } catch (error) {
        res.status(500).json({ message: 'Error retrieving all sleep data', error });
    }
};

// GET /sleep/totalScore - Get total sleep quality score
const getTotalScore = async (req, res) => {
    try {
        // Retrieve all sleep data records
        const allSleepData = await SleepData.find();

        // Calculate total score by summing sleepQualityScore from each record
        const totalScore = allSleepData.reduce((sum, record) => sum + record.sleepQualityScore, 0);

        // Return the total score as JSON
        res.status(200).json({ totalScore });
    } catch (error) {
        res.status(500).json({ message: 'Error calculating total score', error });
    }
};

module.exports = {
    createSleepData,
    getSleepDataByUserId,
    getAllSleepData,
    getTotalScore
};