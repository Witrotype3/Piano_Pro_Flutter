import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:connect_to_go_server_flutter/core/theme/app_theme.dart';
import 'package:connect_to_go_server_flutter/widgets/staff_painter_widget.dart';
import 'package:connect_to_go_server_flutter/models/note_model.dart';

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

class AllNotesScreen extends StatefulWidget {
  const AllNotesScreen({super.key});

  @override
  State<AllNotesScreen> createState() => _AllNotesScreenState();
}

class _AllNotesScreenState extends State<AllNotesScreen> with SingleTickerProviderStateMixin {
  final Random _random = Random();
  final FocusNode _focusNode = FocusNode();

  late Note _currentNote;
  late Note _previousNote;
  int _score = 0;
  String? _feedbackMessage;
  Timer? _feedbackTimer;
  late AnimationController _animationController;
  late Animation<double> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _currentNote = trebleClefNotes[_random.nextInt(trebleClefNotes.length)];
    _previousNote = _currentNote;

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _slideAnimation = Tween<double>(begin: 0, end: -200).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          setState(() {
            _previousNote = _currentNote;
          });
        }
      });

    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(_focusNode);
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    _feedbackTimer?.cancel();
    _animationController.dispose();
    super.dispose();
  }

  void _pickRandomNote() {
    setState(() {
      _currentNote = trebleClefNotes[_random.nextInt(trebleClefNotes.length)];
      _animationController.reset();
      _animationController.forward();
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

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    
    return Scaffold(
      backgroundColor: AppTheme.getThemeBackgroundColor(brightness),
      body: KeyboardListener(
        focusNode: _focusNode,
        onKeyEvent: _handleKeyPress,
        child: SafeArea(
          child: Column(
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.arrow_back,
                        color: AppTheme.getThemeTextColor(brightness),
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                    Text(
                      'Score: $_score',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppTheme.getThemeTextColor(brightness),
                      ),
                    ),
                    const SizedBox(width: 48), // Balance the back button
                  ],
                ),
              ),
              
              // Staff and note display
              Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Staff
                      Container(
                        width: 300,
                        height: 200,
                        decoration: BoxDecoration(
                          color: AppTheme.getThemeColor(brightness),
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha:  0.1),
                              blurRadius: 10,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: StaffPainterWidget(
                          currentNote: _currentNote,
                          previousNote: _previousNote,
                          slideAnimation: _slideAnimation,
                        ),
                      ),
                      
                      const SizedBox(height: 40),
                      
                      // Instructions
                      Text(
                        'Press the key for: ${_currentNote.name}',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.getThemeTextColor(brightness),
                        ),
                      ),
                      
                      const SizedBox(height: 20),
                      
                      // Feedback message
                      if (_feedbackMessage != null)
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: Colors.red.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.red.withValues(alpha: 0.3)),
                          ),
                          child: Text(
                            _feedbackMessage!,
                            style: const TextStyle(
                              color: Colors.red,
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 