import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';
import 'dart:async'; // Import Timer class

class FirebaseService {
  static final databaseReference = FirebaseDatabase.instance.ref();

  static void updateDirection(double speedValue, String stringValue) {
    databaseReference.update({
      "Abhiii": {
        'speedValue': speedValue.toInt(),
        'stringValue': stringValue,
      }
    });
  }
}

class AllButtons extends StatefulWidget {
  const AllButtons({super.key});

  @override
  State<AllButtons> createState() => _AllButtonsState();
}

class _AllButtonsState extends State<AllButtons> {
  final SpeechToText _speechToText = SpeechToText();
  bool _speechEnabled = false;
  String _lastWords = '';
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _initSpeech();
  }

  @override
  void dispose() {
    _timer?.cancel(); // Cancel the timer when the widget is disposed
    super.dispose();
  }

  void _initSpeech() async {
    try {
      _speechEnabled = await _speechToText.initialize();
    } catch (e) {
      print("Error initializing SpeechToText: $e");
    }
    setState(() {});
  }

  void _startListening() async {
    if (_speechEnabled) {
      await _speechToText.listen(onResult: _onSpeechResult);
      setState(() {});
    } else {
      print("Speech recognition is not enabled");
    }
  }

  void _stopListening() async {
    await _speechToText.stop();
    setState(() {});
  }

  void _onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      _lastWords = result.recognizedWords;
      if (_lastWords == "aage" || _lastWords == "Sidhe") {
        _lastWords = "forward";
      }
      if (_lastWords == "peeche" || _lastWords == "back" || _lastWords == "Piche") {
        _lastWords = "backward";
      }
      if (_lastWords == "daaye" || _lastWords == "die" || _lastWords == "daen") {
        _lastWords = "right";
      }
      if (_lastWords == "baaye" || _lastWords == "bye") {
        _lastWords = "left";
      }
      if (_lastWords == "forward" || _lastWords == "backward" || _lastWords == "right" || _lastWords == "left" || _lastWords == "stop") {
        FirebaseService.updateDirection(_speed, _lastWords);
      }
    });
  }

  double _speed = 50;
  String direction = "stop";

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 50,),
        Slider(
          activeColor: Colors.black,
          inactiveColor: Colors.black,
          label: "Speed",
          value: _speed,
          min: 0,
          max: 100,
          onChanged: (value) {
            setState(() {
              _speed = value;
              FirebaseService.updateDirection(_speed, direction);
            });
          },
        ),
        Text((_speed.toInt()).toString()),
        const SizedBox(height: 10,),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            GestureDetector(child: const Icon(Icons.keyboard_arrow_up, size: 70,), onTapDown: (tapDown) {
              direction = 'forward';
              FirebaseService.updateDirection(_speed, 'forward');
            }, onTapUp: (tapUp) {
              direction = 'stop';
              FirebaseService.updateDirection(_speed, 'stop');
            },),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(child: const Icon(Icons.keyboard_arrow_left, size: 70,), onTapDown: (tapDown) {
                  direction = 'left';
                  FirebaseService.updateDirection(_speed, 'left');
                }, onTapUp: (tapUp) {
                  direction = 'stop';
                  FirebaseService.updateDirection(_speed, 'stop');
                },),
                IconButton(
                  onPressed: () {
                    direction = 'stop';
                    FirebaseService.updateDirection(_speed, 'stop');
                  },
                  icon: const Icon(Icons.circle_outlined),
                  iconSize: 70,
                ),
                GestureDetector(child: const Icon(Icons.keyboard_arrow_right, size: 70,), onTapDown: (tapDown) {
                  direction = 'right';
                  FirebaseService.updateDirection(_speed, 'right');
                }, onTapUp: (tapUp) {
                  direction = 'stop';
                  FirebaseService.updateDirection(_speed, 'stop');
                },)
              ],
            ),
            GestureDetector(child: const Icon(Icons.keyboard_arrow_down, size: 70,), onTapDown: (tapDown) {
              direction = 'backward';
              FirebaseService.updateDirection(_speed, 'backward');
            }, onTapUp: (tapUp) {
              direction = 'stop';
              FirebaseService.updateDirection(_speed, 'stop');
            },)
          ],
        ),
        const SizedBox(height: 10,),
        Container(
          padding: const EdgeInsets.all(16),
          child: const Text(
            'Last Command:',
            style: TextStyle(fontSize: 20.0),
          ),
        ),
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Text(
              _speechToText.isListening
                  ? 'listening..'
                  : _speechEnabled
                  ? 'Tap the microphone to start listening...'
                  : 'Speech not available',
            ),
          ),
        ),
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Text(_lastWords),
          ),
        ),
        FloatingActionButton(
          backgroundColor: Colors.black,
          onPressed: _speechToText.isNotListening ? _startListening : _stopListening,
          tooltip: 'Listen',
          child: Icon(_speechToText.isNotListening ? Icons.mic_off : Icons.mic),
        ),
        const SizedBox(height: 100,)
      ],
    );
  }
}
