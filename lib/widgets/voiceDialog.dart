import 'package:flutter/material.dart';

class SpeechRecognitionDialog extends StatelessWidget {
  final VoidCallback onStopListening;

  const SpeechRecognitionDialog({
    super.key, 
    required this.onStopListening
  });
  //Voice dialog 
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color(0xFF2B1736),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 20),
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white,
                width: 2,
              ),
            ),
            child: const Icon(
              Icons.mic,
              color: Colors.white,
              size: 40,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Listening...',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontFamily: 'Lexend',
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              onStopListening();
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(155, 241, 82, 255),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
            ),
            child: Text(
              'Stop',
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'Lexend',
              ),
            ),
          ),
        ],
      ),
    );
  }
}