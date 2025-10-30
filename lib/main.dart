import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'stored_documents_page.dart';
import 'upload_document_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
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
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Documents')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // --- CAMERA BUTTON (for future feature) ---
            ElevatedButton.icon(
              icon: const Icon(Icons.camera_alt_outlined),
              label: const Text('Open Camera'),
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('📸 Camera feature coming soon!'),
                  ),
                );
              },
            ),
            const SizedBox(height: 20),

            // --- FILE UPLOAD BUTTON ---
            ElevatedButton.icon(
              icon: const Icon(Icons.upload_file),
              label: const Text('Upload Document'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const UploadDocumentPage(),
                  ),
                );
              },
            ),
            const SizedBox(height: 20),

            // --- STORED DOCUMENTS PAGE ---
            ElevatedButton.icon(
              icon: const Icon(Icons.folder),
              label: const Text('Stored Documents'),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const StoredDocumentsPage(),
                  ),
                );
              },
            ),
          ],
        ),
      ),

      // --- BOTTOM NAVIGATION BAR ---
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.flight_takeoff),
            label: 'Trips',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.folder_open),
            label: 'Documents',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.route),
            label: 'Routes',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        currentIndex: 2, // highlight the "Documents" tab
        onTap: (index) {
          if (index == 2) return; // already on Documents
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Page $index not implemented yet')),
          );
        },
      ),
    );
  }
}
