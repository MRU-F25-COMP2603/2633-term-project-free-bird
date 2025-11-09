import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';

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
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final buttonSize = min(screenWidth / 5, 120.0);

    return Scaffold(
      body: Column(
        children: [
          const Expanded(child: SizedBox.shrink()),
        ],
      ),
      bottomNavigationBar: SizedBox(
        height: buttonSize,
        child: Row(
          children: List.generate(5, (index) {
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
                child: Icon(Icons.add, size: 24, color: Colors.black),
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
    if (pageIndex == 1){
      return const FlightInputPage();
    }
    if (pageIndex == 3) {
      final screenWidth = MediaQuery.of(context).size.width;
      final buttonSize = min(screenWidth * 0.22, 140.0);

      return Scaffold(
        appBar: AppBar(
          title: const Text('Back'),
          centerTitle: false,
        ),
        body: Column(
          children: [
            Container(
              width: double.infinity,
              color: Colors.grey.shade200,
              padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
              child: const Center(
                child: Text(
                  'Documents',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18.0),
                ),
              ),
            ),
            Expanded(
              child: Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: buttonSize,
                      height: buttonSize,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const CameraPage()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                        ),
                        child: const Text('Camera', textAlign: TextAlign.center),
                      ),
                    ),
                    const SizedBox(width: 20),
                    SizedBox(
                      width: buttonSize,
                      height: buttonSize,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const FileUploadPage()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                        ),
                        child: const Text('File Upload', textAlign: TextAlign.center),
                      ),
                    ),
                    const SizedBox(width: 20),
                    SizedBox(
                      width: buttonSize,
                      height: buttonSize,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const StoredDocumentsPage()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                        ),
                        child: const Text('Stored Documents', textAlign: TextAlign.center),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    }

    // Page 4: Translator + currency converter
    if (pageIndex == 4) {
      return const TranslationAndCurrencyPage();
    }

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

class TranslationAndCurrencyPage extends StatefulWidget {
  const TranslationAndCurrencyPage({super.key});

  @override
  State<TranslationAndCurrencyPage> createState() => _TranslationAndCurrencyPageState();
}

class _TranslationAndCurrencyPageState extends State<TranslationAndCurrencyPage> {
  static const String deeplApiKey = '274fe5a0-9315-492e-8640-1757db842ef2:fx';

  // Translator fields
  final TextEditingController _translateController = TextEditingController();
  String _translatedText = '';
  String _targetLang = 'ES';  // DeepL uses uppercase language codes
  bool _translating = false;

  // Currency fields
  final TextEditingController _amountController = TextEditingController();
  String _fromCurrency = 'CAD';
  String _toCurrency = 'USD';
  String _conversionResult = '';
  bool _converting = false;

  final List<Map<String, String>> _languages = [
    {'name': 'Spanish', 'code': 'ES'},
    {'name': 'French', 'code': 'FR'},
    {'name': 'German', 'code': 'DE'},
    {'name': 'Chinese (Simplified)', 'code': 'ZH'},
    {'name': 'Arabic', 'code': 'AR'},
  ];

  Future<void> _performTranslation() async {
    final text = _translateController.text.trim();
    if (deeplApiKey.isEmpty || text.isEmpty) {
      setState(() => _translatedText = 'No text to translate.');
      return;
    }

    setState(() {
      _translating = true;
      _translatedText = '';
    });

    final url = Uri.parse('https://api-free.deepl.com/v2/translate');
    final body = {'text': text, 'target_lang': _targetLang};

    try {
      final resp = await http.post(
        url,
        headers: {
          'Authorization': 'DeepL-Auth-Key $deeplApiKey',
          'Content-Type': 'application/x-www-form-urlencoded'
        },
        body: body
      ).timeout(const Duration(seconds: 10));

      if (resp.statusCode == 200) {
        final data = jsonDecode(resp.body) as Map<String, dynamic>;
        final translations = (data['translations'] as List?)?.cast<Map<String, dynamic>>();
        final translated = translations != null && translations.isNotEmpty ? translations.first['text'] as String? : null;
        setState(() => _translatedText = translated ?? 'No translation found');
      } else {
        setState(() => _translatedText = 'DeepL API error: ${resp.statusCode}');
      }
    } catch (e) {
      setState(() => _translatedText = 'Translation failed: $e');
    } finally {
      setState(() => _translating = false);
    }
  }

  Future<void> _performConversion() async {
    final amountText = _amountController.text.trim();
    final amount = double.tryParse(amountText) ?? 0.0;
    if (amount <= 0) {
      setState(() => _conversionResult = 'Enter a valid amount.');
      return;
    }

    setState(() {
      _converting = true;
      _conversionResult = '';
    });

    final httpClient = HttpClient()..badCertificateCallback = (X509Certificate cert, String host, int port) => true;
    final ioClient = IOClient(httpClient);

    try {
      if (_fromCurrency == 'CAD' && _toCurrency != 'CAD') {
        final seriesTo = 'FX${_toCurrency}CAD';
        final urlTo = Uri.parse('https://www.bankofcanada.ca/valet/observations/$seriesTo/json');
        final respTo = await ioClient.get(urlTo).timeout(const Duration(seconds: 10));
        
        if (respTo.statusCode == 200) {
          final dataTo = jsonDecode(respTo.body) as Map<String, dynamic>;
          final obsTo = (dataTo['observations'] as List?)?.cast<Map<String, dynamic>>();
          if (obsTo != null && obsTo.isNotEmpty) {
            final latestTo = obsTo.last;
            final valueStrTo = (latestTo[seriesTo]?['v'] ?? latestTo[seriesTo])?.toString();
            final rateTo = double.tryParse(valueStrTo ?? '0') ?? 0.0;
            if (rateTo == 0) {
              setState(() => _conversionResult = 'No rate data available.');
            } else {
              final rate = 1 / rateTo;
              final converted = amount * rate;
              setState(() => _conversionResult = '${converted.toStringAsFixed(4)} $_toCurrency (rate: ${rate.toStringAsFixed(6)})');
            }
          } else {
            setState(() => _conversionResult = 'No rate data available.');
          }
        } else {
          setState(() => _conversionResult = 'Rate API error: ${respTo.statusCode}');
        }
      } else if (_fromCurrency != 'CAD' && _toCurrency == 'CAD') {
        final seriesFrom = 'FX${_fromCurrency}CAD';
        final urlFrom = Uri.parse('https://www.bankofcanada.ca/valet/observations/$seriesFrom/json');
        final respFrom = await ioClient.get(urlFrom).timeout(const Duration(seconds: 10));

        if (respFrom.statusCode == 200) {
          final dataFrom = jsonDecode(respFrom.body) as Map<String, dynamic>;
          final obsFrom = (dataFrom['observations'] as List?)?.cast<Map<String, dynamic>>();
          if (obsFrom != null && obsFrom.isNotEmpty) {
            final latestFrom = obsFrom.last;
            final valueStrFrom = (latestFrom[seriesFrom]?['v'] ?? latestFrom[seriesFrom])?.toString();
            final rateFrom = double.tryParse(valueStrFrom ?? '0') ?? 0.0; // CAD per FROM
            final converted = amount * rateFrom; // amount FROM -> CAD
            setState(() => _conversionResult = '${converted.toStringAsFixed(4)} $_toCurrency (rate: ${rateFrom.toStringAsFixed(6)})');
          } else {
            setState(() => _conversionResult = 'No rate data available.');
          }
        } else {
          setState(() => _conversionResult = 'Rate API error: ${respFrom.statusCode}');
        }
      } else if (_fromCurrency != 'CAD' && _toCurrency != 'CAD') {
        // Cross-currency: FROM -> CAD -> TO
        final seriesFrom = 'FX${_fromCurrency}CAD';
        final seriesTo = 'FX${_toCurrency}CAD';
        final urlFrom = Uri.parse('https://www.bankofcanada.ca/valet/observations/$seriesFrom/json');
        final urlTo = Uri.parse('https://www.bankofcanada.ca/valet/observations/$seriesTo/json');

        final respFrom = await ioClient.get(urlFrom).timeout(const Duration(seconds: 10));
        final respTo = await ioClient.get(urlTo).timeout(const Duration(seconds: 10));

        if (respFrom.statusCode == 200 && respTo.statusCode == 200) {
          final dataFrom = jsonDecode(respFrom.body) as Map<String, dynamic>;
          final dataTo = jsonDecode(respTo.body) as Map<String, dynamic>;
          final obsFrom = (dataFrom['observations'] as List?)?.cast<Map<String, dynamic>>();
          final obsTo = (dataTo['observations'] as List?)?.cast<Map<String, dynamic>>();

          if (obsFrom != null && obsFrom.isNotEmpty && obsTo != null && obsTo.isNotEmpty) {
            final latestFrom = obsFrom.last;
            final latestTo = obsTo.last;
            final valueStrFrom = (latestFrom[seriesFrom]?['v'] ?? latestFrom[seriesFrom])?.toString();
            final valueStrTo = (latestTo[seriesTo]?['v'] ?? latestTo[seriesTo])?.toString();
            final rateFrom = double.tryParse(valueStrFrom ?? '0') ?? 0.0; // CAD per FROM
            final rateTo = double.tryParse(valueStrTo ?? '0') ?? 0.0;     // CAD per TO
            if (rateFrom == 0 || rateTo == 0) {
              setState(() => _conversionResult = 'No rate data available.');
            } else {
              final rate = rateFrom / rateTo; // TO per FROM
              final converted = amount * rate;
              setState(() => _conversionResult = '${converted.toStringAsFixed(4)} $_toCurrency (rate: ${rate.toStringAsFixed(6)})');
            }
          } else {
            setState(() => _conversionResult = 'No rate data available.');
          }
        } else {
          setState(() => _conversionResult = 'Rate API error: ${respFrom.statusCode}/${respTo.statusCode}');
        }
      } else {
        setState(() => _conversionResult = 'Unsupported conversion.');
      }
    } catch (e) {
      setState(() => _conversionResult = 'Conversion failed: $e');
    } finally {
      ioClient.close();
      setState(() => _converting = false);
    }
  }

  @override
  void dispose() {
    _translateController.dispose();
    _amountController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Page 4')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text('Translator', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _translateController,
                      decoration: const InputDecoration(labelText: 'Text to translate'),
                      minLines: 1,
                      maxLines: 4,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Text('Target:'),
                        const SizedBox(width: 8),
                        DropdownButton<String>(
                          value: _targetLang,
                          items: _languages.map((l) => 
                            DropdownMenuItem(value: l['code'], child: Text(l['name']!))
                          ).toList(),
                          onChanged: (v) {
                            setState(() {
                              _targetLang = v ?? _targetLang;
                            });
                          },
                        ),
                        const Spacer(),
                        ElevatedButton(
                          onPressed: _translating ? null : _performTranslation,
                          child: _translating 
                            ? const SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              )
                            : const Text('Translate'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text('Result:', style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 6),
                    Text(_translatedText),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text('Currency Converter (Bank of Canada)', 
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _amountController,
                      decoration: const InputDecoration(labelText: 'Amount'),
                      keyboardType: TextInputType.numberWithOptions(decimal: true),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        const Text('From'),
                        const SizedBox(width: 8),
                        DropdownButton<String>(
                          value: _fromCurrency,
                          items: const [
                            DropdownMenuItem(value: 'CAD', child: Text('CAD')),
                            DropdownMenuItem(value: 'USD', child: Text('USD')),
                            DropdownMenuItem(value: 'EUR', child: Text('EUR')),
                          ],
                          onChanged: (v) => setState(() => _fromCurrency = v ?? _fromCurrency),
                        ),
                        const SizedBox(width: 16),
                        const Text('To'),
                        const SizedBox(width: 8),
                        DropdownButton<String>(
                          value: _toCurrency,
                          items: const [
                            DropdownMenuItem(value: 'CAD', child: Text('CAD')),
                            DropdownMenuItem(value: 'USD', child: Text('USD')),
                            DropdownMenuItem(value: 'EUR', child: Text('EUR')),
                          ],
                          onChanged: (v) => setState(() => _toCurrency = v ?? _toCurrency),
                        ),
                        const Spacer(),
                        ElevatedButton(
                          onPressed: _converting ? null : _performConversion,
                          child: _converting 
                            ? const SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              )
                            : const Text('Convert'),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text('Result:', style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 6),
                    Text(_conversionResult),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
class FlightInputPage extends StatefulWidget {
  const FlightInputPage({super.key});

  @override
  State<FlightInputPage> createState() => _FlightInputPageStae();
}
class _FlightInputPageState extends State<FlightInputPage> {
// List to store all flights - each flight is a Map with key-value pairs
  final List<Map<String, dynamic>> _flights = [];
  
  // Controllers to get text from input fields
  final TextEditingController _airlineController = TextEditingController();
  final TextEditingController _flightNumberController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  
  DateTime? _selectedDate;

   @override
  void initState() {   
    // initState runs when the widget is first created
    super.initState();
    _loadSampleFlights(); // Load some example flights when page starts
  }
  void _loadSampleFlights(){
    setState(() {
      _flights.addAll([
        {
          'airline': 'Air Canada',
          'flightNumber': 'AC 472',
          'date': 'Nov 18, 2025',
          'destination': 'Honolulu, HI',
          'status': 'Scheduled'
        },
        {
          'airline': 'WestJet',
          'flightNumber': 'WS 1234',
          'date': 'Dec 15, 2025',
          'destination': 'Cancun, MX',
          'status': 'Booked'
        },
      ]);
    });
  }

  // Opens a date picker dialog for user to select a date
  Future<void> _selectDate() async {
    // showDatePicker returns a Future (async operation) that completes when user picks a date
    final DateTime? picked = await showDatePicker(
      context: context, // context is needed to show the dialog
      initialDate: DateTime.now(), // Start with today's date selected
      firstDate: DateTime(2025), // Can't pick dates before 2025
      lastDate: DateTime(2030), // Can't pick dates after 2030
    );
    
    // If user picked a date and it's different from current selection
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        // Update the text field with the selected date
        _dateController.text = "${picked.month}/${picked.day}/${picked.year}";
      });
    }
  }
  }

class CameraPage extends StatelessWidget {
  const CameraPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Camera')),
      body: const Center(child: Text('Camera page')),
    );
  }
}

class FileUploadPage extends StatefulWidget {
  const FileUploadPage({super.key});

  @override
  State<FileUploadPage> createState() => _FileUploadPageState();
}

class _FileUploadPageState extends State<FileUploadPage> {
  bool _uploading = false;
  String _uploadStatus = '';

  Future<void> _pickAndUploadFile() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.any,
        allowMultiple: false,
      );

      if (result == null || result.files.isEmpty) {
        setState(() => _uploadStatus = 'No file selected');
        return;
      }

      final file = result.files.first;
      if (file.path == null) {
        setState(() => _uploadStatus = 'Invalid file path');
        return;
      }

      setState(() {
        _uploading = true;
        _uploadStatus = 'Uploading ${file.name}...';
      });

      final storageRef = FirebaseStorage.instance.ref();
      final fileRef = storageRef.child('uploads/${DateTime.now().millisecondsSinceEpoch}_${file.name}');

      await fileRef.putFile(File(file.path!));

      final downloadUrl = await fileRef.getDownloadURL();

      await FirebaseFirestore.instance.collection('files').add({
        'name': file.name,
        'url': downloadUrl,
        'storagePath': fileRef.fullPath,
        'type': file.extension ?? 'unknown',
        'size': file.size,
        'uploadedAt': FieldValue.serverTimestamp(),
      });

      setState(() {
        _uploading = false;
        _uploadStatus = 'Upload complete: ${file.name}';
      });

    } catch (e) {
      setState(() {
        _uploading = false;
        _uploadStatus = 'Upload failed: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('File Upload')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton.icon(
              onPressed: _uploading ? null : _pickAndUploadFile,
              icon: const Icon(Icons.upload_file),
              label: const Text('Choose File & Upload'),
            ),
            const SizedBox(height: 20),
            if (_uploading)
              const Center(child: CircularProgressIndicator()),
            if (_uploadStatus.isNotEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Text(_uploadStatus, textAlign: TextAlign.center),
              ),
          ],
        ),
      ),
    );
  }
}

