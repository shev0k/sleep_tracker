const express = require('express');
const cors = require('cors');
const connectToMongoDB = require('./db');
//Declare the routes to be used
const sleepRoutes = require('./routes/sleepRoutes.js');
const challengeRoutes = require('./routes/challengeRoutes.js');
const progressRoutes = require('./routes/progressRoutes.js');
require('dotenv').config();

const app = express();
const PORT = process.env.PORT || 8080;

connectToMongoDB();

app.use(cors({
    origin: '*',
    methods: ['GET', 'POST', 'PUT', 'DELETE'],
    allowedHeaders: ['Content-Type', 'Authorization']
}));
app.use(express.json());

// Register the use of the routes here
app.use('/api', sleepRoutes);
app.use('/api', challengeRoutes);
app.use('/api', progressRoutes);

app.get('/', (req, res) => {
    res.send('Sleep Tracker Backend Running');
});

// Logging to check if server has started
app.listen(PORT, () => {
    console.log(`Server is running on port ${PORT}`);
});

module.exports = {
    connectToMongoDB
}