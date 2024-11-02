const mongoose = require('mongoose');

const AchievementSchema = new mongoose.Schema({
    title: { type: String, required: true },
    description: { type: String, required: true },
});

const RewardSchema = new mongoose.Schema({
    type: { type: String, enum: ['points', 'item'], required: true },
    value: { type: mongoose.Schema.Types.Mixed, required: true }, // Can be Number or String based on type
});

const ChallengeSchema = new mongoose.Schema({
    title: { type: String, required: true },
    description: { type: String, required: true },
    reward: { type: RewardSchema, required: true },
    achievement: { type: AchievementSchema }, // Optional
    type: { type: String, enum: ['time', 'action', 'count'], required: true },
    target: { type: Number }, // For 'count' type
    duration: { type: Number }, // In seconds, for 'time' or 'action' types
    isAccepted: { type: Boolean, default: false },
    isCompleted: { type: Boolean, default: false },
    progress: { type: Number, default: 0 }, // For 'count' type
    startTime: { type: Date }, // When the challenge was accepted
    timer: { type: Date }, // Could be used to track remaining time
}, { timestamps: true });

module.exports = mongoose.model('Challenge', ChallengeSchema);