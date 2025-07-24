import 'package:flutter/material.dart';
import './screens/welcome_screen.dart';
import './screens/login_screen.dart';
import './screens/signup_screen.dart';
// Import your home screen here
// import 'home_screen.dart';

void main() {
  runApp(const CultureQuestApp());
}

class CultureQuestApp extends StatelessWidget {
  const CultureQuestApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CultureQuest',
      theme: ThemeData(
        primarySwatch: Colors.orange,
        primaryColor: const Color(0xFFF1872D),
        fontFamily: 'Inter', // Make sure to add this font to your assets
        visualDensity: VisualDensity.adaptivePlatformDensity,
        // Custom theme settings
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: const Color(0xFFF5F1EE),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(
            vertical: 18, 
            horizontal: 16,
          ),
        ),
      ),
      // Set the initial route to welcome screen
      initialRoute: '/',
      routes: {
        '/': (context) => const WelcomeScreen(),
        '/login': (context) => const LoginScreen(),
        '/signup': (context) => const SignupScreen(),
        // Add your home screen route here
        // '/home': (context) => const HomeScreen(),
      },
      // Handle unknown routes
      onUnknownRoute: (settings) {
        return MaterialPageRoute(
          builder: (context) => const WelcomeScreen(),
        );
      },
      debugShowCheckedModeBanner: false,
    );
  }
}

// Placeholder home screen - replace with your actual home screen
class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CultureQuest'),
        backgroundColor: const Color(0xFFF1872D),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              // Logout functionality
              //await ApiService.logout();
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/',
                (route) => false,
              );
            },
          ),
        ],
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.home,
              size: 64,
              color: Color(0xFFF1872D),
            ),
            SizedBox(height: 16),
            Text(
              'Welcome to CultureQuest!',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'This is your home screen.',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }
}