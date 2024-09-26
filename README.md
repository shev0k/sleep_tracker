# NightBloom - Gamified Sleep Improvement App

[**Download the latest APK here**](https://github.com/shev0k/sleep_tracker/releases)

## Overview

**NightBloom** is a gamified sleep tracking app designed to help users improve their sleep habits through interactive and engaging experiences. Unlike traditional sleep apps that focus on data collection, NightBloom incorporates game mechanics, visual rewards, and daily challenges to keep users motivated while helping them achieve their sleep goals.

![NightBloom App Preview](https://raw.githubusercontent.com/shev0k/sleep_tracker/refs/heads/main/images/NightBloom_v1.png)

## Key Features

- **Virtual World Integration**: The user's sleep quality is reflected in a virtual world that evolves based on their progress. A good night’s sleep will lead to growth and vitality in the virtual environment, while poor sleep will slow progress.
  
- **Sleep Tracking**: The app integrates with phone sensors (e.g., accelerometer, gyroscope) and wearable devices (e.g., Fitbit, Apple Watch) to passively track sleep without manual input.
  
- **Daily Challenges**: Personalized challenges, such as “no screen time an hour before bed,” are issued daily to help improve sleep quality. Completing these challenges unlocks rewards within the virtual world.

## Technology Stack

- **Frontend**: Built using **Flutter**, enabling cross-platform mobile development and seamless interaction with device sensors.
  
- **Backend**: The backend is powered by **Node.js** with **MongoDB** for real-time data processing, analysis of sleep patterns, and integration of wearable device data.
  
- **Sensors & Wearables**: Integration with phone sensors and wearables for passive data collection to track movement, sleep phases, and heart rate.

## Target Audience

- **Primary Users**: Individuals looking to improve their sleep, particularly those motivated by game-like features and visual progress.
- **Secondary Users**: Healthcare professionals recommending sleep hygiene improvement tools for patients.
- **Gamification Enthusiasts**: Users motivated by progression systems, achievements, and leaderboards.

## Installation

1. Clone the repository:
   ```bash
   git clone https://github.com/shev0k/sleep_tracker.git
   ```

2. Install dependencies:
   ```bash
   flutter pub get
   ```

3. Run the app:
   ```bash
   flutter run
   ```

## Future Enhancements

- **Smart Home Device Integration**: Automate room temperature and lighting to create an ideal sleep environment.
- **Additional Wearable Support**: Expand integration with more wearable devices for deeper data insights.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
