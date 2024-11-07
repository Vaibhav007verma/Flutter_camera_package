
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Camera Demo',
      home: const HomeScreen(),
    );
  }
}




class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}


class _HomeScreenState extends State<HomeScreen> {
  XFile? _imageFile;

  // ImagePicker start witht he imagePicker
  bool textScanning = false;
  XFile? imageFile; String scannedText = "";



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // ImagePicker
            // if(imageFile != null ) Image.file(File(imageFile!.path)),

            if (_imageFile != null)
              Expanded(child: Image.file(File(_imageFile!.path)))
            else
              const Text('No image taken.'),
            ElevatedButton(
              onPressed: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const CameraScreen()),
                );
                if (result != null) {
                  setState(() {
                    _imageFile = result as XFile;
                  });
                }
              },
              child: const Text('Open Camera'),
            ),
          ],
        ),
      ),
    );
  }
}




class CameraScreen extends StatefulWidget {
  const CameraScreen({super.key});

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  late CameraController _controller;
  late List<CameraDescription> _cameras;

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  Future<void> _initCamera() async {
    _cameras = await availableCameras();
    _controller = CameraController(_cameras[0], ResolutionPreset.max);
    await _controller.initialize();
    setState(() {});
  }

  Future<void> _takePicture() async {
    final imageFile = await _controller.takePicture();
    Navigator.pop(context, imageFile);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Camera Page')),
      body: Column(
        children: [
          Container(
            height: MediaQuery.of(context).size.height*0.8,
            color: Colors.yellow,
            child: _controller.value.isInitialized
                ? AspectRatio(
              aspectRatio: _controller.value.aspectRatio,
              child: CameraPreview(_controller),
            )
                : Center(child: CircularProgressIndicator()),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: _takePicture,
            child: const Text('Take Picture'),
          ),
        ],
      ),
    );
  }
}