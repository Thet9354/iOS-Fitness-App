# 🏋️‍♂️ Fitness App

Welcome to **Fitness App** – your all-in-one Swift-powered fitness companion!  
Track your workouts, compete with friends on leaderboards, monitor your health statistics, and manage your fitness journey effortlessly.

## ✨ Features

- **HomeView**: Get a quick overview of your fitness journey.
- **HealthKit Integration**: Sync health and workout data directly from your device.
- **HealthManager**: Safely manage permissions and health data access.
- **SwiftCharts & ChartsView**: Visualize workout and activity trends over:
  - Weeks
  - Months
  - 3 Months
  - Year
  - Year-to-date
- **Leaderboards**: Compete with friends and users — view points differences and climb the ranks!
- **ProfileView**: Customize your profile and view your activity history.
- **Firebase Integration**: Securely store and retrieve user data.
- **Swift Concurrency**: Smooth and efficient asynchronous operations.
- **Robust Error Handling**: Ensures the app remains stable even when errors occur.

---

## 🛠️ Tech Stack

- **Swift**
- **SwiftUI**
- **HealthKit**
- **Swift Charts**
- **Firebase Firestore**
- **Firebase Authentication**
- **Swift Concurrency (async/await)**

---

## 📸 Screenshots

| Home View | Statistic Screen |
| :---: | :---: |
| ![HomeView Screenshot](https://github.com/Thet9354/iOS-Fitness-App/blob/main/IMG_4870.PNG) | ![Statistic Screen Screenshot](https://github.com/Thet9354/iOS-Fitness-App/blob/main/IMG_4871.PNG) |

| Leaderboard View | Profile View |
| :---: | :---: |
| ![Leaderboard Screenshot](https://github.com/Thet9354/iOS-Fitness-App/blob/main/IMG_4873.PNG) | ![ProfileView Screenshot](https://github.com/Thet9354/iOS-Fitness-App/blob/main/IMG_4874.PNG) |

---

## 🔥 How It Works

1. On launch, users are greeted with the **HomeView** summarizing recent activity.
2. **HealthKit** syncs real-time fitness and health metrics.
3. **ChartsView** displays intuitive graphs to visualize activity over different time spans.
4. **Leaderboards** encourage competition among users.
5. All user activities and stats are synced with **Firebase** for persistence and scalability.
6. Seamless navigation across the app with modern Swift concurrency handling loading and refreshing tasks.

---

## 🚀 Getting Started

1. **Clone the repository**:
   ```bash
   git clone https://github.com/yourusername/FitnessApp.git
   ```
2. **Open the project in Xcode**.
3. **Ensure you have a valid Firebase project** set up, and update `GoogleService-Info.plist` accordingly.
4. **Enable HealthKit** capabilities in your Xcode project settings.
5. **Build & Run** on a physical device (HealthKit access is not available on simulators).

---

## 📚 Requirements

- Xcode 15 or newer
- iOS 16.0+
- Swift 5.7+
- Firebase Account (for Firestore and Authentication)

---

## 🧹 TODO (Optional Enhancements)

- Add workout logging feature
- Include achievements and badges for milestones
- Notifications for fitness goals
- Dark mode support
- Social sharing of achievements

---

## 🤝 Contributing

We welcome contributions!  
Feel free to submit a pull request or open an issue to discuss new features or bug fixes.

---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

---

## 🙌 Acknowledgements

- Apple HealthKit
- Swift Charts Documentation
- Firebase Documentation
