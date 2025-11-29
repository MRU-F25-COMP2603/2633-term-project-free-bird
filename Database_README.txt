Overview:
----------
This document explains how to connect and test the Firebase Firestore database for the Free Bird app.

Steps to Connect Firebase:
--------------------------
1. Make sure you have Flutter installed and working.
   - Run: flutter --version

2. Pull the latest project from GitHub:
   - git pull origin main

3. Run the following command to get all dependencies:
   - flutter pub get

4. Firebase Configuration:
   - The Firebase project is already linked through the file: lib/firebase_options.dart
   - This file contains all the credentials for connecting to Firestore.
   - Do NOT modify or delete this file.

5. Running the App:
   - Open the project folder in VS Code.
   - Run: flutter run
   - You should see a window showing: "Firebase Connected! ✅"

6. Testing Database:
   - Navigate to lib/stored_documents_page.dart
   - This page allows testing Firestore by adding and viewing documents.
   - When you click "Upload Test Document", a new record will appear in Firebase Firestore
     under the "Documents" collection.

7. To verify in Firebase:
   - Go to https://console.firebase.google.com/
   - Select project: freebird-app
   - Open Firestore Database -> Data
   - You should see a new document created under the "Documents" collection.

Common Issues:
---------------
• If Firebase fails to connect:
  - Ensure internet connection is active.
  - Make sure firebase_options.dart is not deleted.
  - Try re-running: flutterfire configure

• If dependencies are missing:
  - Run: flutter clean
  - Then run: flutter pub get

Important Notes:
----------------
• The database currently supports storing only document metadata.
• Document upload to Firebase Storage will be added later when the Blaze plan is enabled.
• Camera feature integration will come in the next development phase.