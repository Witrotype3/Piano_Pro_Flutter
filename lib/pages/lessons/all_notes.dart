import 'dart:async';
import 'dart:math';
import 'package:connect_to_go_server_flutter/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Note {
  final String name;
  final int staffPosition;

  const Note(this.name, this.staffPosition);
}

const List<Note> trebleClefNotes = [
  Note('C', -2),
  Note('D', -1),
  Note('E', 0),
  Note('F', 1),
  Note('G', 2),
  Note('A', 3),
  Note('B', 4),
  Note('C', 5),
  Note('D', 6),
  Note('E', 7),
  Note('F', 8),
  Note('G', 9),
  Note('A', 10),
];

class AllNotesPage extends StatefulWidget {
  const AllNotesPage({super.key});

  @override
  State<AllNotesPage> createState() => _AllNotesPageState();
}

class _AllNotesPageState extends State<AllNotesPage> {
  final Random _random = Random();
  final FocusNode _focusNode = FocusNode();

  late Note _currentNote;
  int _score = 0;
  String? _feedbackMessage;
  Timer? _feedbackTimer;

  @override
  void initState() {
    super.initState();
    _pickRandomNote();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(_focusNode);
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _feedbackTimer?.cancel();
    super.dispose();
  }

  void _pickRandomNote() {
    setState(() {
      _currentNote = trebleClefNotes[_random.nextInt(trebleClefNotes.length)];
    });
  }

  void _handleKeyPress(KeyEvent event) {
    if (event is KeyDownEvent) {
      final keyPressed = event.logicalKey.keyLabel.toUpperCase();
      setState(() {
        if (keyPressed == _currentNote.name) {
          _score++;
          _pickRandomNote();
          _feedbackMessage = null;
        } else {
          _feedbackMessage = 'Wrong! Try again.';
          _feedbackTimer?.cancel();
          _feedbackTimer = Timer(const Duration(seconds: 1), () {
            setState(() {
              _feedbackMessage = null;
            });
          });
        }
      });
    }
  }

  void _handleButtonPress(String note) {
    setState(() {
      if (note == _currentNote.name) {
        _score++;
        _pickRandomNote();
        _feedbackMessage = null;
      } else {
        _feedbackMessage = 'Wrong! Try again.';
        _feedbackTimer?.cancel();
        _feedbackTimer = Timer(const Duration(seconds: 1), () {
          setState(() {
            _feedbackMessage = null;
          });
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final brightness = theme.brightness;
    
    return Scaffold(
      backgroundColor: AppTheme.getThemeBackgroundColor(brightness),
      appBar: AppBar(
        title: Text('Learn All Notes',
            style: TextStyle(color: AppTheme.getThemeTextColor(brightness))),
        backgroundColor: AppTheme.getThemeColor(brightness),
        foregroundColor: AppTheme.getThemeTextColor(brightness),
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(_focusNode),
        child: KeyboardListener(
          focusNode: _focusNode,
          onKeyEvent: _handleKeyPress,
          child: Container(
            color: Colors.transparent,
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Score: $_score',
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.getThemeTextColor(brightness),
                  ),
                ),
                const SizedBox(height: 40),
                AspectRatio(
                  aspectRatio: 2.5,
                  child: Container(
                    color: Colors.white,
                    child: CustomPaint(
                      painter: StaffPainter(
                        note: _currentNote,
                        noteColor: AppTheme.getThemeSelectedTextColor(brightness),
                        lineColor: Colors.black,
                      ),
                      size: Size.infinite,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  MediaQuery.of(context).size.width < 600
                      ? 'Tap the note shown above'
                      : 'Press or tap the note shown above',
                  style: TextStyle(
                    fontSize: 18,
                    color: AppTheme.getThemeTextColor(brightness),
                  ),
                ),
                if (_feedbackMessage != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Text(
                      _feedbackMessage!,
                      style: const TextStyle(color: Colors.red, fontSize: 18),
                    ),
                  ),
                const SizedBox(height: 20),
                Wrap(
                  alignment: WrapAlignment.center,
                  spacing: 10,
                  runSpacing: 10,
                  children: ['C', 'D', 'E', 'F', 'G', 'A', 'B'].map((note) {
                    return ElevatedButton(
                      onPressed: () => _handleButtonPress(note),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.getThemeColor(brightness),
                        foregroundColor: AppTheme.getThemeTextColor(brightness),
                      ),
                      child: Text(note),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class StaffPainter extends CustomPainter {
  final Note note;
  final Color noteColor;
  final Color lineColor;

  StaffPainter({
    required this.note,
    required this.noteColor,
    required this.lineColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final linePaint = Paint()
      ..color = lineColor
      ..strokeWidth = 1.5;

    const lineCount = 5;
    final lineSpacing = size.height / 10;
    final staffHeight = (lineCount - 1) * lineSpacing;
    final staffCenterY = size.height / 2;
    final staffTopY = staffCenterY - staffHeight / 2;

    for (int i = 0; i < lineCount; i++) {
      final y = staffTopY + i * lineSpacing;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), linePaint);
    }

    final clefFontSize = size.height * 0.4;
    final clefSpan = TextSpan(
      text: '𝄞',
      style: TextStyle(
        color: lineColor,
        fontSize: clefFontSize,
        fontFamily: 'Arial',
      ),
    );
    final clefPainter = TextPainter(
      text: clefSpan,
      textDirection: TextDirection.ltr,
    );
    clefPainter.layout();
    clefPainter.paint(canvas, Offset(10, staffTopY - clefFontSize / 2.5));

    final notePaint = Paint()..color = noteColor;
    final noteRadiusX = lineSpacing * 0.9;
    final noteRadiusY = lineSpacing * 0.6;
    final noteStemHeight = lineSpacing * 3.5;

    final noteCenterY =
        staffTopY + (8 - note.staffPosition) * (lineSpacing / 2);
    final noteCenterX = size.width * 0.6;

    if (note.staffPosition < -1 || note.staffPosition > 8) {
      // int startPos = note.staffPosition < -1 ? note.staffPosition : 10;
      // int endPos = note.staffPosition < -1 ? -2 : note.staffPosition;
      // for (int pos = startPos; pos <= endPos; pos += 2) {
      //   final ledgerY = staffTopY + (8 - pos) * (lineSpacing / 2);
      //   canvas.drawLine(
      //     Offset(noteCenterX - 20, ledgerY),
      //     Offset(noteCenterX + 20, ledgerY),
      //     linePaint,
      //   );
      // }
    }

    final noteRect = Rect.fromCenter(
      center: Offset(noteCenterX, noteCenterY),
      width: noteRadiusX * 2,
      height: noteRadiusY * 2,
    );
    canvas.drawOval(noteRect, notePaint);

    final stemX = note.staffPosition < 5
        ? noteCenterX + noteRadiusX
        : noteCenterX - noteRadiusX;
    final stemStartY = noteCenterY;
    final stemEndY = note.staffPosition < 5
        ? noteCenterY - noteStemHeight
        : noteCenterY + noteStemHeight;
    canvas.drawLine(
      Offset(stemX, stemStartY),
      Offset(stemX, stemEndY),
      linePaint,
    );
  }

  @override
  bool shouldRepaint(covariant StaffPainter oldDelegate) {
    return oldDelegate.note != note;
  }
} 