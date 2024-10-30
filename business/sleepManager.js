const calculateSleepQuality = (accelerometerData, heartRateData, duration) => {
    if (!Array.isArray(accelerometerData) || accelerometerData.some(arr => !Array.isArray(arr) || arr.length !== 3)) {
        throw new TypeError('Invalid accelerometer data format. Expected an array of [x, y, z] arrays.');
    }

    const avgMovement = accelerometerData.reduce((sum, arr) => {
        const magnitude = Math.sqrt(arr[0] ** 2 + arr[1] ** 2 + arr[2] ** 2); // Use only x, y, z values
        return sum + magnitude;
    }, 0) / accelerometerData.length;

    const avgHeartRate = calculateAverageHeartRate(heartRateData);
    const remSleepPercent = calculateRemSleep(accelerometerData);
    const lightSleepPercent = calculateLightSleep(accelerometerData);

    // Weighting factors for each component
    const movementWeight = 0.3;
    const heartRateWeight = 0.3;
    const remSleepWeight = 0.2;
    const lightSleepWeight = 0.2;

    // Calculate score based on thresholds and weights
    const movementScore = avgMovement < 1.5 ? 100 : avgMovement < 2.5 ? 75 : 50;
    const heartRateScore = avgHeartRate < 60 ? 100 : avgHeartRate < 70 ? 75 : 50;
    const remSleepScore = remSleepPercent >= 20 ? 100 : remSleepPercent >= 15 ? 75 : 50;
    const lightSleepScore = lightSleepPercent >= 50 ? 100 : lightSleepPercent >= 30 ? 75 : 50;

    // Weighted total sleep quality score
    const qualityScore = 
    (movementScore * movementWeight) +
    (heartRateScore * heartRateWeight) +
    (remSleepScore * remSleepWeight) +
    (lightSleepScore * lightSleepWeight);

    return qualityScore;
};

const calculateAverageHeartRate = (heartRateReadings) => {
    const totalHeartRate = heartRateReadings.reduce((sum, reading) => sum + reading, 0); // Use only heart rate value
    return totalHeartRate / heartRateReadings.length;
};

const calculateRemSleep = (accelerometerReadings) => {
    const movementThreshold = 1.5;
    const remPeriods = accelerometerReadings.filter(arr => {
        const magnitude = Math.sqrt(arr[0] ** 2 + arr[1] ** 2 + arr[2] ** 2);
        return magnitude < movementThreshold; 
    });
    return (remPeriods.length / accelerometerReadings.length) * 100; // % of REM based on low movement periods
};

const calculateLightSleep = (accelerometerReadings) => {
    const movementThreshold = 2.5;
    const lightPeriods = accelerometerReadings.filter(arr => {
        const magnitude = Math.sqrt(arr[0] ** 2 + arr[1] ** 2 + arr[2] ** 2);
        return magnitude >= movementThreshold; 
    });
    return (lightPeriods.length / accelerometerReadings.length) * 100; // % of Light sleep based on light movement periods
};

module.exports = {
    calculateSleepQuality,
    calculateAverageHeartRate,
    calculateRemSleep,
    calculateLightSleep
};