const mongoose = require('mongoose');

const AchievementSchema = new mongoose.Schema({
    title: {
        type: String,
        required: true,
        unique: true, // Ensures each achievement is unique
    },
    description: {
        type: String,
        required: true,
    },
    icon: {
        type: String, // Name or path of the icon
        required: false,
    },
});

module.exports = mongoose.model('Achievement', AchievementSchema);