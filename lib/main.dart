import 'package:flutter/material.dart';
import 'dart:math';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';

void main() {
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
  // Build method: compute responsive button dimensions used by the
  // bottom navigation row.
    final screenWidth = MediaQuery.of(context).size.width;
    final buttonSize = min(screenWidth / 5, 120.0);

    return Scaffold(
      body: Column(
        children: [
          // Main content area (empty by design)
          const Expanded(child: SizedBox.shrink()),
        ],
      ),
      // Use bottomNavigationBar so the row sits flush with the bottom edge.
      bottomNavigationBar: SizedBox(
        height: buttonSize,
        child: Row(
          children: List.generate(5, (index) {
            return SizedBox(
              width: screenWidth / 5,
              height: buttonSize,
              child: ElevatedButton(
                onPressed: () {
              // Map each bottom button to its page: page = index + 1
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
                  // light grey background
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

// Simple destination page used by each bottom button. Special-case
// layout for Documents (page 3) below.
class SimplePage extends StatelessWidget {
  final int pageIndex;

  const SimplePage({super.key, required this.pageIndex});

  @override
  Widget build(BuildContext context) {
  // Special layout for page 3: Documents header + three centered square
  // buttons that navigate to Camera/File Upload/Stored Documents pages.
  if (pageIndex == 3) {
      final screenWidth = MediaQuery.of(context).size.width;
      // Use a button size that's a fraction of the screen width but capped.
      final buttonSize = min(screenWidth * 0.22, 140.0);

      return Scaffold(
        appBar: AppBar(
          // Keep the back label on the left as requested previously.
          title: const Text('Back'),
          centerTitle: false,
        ),
        body: Column(
          children: [
            // Light grey header with bold "Documents" centered
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
            // Centered horizontal buttons with spacing
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

    // Default simple page for other indices
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

  // Languages supported by DeepL
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
        // CAD -> OTHER: series FX{TO}CAD returns CAD per 1 TO
        final seriesTo = 'FX${_toCurrency}CAD';
        final urlTo = Uri.parse('https://www.bankofcanada.ca/valet/observations/$seriesTo/json');
        final respTo = await ioClient.get(urlTo).timeout(const Duration(seconds: 10));
        
        if (respTo.statusCode == 200) {
          final dataTo = jsonDecode(respTo.body) as Map<String, dynamic>;
          final obsTo = (dataTo['observations'] as List?)?.cast<Map<String, dynamic>>();
          if (obsTo != null && obsTo.isNotEmpty) {
            final latestTo = obsTo.last;
            final valueStrTo = (latestTo[seriesTo]?['v'] ?? latestTo[seriesTo])?.toString();
            final rateTo = double.tryParse(valueStrTo ?? '0') ?? 0.0; // CAD per TO
            if (rateTo == 0) {
              setState(() => _conversionResult = 'No rate data available.');
            } else {
              final rate = 1 / rateTo; // TO per CAD
              final converted = amount * rate; // amount CAD -> TO
              setState(() => _conversionResult = '${converted.toStringAsFixed(4)} $_toCurrency (rate: ${rate.toStringAsFixed(6)})');
            }
          } else {
            setState(() => _conversionResult = 'No rate data available.');
          }
        } else {
          setState(() => _conversionResult = 'Rate API error: ${respTo.statusCode}');
        }
      } else if (_fromCurrency != 'CAD' && _toCurrency == 'CAD') {
        // FROM -> CAD: series FX{FROM}CAD returns CAD per 1 FROM
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
            // Translator card
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
            // Currency converter card
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

class FileUploadPage extends StatelessWidget {
  const FileUploadPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('File Upload')),
      body: const Center(child: Text('File upload page')),
    );
  }
}

class StoredDocumentsPage extends StatelessWidget {
  const StoredDocumentsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Stored Documents')),
      body: const Center(child: Text('Stored documents page')),
    );
  }
}
