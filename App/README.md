# 🌍 Culture Quest

**Culture Quest** is an interactive mobile application that celebrates African culture by showcasing traditional stories, historical events, significant cultural elements like Kente cloth, and the lives of renowned artisans. The app is designed to educate and entertain users through audio stories, vibrant visuals, and insightful content.

---

## 📱 Features

- 🎧 **Audio Stories** – Listen to folklore such as Anansi the clever spider and other African legends.
- 🧵 **Cultural Highlights** – Discover the history and meaning behind iconic elements like Ghanaian Kente cloth.
- 👩🏾‍🎨 **Artisan Profiles** – Explore biographies of legendary African artisans and their craft.
- 📅 **Events** – Stay informed about cultural events and learn their historical significance.

---

## 🧰 Tech Stack

### **Frontend: Flutter**

- Dart
- Flutter Widgets (Stateful, Stateless)
- Custom screens: `ArtisansScreen`, `StoriesScreen`, `EventsScreen`, etc.

### **Backend: Next.js**

- API routes serve data to the Flutter app
- RESTful endpoints for stories, events, artisans, and users
- Swagger used for API documentation and testing

---

## 🗂 Folder Structure

```bash
lib/
├── main.dart
├── screens/
│   ├── get_started_screen.dart
│   ├── login_screen.dart
│   ├── signup_screen.dart
│   ├── home_screen.dart
│   ├── welcome_screen.dart
│   ├── profile_screen.dart
│   ├── artisans_screen.dart
│   ├── artisan_profile_screen.dart
│   ├── stories_screen.dart
│   ├── story_details_screen.dart
│   ├── events_screen.dart
│   └── event_details_screen.dart
├── models/
│   └── [Add your Dart model classes here]
├── widgets/
│   └── [Reusable UI components]
assets/
└── images/
    └── artisan1.png


```
