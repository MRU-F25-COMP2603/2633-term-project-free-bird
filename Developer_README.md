---Developer Guide---

Source Code:
All source code is available through GitHub. For the latest stable version, refer to Main. For the most up-to-date commits, refer to the feature branches.

Directory Structure Layout:
The "lib" folder contains all page widgets and functionality, most changes will occur there. The "test" folder has several files for our various kinds of test functions. The "windows" folder contains all information relevant to the system the program is running on, changes should be minimal here. All other folders should remain unchanged.

How to build software:
Ensure all dependencies are downloaded, such as Visual Studio, Dart, and Flutter. Should any issues arrise in running the program, delete "pubspec.lock" and run "flutter pub get".

How to test software:
All tests are run when the program is run and when any pull request is created. To manually test without running the program, run "flutter test".

How to add new tests:
Refer to the "test" folder and add any given test case into it's relevant file referring to the documentation provided in them.

How to build a release of the software:
Simply build a release within GitHub, all other tasks are automated.
