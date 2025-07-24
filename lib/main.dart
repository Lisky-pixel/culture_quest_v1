import 'package:flutter/material.dart';
import 'screens/welcome_screen.dart';
import 'screens/login_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/get_started_screen.dart';
import 'screens/home_screen.dart';
import 'screens/events_screen.dart';
import 'screens/event_details_screen.dart';
import 'screens/stories_screen.dart';
import 'screens/story_details_screen.dart';
import 'screens/artisans_screen.dart';
import 'screens/artisan_profile_screen.dart';
import 'screens/profile_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Culture Quest',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const GetStartedScreen(),
        '/welcome': (context) => const WelcomeScreen(),
        '/login': (context) => const LoginScreen(),
        '/signup': (context) => const SignupScreen(),
        '/home': (context) => const HomeScreen(),
        '/events': (context) => const EventsScreen(),
        '/event_details': (context) => const EventDetailsScreen(),
        '/stories': (context) => const StoriesScreen(),
        '/story_details': (context) => const StoryDetailsScreen(),
        '/artisans': (context) => const ArtisansScreen(),
        '/artisan_profile': (context) => const ArtisanProfileScreen(),
        '/profile': (context) => const ProfileScreen(),
      },
    );
  }
}
