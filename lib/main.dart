import 'package:flutter/material.dart';
import 'package:battery_plus/battery_plus.dart';
import 'package:torch_light/torch_light.dart';
import 'package:flutter_tts/flutter_tts.dart';

void main() {
  runApp(const IftikharAssistantApp());
}

class IftikharAssistantApp extends StatelessWidget {
  const IftikharAssistantApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Iftikhar Somro AI Assistant',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.deepPurple,
        scaffoldBackgroundColor: const Color(0xFF121212),
      ),
      home: const AssistantHomePage(),
    );
  }
}

class AssistantHomePage extends StatefulWidget {
  const AssistantHomePage({super.key});

  @override
  State<AssistantHomePage> createState() => _AssistantHomePageState();
}

class _AssistantHomePageState extends State<AssistantHomePage> {
  final Battery _battery = Battery();
  final FlutterTts _tts = FlutterTts();
  String _statusMessage = "السلام علیکم افتخار صاحب! میں آپ کا اسسٹنٹ ہوں۔";
  bool _isTorchOn = false;

  @override
  void initState() {
    super.initState();
    _speak(_statusMessage);
  }

  Future<void> _speak(String text) async {
    await _tts.setLanguage("ur-PK");
    await _tts.setPitch(1.0);
    await _tts.speak(text);
  }

  Future<void> _checkBattery() async {
    final int level = await _battery.batteryLevel;
    final String msg = "افتخار صاحب، موبائل کی بیٹری $level فیصد ہے۔";
    setState(() {
      _statusMessage = msg;
    });
    await _speak(msg);
  }

  Future<void> _toggleTorch() async {
    try {
      if (_isTorchOn) {
        await TorchLight.disableTorch();
        setState(() {
          _isTorchOn = false;
          _statusMessage = "ٹارچ بند کر دی گئی ہے۔";
        });
        await _speak("ٹارچ بند کر دی گئی ہے۔");
      } else {
        await TorchLight.enableTorch();
        setState(() {
          _isTorchOn = true;
          _statusMessage = "ٹارچ آن کر دی گئی ہے۔";
        });
        await _speak("ٹارچ آن کر دی گئی ہے۔");
      }
    } catch (e) {
      setState(() {
        _statusMessage = "ٹارچ کنٹرول میں مسئلہ آیا۔";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Iftikhar Somro AI Assistant'),
        centerTitle: true,
        backgroundColor: const Color(0xFF1E1E1E),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF1E1E1E),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.deepPurpleAccent, width: 1.5),
              ),
              child: Text(
                _statusMessage,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 18, color: Colors.white),
              ),
            ),
            const SizedBox(height: 40),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(55),
                backgroundColor: Colors.deepPurple,
              ),
              onPressed: _checkBattery,
              icon: const Icon(Icons.battery_charging_full),
              label: const Text('بیٹری چیک کریں (Check Battery)', style: TextStyle(fontSize: 16)),
            ),
            const SizedBox(height: 15),
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(55),
                backgroundColor: _isTorchOn ? Colors.redAccent : Colors.teal,
              ),
              onPressed: _toggleTorch,
              icon: Icon(_isTorchOn ? Icons.flash_off : Icons.flash_on),
              label: Text(
                _isTorchOn ? 'ٹارچ بند کریں (Torch OFF)' : 'ٹارچ آن کریں (Torch ON)',
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
