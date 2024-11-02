const express = require('express');
const cors = require('cors');
const connectToMongoDB = require('./db');

const app = express();
const PORT = process.env.PORT || 8080;

connectToMongoDB();

app.use(cors({
    origin: '*',
    methods: ['GET', 'POST', 'PUT', 'DELETE'],
    allowedHeaders: ['Content-Type', 'Authorization']
}));
app.use(express.json());

const sleepRoutes = require('./routes/sleepRoutes');
app.use('/api', sleepRoutes);

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