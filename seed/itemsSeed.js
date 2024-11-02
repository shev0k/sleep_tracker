const mongoose = require('mongoose');
const Item = require('../models/Item.js');
require('dotenv').config();

const items = [
    {
        name: "Meditation Badge",
        icon: "self_improvement",
    },
    {
        name: "New Plant",
        icon: "local_florist",
    },
    {
        name: "Watering Can",
        icon: "water",
    },
    {
        name: "Fertilizer",
        icon: "eco",
    },
    {
        name: "Garden Shovel",
        icon: "shovel",
    },
    {
        name: "Irrigation System",
        icon: "water_drop",
    },
    {
        name: "Mystery Item 1",
        icon: "lock",
    },
    {
        name: "Mystery Item 2",
        icon: "lock",
    },
];

const seedItems = async () => {
    try {
        await mongoose.connect('mongodb://localhost:27017/sleep_tracker');
        console.log('Connected to MongoDB for seeding challenges.');

        await Item.deleteMany({});
        console.log('Existing items removed.');

        await Item.insertMany(items);
        console.log('Items seeded successfully.');

        mongoose.disconnect();
    } catch (error) {
        console.log('Error seeding items:', error);
    }
};

seedItems();