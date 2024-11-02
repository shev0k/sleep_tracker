const mongoose = require('mongoose');
const Challenge = require('../models/Challenge.js');
const Achievement = require('../models/Achievement.js');
const Item = require('../models/Item.js');
require('dotenv').config();

const seedChallenges = async () => {
    try {
        await mongoose.connect('mongodb://localhost:27017/sleep_tracker');
        console.log('Connected to MongoDB for seeding challenges.');

        await Challenge.deleteMany({});
        console.log('Existing challenges removed.');

        const nightOwlAchievement = await Achievement.findOne({ title: "Night Owl" });
        const meditationMasterAchievement = await Achievement.findOne({ title: "Meditation Master" });
        const bookwormAchievement = await Achievement.findOne({ title: "Bookworm" });
        const crawlWalkerAchievement = await Achievement.findOne({ title: "Crawl Walker" });

        const meditationBadgeItem = await Item.findOne({ name: "Meditation Badge" });
        const mysteryItem1 = await Item.findOne({ name: "Mystery Item 1" });
        const mysteryItem2 = await Item.findOne({ name: "Mystery Item 2" });

        const challenges = [
            {
                title: "No screen time 1 hour before bed",
                description: "Avoid using screens like phones, tablets, or computers 1 hour before bedtime.",
                reward: meditationBadgeItem
                    ? { type: "item", item: meditationBadgeItem._id }
                    : null,
                icon: "screen_lock_portrait",
                type: "time",
                duration: 1 * 60 * 60, // 1 hour in seconds
                achievement: nightOwlAchievement ? nightOwlAchievement._id : null,
            },
            {
                title: "Meditate for 10 minutes",
                description: "Spend at least 10 minutes meditating to relax your mind.",
                reward: mysteryItem1
                    ? { type: "item", item: mysteryItem1._id }
                    : null,
                icon: "self_improvement",
                type: "action",
                duration: 10 * 60, // 10 minutes in seconds
                achievement: meditationMasterAchievement ? meditationMasterAchievement._id : null,
            },
            {
                title: "Read a book for 30 minutes",
                description: "Read any book for at least 30 minutes.",
                reward: mysteryItem2
                    ? { type: "item", item: mysteryItem2._id }
                    : null,
                icon: "book",
                type: "time",
                duration: 30 * 60, // 30 minutes in seconds
                achievement: bookwormAchievement ? bookwormAchievement._id : null,
            },
            {
                title: "Walk 5000 steps",
                description: "Take at least 5000 steps today.",
                reward: { type: "points", points: 20 },
                icon: "directions_walk",
                type: "count",
                target: 5000,
                progress: 0,
                achievement: crawlWalkerAchievement ? crawlWalkerAchievement._id : null,
            },
        ];

        await Challenge.insertMany(challenges);
        console.log('Challenges seeded successfully.');

        mongoose.disconnect();
    } catch (error) {
        console.log('Error seeding challenges:', error);
    }
};

seedChallenges();