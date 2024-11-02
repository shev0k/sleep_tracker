const Progress = require('../models/Progress.js');
const Achievement = require('../models/Achievement.js');
const Item = require('../models/Item.js');
const Challenge = require('../models/Challenge.js');

// Populate Progress Based on Completed Challenges
const populateProgress = async (req, res) => {
    try {
        // Fetch all completed challenges and populate rewards and achievements
        const completedChallenges = await Challenge.find({ isCompleted: true })
            .populate('reward.item')
            .populate('achievement'); // Populate the separate achievement field

        if (!completedChallenges || completedChallenges.length === 0) {
            return res.status(200).json({ message: 'No completed challenges found. Progress remains unchanged.' });
        }

        // Initialize arrays to collect rewards
        const achievementsToAdd = [];
        const itemsToAdd = [];
        let pointsToAdd = 0;

        // Iterate over completed challenges to extract rewards
        completedChallenges.forEach(challenge => {
            // Handle reward types 'points' and 'item'
            if (challenge.reward.type === 'points' && challenge.reward.points) {
                pointsToAdd += challenge.reward.points;
            } else if (challenge.reward.type === 'item' && challenge.reward.item) {
                itemsToAdd.push(challenge.reward.item._id);
            }

            // Handle separate achievement field
            if (challenge.achievement) {
                achievementsToAdd.push(challenge.achievement._id);
            }
        });

        // Fetch the Progress document (create if it doesn't exist)
        let progress = await Progress.findOne();
        if (!progress) {
            progress = new Progress({
                achievements: [],
                items: [],
                points: 0,
            });
        }

        // Add achievements (avoid duplicates)
        achievementsToAdd.forEach(achievementId => {
            if (!progress.achievements.includes(achievementId)) {
                progress.achievements.push(achievementId);
            }
        });

        // Add items (avoid duplicates)
        itemsToAdd.forEach(itemId => {
            if (!progress.items.includes(itemId)) {
                progress.items.push(itemId);
            }
        });

        // Add points
        progress.points += pointsToAdd;

        // Save the updated Progress document
        await progress.save();

        // Populate the achievements and items for the response
        await progress.populate(['achievements', 'items']); // Corrected populate

        res.status(200).json({
            message: 'Progress populated successfully.',
            progress,
            addedAchievements: achievementsToAdd,
            addedItems: itemsToAdd,
            addedPoints: pointsToAdd,
        });
    } catch (error) {
        console.error('Error populating progress:', error);
        res.status(500).json({ message: 'Error populating progress', error: error.message }); // Enhanced error message
    }
};

// GET /progress - Retrieve current progress
const getProgress = async (req, res) => {
    try {
        // Assuming a single progress document (for single user)
        let progress = await Progress.findOne()
            .populate('achievements')
            .populate('items');

        if (!progress) {
            // If no progress exists, create one
            progress = new Progress({
                achievements: [],
                items: [],
                points: 0,
            });
            await progress.save();
        }

        res.status(200).json(progress);
    } catch (error) {
        res.status(500).json({ message: 'Error fetching progress', error });
    }
};

// POST /progress/achievements - Add an achievement
const addAchievement = async (req, res) => {
    const { achievementId } = req.body;

    try {
        const achievement = await Achievement.findById(achievementId);
        if (!achievement) {
            return res.status(404).json({ message: 'Achievement not found' });
        }

        let progress = await Progress.findOne();
        if (!progress) {
            progress = new Progress({
                achievements: [achievementId],
                items: [],
            });
        } else {
            if (progress.achievements.includes(achievementId)) {
                return res.status(400).json({ message: 'Achievement already unlocked' });
            }
            progress.achievements.push(achievementId);
        }

        await progress.save();
        progress = await progress.populate('achievements').populate('items');

        res.status(200).json(progress);
    } catch (error) {
        res.status(500).json({ message: 'Error adding achievement', error });
    }
};

// POST /progress/items - Add an item
const addItem = async (req, res) => {
    const { itemId } = req.body;

    try {
        const item = await Item.findById(itemId);
        if (!item) {
            return res.status(404).json({ message: 'Item not found' });
        }

        let progress = await Progress.findOne();
        if (!progress) {
            progress = new Progress({
                achievements: [],
                items: [itemId],
            });
        } else {
            if (progress.items.includes(itemId)) {
                return res.status(400).json({ message: 'Item already obtained' });
            }
            progress.items.push(itemId);
        }

        await progress.save();
        progress = await progress.populate('achievements').populate('items');

        res.status(200).json(progress);
    } catch (error) {
        res.status(500).json({ message: 'Error adding item', error });
    }
};

// DELETE /progress/items/:id - Remove an item
const removeItem = async (req, res) => {
    const { id } = req.params;

    try {
        let progress = await Progress.findOne();
        if (!progress) {
            return res.status(404).json({ message: 'Progress not found' });
        }

        if (!progress.items.includes(id)) {
            return res.status(404).json({ message: 'Item not found in progress' });
        }

        progress.items = progress.items.filter(itemId => itemId.toString() !== id);

        await progress.save();
        progress = await progress.populate('achievements').populate('items');

        res.status(200).json(progress);
    } catch (error) {
        res.status(500).json({ message: 'Error removing item', error });
    }
};

// DELETE /progress/achievements/:id - Remove an achievement
const removeAchievement = async (req, res) => {
    const { id } = req.params;

    try {
        let progress = await Progress.findOne();
        if (!progress) {
            return res.status(404).json({ message: 'Progress not found' });
        }

        if (!progress.achievements.includes(id)) {
            return res.status(404).json({ message: 'Achievement not found in progress' });
        }

        progress.achievements = progress.achievements.filter(achId => achId.toString() !== id);

        await progress.save();
        progress = await progress.populate('achievements').populate('items');

        res.status(200).json(progress);
    } catch (error) {
        res.status(500).json({ message: 'Error removing achievement', error });
    }
};

const completeChallenge = async (req, res) => {
    const { id } = req.params;

    try {
        const challenge = await Challenge.findById(id)
            .populate('reward.item')
            .populate('achievement'); // Populate the separate achievement field

        if (!challenge) {
            return res.status(404).json({ message: 'Challenge not found' });
        }

        if (challenge.isCompleted) {
            return res.status(400).json({ message: 'Challenge already completed' });
        }

        // Mark as completed
        challenge.isCompleted = true;
        await challenge.save();

        // Unlock the reward
        let progress = await Progress.findOne();
        if (!progress) {
            progress = new Progress({
                achievements: [],
                items: [],
                points: 0,
            });
        }

        // Handle reward types 'points' and 'item'
        if (challenge.reward.type === 'points' && challenge.reward.points) {
            progress.points += challenge.reward.points;
        } else if (challenge.reward.type === 'item' && challenge.reward.item) {
            if (!progress.items.includes(challenge.reward.item._id)) {
                progress.items.push(challenge.reward.item._id);
            }
        }

        // Handle separate achievement field
        if (challenge.achievement) {
            if (!progress.achievements.includes(challenge.achievement._id)) {
                progress.achievements.push(challenge.achievement._id);
            }
        }

        await progress.save();

        // Populate the achievements and items for the response
        await progress.populate(['achievements', 'items']); // Corrected populate

        res.status(200).json({ message: 'Challenge completed successfully', challenge, progress });
    } catch (error) {
        console.error('Error completing challenge:', error);
        res.status(500).json({ message: 'Error completing challenge', error: error.message }); // Enhanced error message
    }
};

module.exports = {
    getProgress,
    addAchievement,
    addItem,
    removeItem,
    removeAchievement,
    completeChallenge,
    populateProgress,
};