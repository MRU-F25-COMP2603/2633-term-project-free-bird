import 'package:camera/camera.dart';
import 'package:flutter/material.dart';


class CameraPage extends StatefulWidget {
  const CameraPage({super.key});

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  late CameraController _controller;
  bool _initialized = false;
  bool _capturing = false;
  String? _imagePath;

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  Future<void> _initCamera() async {
    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('No camera detected on this device.')),
        );
        return;
      }

      _controller = CameraController(
        cameras.first,
        ResolutionPreset.medium,
      );

      await _controller.initialize();
      if (!mounted) return;
      setState(() => _initialized = true);
    } catch (e) {
      debugPrint('Camera init error: $e');
    }
  }

  Future<void> _capturePhoto() async {
    if (!_initialized || _capturing) return;
    setState(() => _capturing = true);
    try {
      final file = await _controller.takePicture();
      setState(() => _imagePath = file.path);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Photo saved at: ${file.path}')),
      );
    } catch (e) {
      debugPrint('Capture failed: $e');
    } finally {
      setState(() => _capturing = false);
    }
  }

  @override
  void dispose() {
    if (_initialized) _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Camera')),
      body: Center(
        child: _initialized
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AspectRatio(
                    aspectRatio: _controller.value.aspectRatio,
                    child: CameraPreview(_controller),
                  ),
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: _capturing ? null : _capturePhoto,
                    icon: const Icon(Icons.camera),
                    label: const Text('Capture Photo'),
                  ),
                  if (_imagePath != null)
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Text('Saved: $_imagePath'),
                    ),
                ],
              )
            : const CircularProgressIndicator(),
      ),
    );
  }
}
