const mongoose = require('mongoose');

function connectToMongoDB() {
  mongoose.connect('mongodb://localhost:27017/sleep_tracker')
    .then(() => console.log('Connected to MongoDB'))
    .catch((error) => console.error('MongoDB connection error:', error));
}

module.exports = connectToMongoDB