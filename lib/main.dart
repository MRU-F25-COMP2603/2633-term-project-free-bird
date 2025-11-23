import 'package:flutter/material.dart';
import 'dart:math';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login_page.dart';
import 'flight_tracker_page.dart';
import 'hotel_bookings_page.dart';
import 'documents_page.dart';
import 'translation_page.dart';
import 'settings_page.dart';
import 'flight_overview.dart'; // ADDED IMPORT FOR FLIGHT OVERVIEW

const FirebaseOptions windows = FirebaseOptions(
  apiKey: 'AIzaSyCoE-xYJf3OsKpZBrYgLFXCbQIm4aAHH0c',
  appId: '1:953042776685:web:695a3c3d5157c373a94564',
  messagingSenderId: '953042776685',
  projectId: 'freebird-app-587de',
  authDomain: 'freebird-app-587de.firebaseapp.com',
  storageBucket: 'freebird-app-587de.firebasestorage.app',
);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(options: windows);
    
    // IMPORTANT: Sign out any existing user on app startup
    // This ensures the app always starts at the login page
    await FirebaseAuth.instance.signOut();
  } catch (e) {
    debugPrint('Failed to initialize Firebase: $e');
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Free Bird',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      routes: {
        '/home': (context) => const MyHomePage(),
      },
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          // Show loading indicator while checking auth state
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
          
          // If user is logged in, show home page
          if (snapshot.hasData) {
            return const MyHomePage();
          }
          
          // Otherwise, show login page
          return const LoginPage();
        },
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  Future<void> _logout() async {
    await FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final buttonSize = min(screenWidth / 5, 120.0);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Free Bird'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout,
            tooltip: 'Logout',
          ),
        ],
      ),
     
      // REPLACED EMPTY BODY WITH FLIGHT OVERVIEW AS MAIN SCREEN
      body: const DataOverviewPage(),
      
      bottomNavigationBar: SizedBox(
        height: buttonSize,
        child: Row(
          children: List.generate(5, (index) {
            // Define icons for each page
            final icons = [
              Icons.flight,           // Page 1: Flights
              Icons.home,             // Page 2: Home/placeholder
              Icons.folder,           // Page 3: Documents
              Icons.translate,        // Page 4: Translation & Currency
              Icons.settings,         // Page 5: Settings/placeholder
            ];
            
            return SizedBox(
              width: screenWidth / 5,
              height: buttonSize,
              child: ElevatedButton(
                onPressed: () {
                  final targetPage = index + 1;
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SimplePage(pageIndex: targetPage),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.zero,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.zero,
                  ),
                  backgroundColor: Colors.grey.shade200,
                  side: const BorderSide(color: Colors.black, width: 0.5),
                  elevation: 0,
                ),
                child: Icon(icons[index], size: 24, color: Colors.black),
              ),
            );
          }),
        ),
      ),
    );
  }
}

class SimplePage extends StatelessWidget {
  final int pageIndex;

  const SimplePage({super.key, required this.pageIndex});

  @override
  Widget build(BuildContext context) {
    switch (pageIndex) {
      case 1:
        return const FlightInputPage();
      case 2:
        return const HotelBookingsPage();
      case 3:
        return const DocumentsPage();
      case 4:
        return const TranslationPage();
      case 5:
        return const SettingsPage();
      default:
        return Scaffold(
          appBar: AppBar(title: Text('Page $pageIndex')),
          body: Center(
            child: Text(
              'This is page $pageIndex',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ),
        );
    }
  }
}