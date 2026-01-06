# Fylo - Social Activities Mobile App

A Flutter mobile application for discovering and joining social activities, based on a modern social media UI design.

## Features

- **Home Feed**: Browse upcoming activities and events with beautiful cards
- **Pool**: Social feed with posts from other users, related activities, and engagement features
- **Notifications**: Stay updated with activity reminders, new followers, and interactions
- **Messages**: Chat with other users (coming soon)
- **Profile**: View and manage your profile, activities, and settings

## Tech Stack

- **Flutter**: Cross-platform mobile framework
- **Google Fonts**: Beautiful typography with Inter font
- **Lucide Icons**: Modern icon library
- **Cached Network Image**: Efficient image loading and caching

## Getting Started

### Prerequisites

- Flutter SDK (3.9.2 or higher)
- Dart SDK
- Android Studio / Xcode for mobile development

### Installation

1. Clone the repository
2. Install dependencies:
```bash
flutter pub get
```

3. Run the app:
```bash
flutter run
```

## Project Structure

```
lib/
├── main.dart                 # App entry point with bottom navigation
├── models/                   # Data models
│   ├── event.dart
│   ├── post.dart
│   └── notification.dart
├── screens/                  # Main screens
│   ├── home_screen.dart
│   ├── pool_screen.dart
│   ├── notifications_screen.dart
│   ├── messages_screen.dart
│   └── profile_screen.dart
├── widgets/                  # Reusable UI components
│   ├── event_card.dart
│   ├── post_card.dart
│   └── gradient_header.dart
└── data/                     # Sample data
    └── sample_data.dart
```

## Design

This app is based on a Figma social media UI design, adapted for mobile with:
- Gradient headers with animated backgrounds
- Card-based layouts for events and posts
- Modern color scheme (Indigo, Purple, Pink gradients)
- Smooth animations and transitions
- Clean, minimalist interface

## License

This project is private and not for distribution.
