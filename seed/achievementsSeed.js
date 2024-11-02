const mongoose = require('mongoose');
const Achievement = require('../models/Achievement.js');
require('dotenv').config();

const achievements = [
    {
        title: "Night Owl",
        description: "Avoided screen time before bed.",
        icon: "bedtime",
    },
    {
        title: "Meditation Master",
        description: "Completed 10 minutes of meditation.",
        icon: "spa",
    },
    {
        title: "Bookworm",
        description: "Read for 30 minutes.",
        icon: "book",
    },
    {
        title: "Crawl Walker",
        description: "Walked 5000 steps.",
        icon: "directions_walk",
    },
];

const seedAchievements = async () => {
    try {
        await mongoose.connect('mongodb://localhost:27017/sleep_tracker');
        console.log('Connected to MongoDB for seeding challenges.');

        await Achievement.deleteMany({});
        console.log('Existing achievements removed.');

        await Achievement.insertMany(achievements);
        console.log('Achievements seeded successfully.');

        mongoose.disconnect();
    } catch (error) {
        console.log('Error seeding achievements:', error);
    }
};

seedAchievements();