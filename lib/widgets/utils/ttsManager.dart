// import 'package:flutter_tts/flutter_tts.dart';

// class TtsManager {
//   static final TtsManager _instance = TtsManager._internal();
//   final FlutterTts _flutterTts = FlutterTts();
//   String? _activeUtterance;
//   bool _isSpeaking = false;

//   TtsManager._internal() {
//     _flutterTts.setLanguage("en-US");
//     _flutterTts.setPitch(1.0);
//     _flutterTts.setCompletionHandler(() {
//       _isSpeaking = false;
//       _activeUtterance = null;
//     });
//     _flutterTts.setCancelHandler(() {
//       _isSpeaking = false;
//       _activeUtterance = null;
//     });
//   }

//   factory TtsManager() => _instance;

//   Future<void> speak(String text) async {
//     if (_isSpeaking && _activeUtterance == text) {
//       return; // Avoid re-triggering the same text
//     }

//     _isSpeaking = true;
//     _activeUtterance = text;
//     await _flutterTts.speak(text);
//   }

//   Future<void> stop() async {
//     _isSpeaking = false;
//     _activeUtterance = null;
//     await _flutterTts.stop();
//   }

//   bool get isSpeaking => _isSpeaking;
//   String? get activeUtterance => _activeUtterance;
// }
