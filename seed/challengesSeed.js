const mongoose = require('mongoose');
const Challenge = require('../models/Challenge.js');
require('dotenv').config();

const challenges = [
    {
        title: "No screen time 1 hour before bed",
        description: "Avoid using screens like phones, tablets, or computers 1 hour before bedtime.",
        reward: { type: "points", value: 10 },
        icon: "screen_lock_portrait",
        type: "time",
        duration: 1 * 60 * 60, // 1 hour in seconds
        achievement: {
            title: "Night Owl",
            description: "Avoided screen time before bed",
        },
    },
    {
        title: "Meditate for 10 minutes",
        description: "Spend at least 10 minutes meditating to relax your mind.",
        reward: { type: "item", value: "Meditation Badge" },
        icon: "self_improvement",
        type: "action",
        duration: 10 * 60, // 10 minutes in seconds
    },
    {
        title: "Read a book for 30 minutes",
        description: "Read any book for at least 30 minutes.",
        reward: { type: "points", value: 15 },
        icon: "book",
        type: "time",
        duration: 30 * 60, // 30 minutes in seconds
        achievement: {
            title: "Bookworm",
            description: "Read for 30 minutes",
        },
    },
    {
        title: "Walk 5000 steps",
        description: "Take at least 5000 steps today.",
        reward: { type: "points", value: 20 },
        icon: "directions_walk",
        type: "count",
        target: 5000,
        progress: 0,
        achievement: {
            title: "Crawl Walker",
            description: "Walked 5000 steps",
        },
    },
];

const seedChallenges = async () => {
    try {
        await mongoose.connect('mongodb://localhost:27017/sleep_tracker');
        console.log('Connected to MongoDB for seeding challenges.');

        await Challenge.deleteMany({});
        console.log('Existing challenges removed.');

        await Challenge.insertMany(challenges);
        console.log('Challenges seeded successfully.');

        mongoose.disconnect();
    } catch (error) {
        console.log('Error seeding challenges:', error);
    }
};

seedChallenges();