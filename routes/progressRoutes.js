const express = require('express');
const router = express.Router();
const progressController = require('../controllers/progressController.js');

// Get current progress
router.get('/progress', progressController.getProgress);

// Add an achievement
router.post('/progress/achievements', progressController.addAchievement);

// Add an item
router.post('/progress/items', progressController.addItem);

// Route to Populate Progress
router.post('/progress/populate', progressController.populateProgress);

// Complete a challenge
router.put('/challenges/:id/complete', progressController.completeChallenge);

// Remove an item
router.delete('/progress/items/:id', progressController.removeItem);

// Remove an achievement
router.delete('/progress/achievements/:id', progressController.removeAchievement);

module.exports = router;