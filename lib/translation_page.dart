import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';
import 'package:provider/provider.dart';
import 'language_provider.dart';
import 'translations.dart';

class TranslationPage extends StatefulWidget {
  const TranslationPage({super.key});

  @override
  State<TranslationPage> createState() => _TranslationPageState();
}

class _TranslationPageState extends State<TranslationPage> {
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
    final language = LanguageProvider.currentOrDefault(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(AppTranslations.get('translation', language)),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
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
                    Text(AppTranslations.get('translator', language), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _translateController,
                      decoration: InputDecoration(labelText: AppTranslations.get('text_to_translate', language)),
                      minLines: 1,
                      maxLines: 4,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Text('${AppTranslations.get('target', language)}:'),
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
                            : Text(AppTranslations.get('translate', language)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text('${AppTranslations.get('result', language)}:', style: Theme.of(context).textTheme.titleMedium),
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
                    Text(AppTranslations.get('currency_converter', language), 
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    TextField(
                      controller: _amountController,
                      decoration: InputDecoration(labelText: AppTranslations.get('amount', language)),
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Text(AppTranslations.get('from_currency', language)),
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
                        Text(AppTranslations.get('to_currency', language)),
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
                            : Text(AppTranslations.get('convert', language)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text('${AppTranslations.get('result', language)}:', style: Theme.of(context).textTheme.titleMedium),
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
