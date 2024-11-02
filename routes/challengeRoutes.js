const express = require('express');
const router = express.Router();
const challengeController = require('../controllers/challengeController.js');

// Create a new challenge
router.post('/challenges', challengeController.createChallenge);

// Get all challenges
router.get('/challenges', challengeController.getAllChallenges);

// Get active challenges
router.get('/challenges/active', challengeController.getActiveChallenges);

// Get completed challenges
router.get('/challenges/completed', challengeController.getCompletedChallenges);

// Update a challenge
router.put('/challenges/:id', challengeController.updateChallenge);

// Delete a challenge
router.delete('/challenges/:id', challengeController.deleteChallenge);

// Get challenge by id
router.get('/challenges/:id', challengeController.getChallengeById);

module.exports = router;