class StoredDocumentsPage extends StatefulWidget {
  const StoredDocumentsPage({super.key});

  @override
  State<StoredDocumentsPage> createState() => _StoredDocumentsPageState();
}

class _StoredDocumentsPageState extends State<StoredDocumentsPage> {
  bool _isFirebaseInitialized = false;

  @override
  void initState() {
    super.initState();
    _checkFirebaseInitialization();
  }

  Future<void> _checkFirebaseInitialization() async {
    try {
      await Firebase.initializeApp();
      if (mounted) {
        setState(() {
          _isFirebaseInitialized = true;
        });
      }
    } catch (e) {
      debugPrint('Firebase initialization error: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to initialize Firebase. Some features may not work.'),
            duration: Duration(seconds: 5),
          ),
        );
      }
    }
  }

  Future<void> _downloadFile(String url, String fileName) async {
      if (!_isFirebaseInitialized) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Firebase is not initialized')),
        );
        return;
      }    final progress = ValueNotifier<double?>(0.0);

    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          title: const Text('Downloading'),
          content: SizedBox(
            height: 80,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ValueListenableBuilder<double?>(
                  valueListenable: progress,
                  builder: (_, value, __) {
                    if (value == null) {
                      return const LinearProgressIndicator();
                    }
                    return Column(
                      children: [
                        LinearProgressIndicator(value: value),
                        const SizedBox(height: 8),
                        Text('${(value * 100).toStringAsFixed(0)}%'),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );

    try {
      if (url.isEmpty) throw Exception('Empty download URL');
      final uri = Uri.tryParse(url);
      if (uri == null || !(uri.scheme == 'http' || uri.scheme == 'https')) {
        throw Exception('Invalid file URL');
      }

      debugPrint('Starting streamed download from $url');

      final client = http.Client();
      final request = http.Request('GET', uri);
      final streamedResp = await client.send(request).timeout(const Duration(seconds: 60));

      if (streamedResp.statusCode != 200) {
        throw Exception('HTTP ${streamedResp.statusCode}');
      }

      final contentLength = streamedResp.contentLength;

      Directory? dir;
      try {
        dir = await getDownloadsDirectory();
      } catch (e) {
        debugPrint('getDownloadsDirectory error: $e');
        dir = null;
      }
      dir ??= await getApplicationDocumentsDirectory();

      final sanitizedBase = fileName.replaceAll(RegExp(r'[<>:\"/\\|?*]'), '_');
      final savePath = await _uniqueFilePath(dir, sanitizedBase);

      final file = File(savePath);
      await file.create(recursive: true);
      final sink = file.openWrite();

      int received = 0;
      if (contentLength == null) progress.value = null;

      await for (final chunk in streamedResp.stream) {
        sink.add(chunk);
        received += chunk.length;
        if (contentLength != null) {
          progress.value = received / contentLength;
        }
      }

      await sink.close();
      client.close();

      progress.value = 1.0;
      debugPrint('Saved file to ${file.path}');

      if (mounted) Navigator.of(context).pop();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Downloaded to: ${file.path}')),
        );
      }
    } catch (e, st) {
      debugPrint('Download failed: $e\n$st');
      if (mounted) Navigator.of(context).pop();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Download failed: $e')),
        );
      }
    } finally {
      progress.dispose();
    }
  }

  Future<String> _uniqueFilePath(Directory dir, String fileName) async {
    final sep = Platform.pathSeparator;
    final index = fileName.lastIndexOf('.');
    String base = fileName;
    String ext = '';
    if (index != -1) {
      base = fileName.substring(0, index);
      ext = fileName.substring(index);
    }

    String candidate = '${dir.path}$sep$fileName';
    int counter = 1;
    while (await File(candidate).exists()) {
      candidate = '${dir.path}$sep${base}_$counter$ext';
      counter++;
    }
    return candidate;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Stored Documents')),
      body: !_isFirebaseInitialized
      ? const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Initializing Firebase...'),
            ],
          ),
        )
      : StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
          .collection('files')
          .orderBy('uploadedAt', descending: true)
          .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final docs = snapshot.data?.docs ?? [];
          
          if (docs.isEmpty) {
            return const Center(child: Text('No documents found'));
          }

          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final doc = docs[index];
              final data = doc.data() as Map<String, dynamic>;
              final fileName = data['name'] as String;
              final fileUrl = data['url'] as String;
              final storagePath = data['storagePath'] as String?;
              final fileSize = (data['size'] as int?) ?? 0;
              final uploadTime = (data['uploadedAt'] as Timestamp?)?.toDate();

              return ListTile(
                leading: Icon(_getFileIcon(fileName)),
                title: Text(fileName),
                subtitle: Text(_formatFileInfo(fileSize, uploadTime)),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.download),
                      onPressed: () => _downloadFile(fileUrl, fileName),
                      tooltip: 'Download',
                    ),
                    IconButton(
                      icon: const Icon(Icons.delete, color: Colors.redAccent),
                      onPressed: () => _confirmAndDelete(doc.id, storagePath, fileName),
                      tooltip: 'Delete',
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }

  IconData _getFileIcon(String fileName) {
    final ext = fileName.split('.').last.toLowerCase();
    switch (ext) {
      case 'pdf':
        return Icons.picture_as_pdf;
      case 'doc':
      case 'docx':
        return Icons.description;
      case 'jpg':
      case 'jpeg':
      case 'png':
        return Icons.image;
      default:
        return Icons.insert_drive_file;
    }
  }

  String _formatFileInfo(int size, DateTime? uploadTime) {
    final sizeStr = size < 1024 * 1024 
      ? '${(size / 1024).toStringAsFixed(1)} KB'
      : '${(size / (1024 * 1024)).toStringAsFixed(1)} MB';
    
    final timeStr = uploadTime != null
      ? '${uploadTime.year}-${uploadTime.month.toString().padLeft(2, '0')}-${uploadTime.day.toString().padLeft(2, '0')}'
      : 'Unknown date';

    return '$sizeStr • $timeStr';
  }

  Future<void> _confirmAndDelete(String docId, String? storagePath, String fileName) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete file'),
        content: Text('Are you sure you want to delete "$fileName"? This cannot be undone.'),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(false), child: const Text('Cancel')),
          TextButton(onPressed: () => Navigator.of(context).pop(true), child: const Text('Delete', style: TextStyle(color: Colors.red))),
        ],
      ),
    );

    if (confirm != true) return;

    // Proceed with deletion
    try {
      if (storagePath != null && storagePath.isNotEmpty) {
        final ref = FirebaseStorage.instance.ref().child(storagePath);
        await ref.delete();
      }

      await FirebaseFirestore.instance.collection('files').doc(docId).delete();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Deleted $fileName')));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Delete failed: $e')));
      }
    }
  }
}