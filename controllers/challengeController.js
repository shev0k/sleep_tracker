const Challenge = require('../models/Challenge');

// POST /challenges - Create a new challenge
const createChallenge = async (req, res) => {
    try {
        const { title, description, reward, achievement, type, target, duration } = req.body;

        const newChallenge = new Challenge({
            title,
            description,
            reward,
            achievement,
            type,
            target,
            duration,
        });

        const savedChallenge = await newChallenge.save();
        res.status(201).json(savedChallenge);
    } catch (error) {
        res.status(500).json({ message: 'Error creating challenge', error });
    }
};

// GET /challenges - Get all challenges
const getAllChallenges = async (req, res) => {
    try {
        const challenges = await Challenge.find();
        res.status(200).json(challenges);
    } catch (error) {
        res.status(500).json({ message: 'Error retrieving challenges', error });
    }
};

// GET /challenges/active - Get active challenges
const getActiveChallenges = async (req, res) => {
    try {
        const challenges = await Challenge.find({ isAccepted: true, isCompleted: false });
        res.status(200).json(challenges);
    } catch (error) {
        res.status(500).json({ message: 'Error retrieving active challenges', error });
    }
};

// GET /challenges/completed - Get completed challenges
const getCompletedChallenges = async (req, res) => {
    try {
        const challenges = await Challenge.find({ isCompleted: true });
        res.status(200).json(challenges);
    } catch (error) {
        res.status(500).json({ message: 'Error retrieving completed challenges', error });
    }
};

// PUT /challenges/:id - Update a challenge (e.g., accept, progress, complete)
const updateChallenge = async (req, res) => {
    const { id } = req.params;
    const updateData = req.body;

    try {
        const updatedChallenge = await Challenge.findByIdAndUpdate(id, updateData, { new: true });
        if (updatedChallenge) {
            res.status(200).json(updatedChallenge);
        } else {
            res.status(404).json({ message: 'Challenge not found' });
        }
    } catch (error) {
        res.status(500).json({ message: 'Error updating challenge', error });
    }
};

// DELETE /challenges/:id - Delete a challenge
const deleteChallenge = async (req, res) => {
    const { id } = req.params;

    try {
        const deletedChallenge = await Challenge.findByIdAndDelete(id);
        if (deletedChallenge) {
            res.status(200).json({ message: 'Challenge deleted successfully' });
        } else {
            res.status(404).json({ message: 'Challenge not found' });
        }
    } catch (error) {
        res.status(500).json({ message: 'Error deleting challenge', error });
    }
};

// GET /challenges/:id - Get a challenge by id
const getChallengeById = async (req, res) => {
    const { id } = req.params;

    try {
        const getChallengeById = await Challenge.findById(id);
        if (getChallengeById) {
            res.status(200).json({ message: 'Challenge retrieved successfully' });
        } else {
            res.status(404).json({ message: 'Challenge not found' });
        }
    } catch (error) {
        res.status(500).json({ message: 'Error retrieving challenge', error });
    }
}

module.exports = {
    createChallenge,
    getAllChallenges,
    getActiveChallenges,
    getCompletedChallenges,
    updateChallenge,
    deleteChallenge,
    getChallengeById,
};