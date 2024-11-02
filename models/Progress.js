const mongoose = require('mongoose');

const ProgressSchema = new mongoose.Schema({
    achievements: [{
        type: mongoose.Schema.Types.ObjectId,
        ref: 'Achievement',
        default: [],
        validate: {
            validator: async function(v) {
                return await mongoose.model('Achievement').findById(v);
            },
            message: props => `Achievement with id ${props.value} does not exist!`
        }
    }],
    items: [{
        type: mongoose.Schema.Types.ObjectId,
        ref: 'Item',
        default: [],
        validate: {
            validator: async function(v) {
                return await mongoose.model('Item').findById(v);
            },
            message: props => `Item with id ${props.value} does not exist!`
        }
    }],
    // Optionally, you can track additional progress metrics like points
    points: {
        type: Number,
        default: 0,
    },
}, { timestamps: true });

module.exports = mongoose.model('Progress', ProgressSchema);