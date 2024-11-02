const mongoose = require('mongoose');

const ItemSchema = new mongoose.Schema({
    name: {
        type: String,
        required: true,
        unique: true, // Ensures each item is unique
    },
    icon: {
        type: String, // Name or path of the icon
        required: false,
    },
});

module.exports = mongoose.model('Item', ItemSchema);