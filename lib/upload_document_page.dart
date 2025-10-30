// ---------------------------------------------------------
// COMBINED MAIN.DART
// Firebase + Documents + Camera + File Upload + Translation/Currency Pages
// ---------------------------------------------------------
import 'dart:math';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';

// 🔹 Import your document-related files
import 'firestore_service.dart';
import 'stored_documents_page.dart';
import 'upload_document_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

// ---------------------------------------------------------
// ROOT APP
// ---------------------------------------------------------
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Free Bird',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
  }
}

// ---------------------------------------------------------
// MAIN HOME PAGE WITH BOTTOM MENU
// ---------------------------------------------------------
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
      body: const Center(child: Text('Welcome to Free Bird!')),
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
                child: const Icon(Icons.circle, size: 24, color: Colors.black),
              ),
            );
          }),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------
// PAGE ROUTER
// ---------------------------------------------------------
class SimplePage extends StatelessWidget {
  final int pageIndex;
  const SimplePage({super.key, required this.pageIndex});

  @override
  Widget build(BuildContext context) {
    if (pageIndex == 3) {
      // Documents Page
      final screenWidth = MediaQuery.of(context).size.width;
      final buttonSize = min(screenWidth * 0.22, 140.0);

      return Scaffold(
        appBar: AppBar(title: const Text('Back')),
        body: Column(
          children: [
            Container(
              width: double.infinity,
              color: Colors.grey.shade200,
              padding: const EdgeInsets.symmetric(vertical: 12.0),
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
                  children: [
                    // Camera
                    SizedBox(
                      width: buttonSize,
                      height: buttonSize,
                      child: ElevatedButton(
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const UploadDocumentPage()),
                        ),
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                        ),
                        child: const Text('Camera', textAlign: TextAlign.center),
                      ),
                    ),
                    const SizedBox(width: 20),
                    // Upload
                    SizedBox(
                      width: buttonSize,
                      height: buttonSize,
                      child: ElevatedButton(
                        onPressed: () async {
                          final firestoreService = FirestoreService();
                          await firestoreService.addDocument(
                            userID: 'testUser123',
                            documentName: 'Visa Application.pdf',
                            fileType: 'PDF',
                          );
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('✅ Test document uploaded!')),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                        ),
                        child: const Text('File Upload', textAlign: TextAlign.center),
                      ),
                    ),
                    const SizedBox(width: 20),
                    // Stored Documents
                    SizedBox(
                      width: buttonSize,
                      height: buttonSize,
                      child: ElevatedButton(
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const StoredDocumentsPage()),
                        ),
                        style: ElevatedButton.styleFrom(
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
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

    if (pageIndex == 4) {
      return const TranslationAndCurrencyPage();
    }

    return Scaffold(
      appBar: AppBar(title: Text('Page $pageIndex')),
      body: Center(child: Text('This is page $pageIndex')),
    );
  }
}

// ---------------------------------------------------------
// TRANSLATION + CURRENCY PAGE
// ---------------------------------------------------------
class TranslationAndCurrencyPage extends StatefulWidget {
  const TranslationAndCurrencyPage({super.key});

  @override
  State<TranslationAndCurrencyPage> createState() => _TranslationAndCurrencyPageState();
}

class _TranslationAndCurrencyPageState extends State<TranslationAndCurrencyPage> {
  static const String deeplApiKey = '274fe5a0-9315-492e-8640-1757db842ef2:fx';

  final TextEditingController _translateController = TextEditingController();
  String _translatedText = '';
  String _targetLang = 'ES';
  bool _translating = false;

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
    if (text.isEmpty) {
      setState(() => _translatedText = 'No text to translate.');
      return;
    }
    setState(() => _translating = true);

    final url = Uri.parse('https://api-free.deepl.com/v2/translate');
    final body = {'text': text, 'target_lang': _targetLang};

    try {
      final resp = await http.post(
        url,
        headers: {
          'Authorization': 'DeepL-Auth-Key $deeplApiKey',
          'Content-Type': 'application/x-www-form-urlencoded'
        },
        body: body,
      );
      if (resp.statusCode == 200) {
        final data = jsonDecode(resp.body);
        _translatedText = data['translations'][0]['text'];
      } else {
        _translatedText = 'API error: ${resp.statusCode}';
      }
    } catch (e) {
      _translatedText = 'Error: $e';
    } finally {
      setState(() => _translating = false);
    }
  }

  Future<void> _performConversion() async {
    final amount = double.tryParse(_amountController.text.trim());
    if (amount == null || amount <= 0) {
      setState(() => _conversionResult = 'Invalid amount.');
      return;
    }

    setState(() => _converting = true);

    final httpClient = HttpClient()..badCertificateCallback = (_, __, ___) => true;
    final ioClient = IOClient(httpClient);

    try {
      final from = 'FX${_fromCurrency}CAD';
      final to = 'FX${_toCurrency}CAD';
      final urlFrom = Uri.parse('https://www.bankofcanada.ca/valet/observations/$from/json');
      final urlTo = Uri.parse('https://www.bankofcanada.ca/valet/observations/$to/json');

      final respFrom = await ioClient.get(urlFrom);
      final respTo = await ioClient.get(urlTo);

      if (respFrom.statusCode == 200 && respTo.statusCode == 200) {
        final dataFrom = jsonDecode(respFrom.body);
        final dataTo = jsonDecode(respTo.body);

        final rateFrom = double.tryParse(dataFrom['observations'].last[from]['v']);
        final rateTo = double.tryParse(dataTo['observations'].last[to]['v']);

        if (rateFrom != null && rateTo != null && rateFrom > 0 && rateTo > 0) {
          final rate = rateFrom / rateTo;
          final converted = amount * rate;
          setState(() => _conversionResult = '${converted.toStringAsFixed(4)} $_toCurrency');
        } else {
          setState(() => _conversionResult = 'No rate data available.');
        }
      } else {
        setState(() => _conversionResult = 'Error fetching rates.');
      }
    } catch (e) {
      setState(() => _conversionResult = 'Conversion error: $e');
    } finally {
      ioClient.close();
      setState(() => _converting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Translation & Currency')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  children: [
                    const Text('Translator', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    TextField(controller: _translateController, decoration: const InputDecoration(labelText: 'Text')),
                    ElevatedButton(
                      onPressed: _translating ? null : _performTranslation,
                      child: _translating ? const CircularProgressIndicator() : const Text('Translate'),
                    ),
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
                  children: [
                    const Text('Currency Converter', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    TextField(controller: _amountController, decoration: const InputDecoration(labelText: 'Amount')),
                    ElevatedButton(
                      onPressed: _converting ? null : _performConversion,
                      child: _converting ? const CircularProgressIndicator() : const Text('Convert'),
                    ),
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
