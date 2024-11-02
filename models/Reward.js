// models/Reward.js

const mongoose = require('mongoose');

const RewardSchema = new mongoose.Schema({
    type: {
        type: String,
        enum: ['points', 'item'],
        required: true,
    },
    points: {
        type: Number,
        required: function() { return this.type === 'points'; },
    },
    item: {
        type: mongoose.Schema.Types.ObjectId,
        ref: 'Item',
        required: function() { return this.type === 'item'; },
    },
}, { _id: false }); // Prevents creating a separate _id for the subdocument

module.exports = RewardSchema;
