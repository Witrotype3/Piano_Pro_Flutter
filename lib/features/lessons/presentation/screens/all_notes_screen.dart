import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:connect_to_go_server_flutter/core/theme/app_theme.dart';
import 'package:connect_to_go_server_flutter/widgets/staff_painter_widget.dart';
import 'package:connect_to_go_server_flutter/widgets/piano_widget.dart';
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
  Timer? _feedbackTimer;
  late AnimationController _animationController;
  late Animation<double> _slideAnimation;
  
  // Piano interaction state
  List<String> _highlightedKeys = [];
  List<String> _pressedKeys = [];
  bool _isWaitingForCorrectNote = true;
  
  // Feedback state
  bool _showSuccessFeedback = false;
  bool _showErrorFeedback = false;

  @override
  void initState() {
    super.initState();
    _currentNote = trebleClefNotes[_random.nextInt(trebleClefNotes.length)];
    _previousNote = _currentNote;
    _updateHighlightedKeys();

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
      _isWaitingForCorrectNote = true;
      _updateHighlightedKeys();
      _animationController.reset();
      _animationController.forward();
    });
  }

  void _updateHighlightedKeys() {
    // Create a proper mapping from staff position to piano octave
    int octave;
    switch (_currentNote.staffPosition) {
      case -2: // C below middle C
        octave = 4;
        break;
      case -1: // D below middle C
        octave = 4;
        break;
      case 0: // E (middle E)
        octave = 4;
        break;
      case 1: // F
        octave = 4;
        break;
      case 2: // G
        octave = 4;
        break;
      case 3: // A
        octave = 4;
        break;
      case 4: // B
        octave = 4;
        break;
      case 5: // C above middle C
        octave = 5;
        break;
      case 6: // D
        octave = 5;
        break;
      case 7: // E
        octave = 5;
        break;
      case 8: // F
        octave = 5;
        break;
      case 9: // G
        octave = 5;
        break;
      case 10: // A
        octave = 5;
        break;
      default:
        octave = 4; // Default to middle octave
    }
    
    final noteName = _currentNote.name;
    final pianoKey = '$noteName$octave';
    
    setState(() {
      _highlightedKeys = [pianoKey];
    });
  }

  void _handlePianoNotePressed(String note) {
    if (!_isWaitingForCorrectNote) return;
    
    setState(() {
      _pressedKeys.add(note);
    });

    final expectedNote = _highlightedKeys.isNotEmpty ? _highlightedKeys.first : '';
    
    if (note == expectedNote) {
      setState(() {
        _score++;
        _isWaitingForCorrectNote = false;
        _showSuccessFeedback = true;
        _showErrorFeedback = false;
        _highlightedKeys = []; // Clear highlighting when correct
      });
      
      // Show success feedback briefly
      _feedbackTimer?.cancel();
      _feedbackTimer = Timer(const Duration(milliseconds: 800), () {
        setState(() {
          _showSuccessFeedback = false;
          _pressedKeys.clear();
        });
        _pickRandomNote();
      });
    } else {
      setState(() {
        _showErrorFeedback = true;
        _showSuccessFeedback = false;
        _updateHighlightedKeys();
      });
      
      _feedbackTimer?.cancel();
      _feedbackTimer = Timer(const Duration(milliseconds: 600), () {
        setState(() {
          _showErrorFeedback = false;
          _pressedKeys.clear();
        });
      });
    }
  }

  void _handlePianoNoteReleased(String note) {
    setState(() {
      _pressedKeys.remove(note);
    });
  }



  void _handleKeyPress(KeyEvent event) {
    if (event is KeyDownEvent) {
      final keyPressed = event.logicalKey.keyLabel.toUpperCase();
      setState(() {
        if (keyPressed == _currentNote.name) {
          _score++;
          _pickRandomNote();
        } else {
          // Show error feedback for wrong key press
          _showErrorFeedback = true;
          _feedbackTimer?.cancel();
          _feedbackTimer = Timer(const Duration(seconds: 1), () {
            setState(() {
              _showErrorFeedback = false;
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
                child: Column(
                  children: [
                    // Staff
                    Container(
                      width: 300,
                      height: 200,
                      margin: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
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
                    
                    // Feedback overlay
                    if (_showSuccessFeedback || _showErrorFeedback)
                      Container(
                        margin: const EdgeInsets.symmetric(horizontal: 16),
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: _showSuccessFeedback 
                              ? Colors.green.withValues(alpha: 0.9)
                              : Colors.red.withValues(alpha: 0.9),
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.2),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              _showSuccessFeedback ? Icons.check_circle : Icons.error,
                              color: Colors.white,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              _showSuccessFeedback ? 'Correct!' : 'Wrong! Try again.',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    
                    SizedBox(height: (_showSuccessFeedback || _showErrorFeedback) ? 0 : 39 ),
                    
                    // Piano Widget
                    Expanded(
                      child: Container(
                        margin: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppTheme.getThemeBackgroundColor(brightness),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: Colors.grey.withValues(alpha: 0.3),
                            width: 1,
                          ),
                        ),
                        child: PianoWidget(
                          keyHeight: 80,
                          keyWidth: 25,
                          minKeyWidth: 15,
                          maxKeyWidth: 100,
                          showNoteLabels: true,
                          showControls: true,
                          keyAspectRatio: 3.0,
                          enableAudio: true,
                          audioVolume: 0.5,
                          // highlightedKeys: _highlightedKeys,
                          onNotePressed: _handlePianoNotePressed,
                          onNoteReleased: _handlePianoNoteReleased,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
} 