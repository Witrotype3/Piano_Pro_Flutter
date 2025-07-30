import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:connect_to_go_server_flutter/constants/theme.dart';
import 'package:connect_to_go_server_flutter/constants/staff_config.dart';
import '../widgets/staff_painter_widget.dart';
import '../models/note_model.dart';

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

  void _handleKeyPress(RawKeyEvent event) {
    if (event is RawKeyDownEvent) {
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
    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 600;
    final theme = Theme.of(context);
    final brightness = theme.brightness;
    final padding = screenSize.width * 0.05;
    final buttonSize = screenSize.width * 0.1;

    return Scaffold(
      backgroundColor: AppTheme.getThemeBackgroundColor(brightness),
      appBar: AppBar(
        title: Text(
          'Learn All Notes',
          style: TextStyle(color: AppTheme.getThemeTextColor(brightness)),
        ),
        backgroundColor: AppTheme.getThemeColor(brightness),
        foregroundColor: AppTheme.getThemeTextColor(brightness),
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(_focusNode),
        child: RawKeyboardListener(
          focusNode: _focusNode,
          onKey: _handleKeyPress,
          child: LayoutBuilder(
            builder: (context, constraints) {
              const maxStaffWidth = 600.0;
              final staffWidth = constraints.maxWidth * 0.8 > maxStaffWidth
                  ? maxStaffWidth
                  : constraints.maxWidth * 0.8;
              final staffHeight = (lineCount + 3) * lineSpacing;
              const animationOffset = 24.0;
              final totalHeight = staffHeight + animationOffset;

              return SingleChildScrollView(
                child: Container(
                  color: Colors.transparent,
                  padding: EdgeInsets.all(padding),
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Score: $_score',
                        style: TextStyle(
                          fontSize: constraints.maxWidth * 0.08,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.getThemeTextColor(brightness),
                        ),
                      ),
                      SizedBox(height: padding),
                      Center(
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            maxWidth: maxStaffWidth,
                            maxHeight: totalHeight,
                          ),
                          child: Container(
                            width: staffWidth,
                            height: totalHeight,
                            child: FittedBox(
                              fit: BoxFit.contain,
                              child: SizedBox(
                                width: staffWidth,
                                height: totalHeight,
                                child: Stack(
                                  clipBehavior: Clip.none,
                                  children: [
                                    ClipRect(
                                      child: Stack(
                                        children: [
                                          AnimatedBuilder(
                                            animation: _animationController,
                                            builder: (context, child) {
                                              return Transform.translate(
                                                offset: Offset(0, _slideAnimation.value),
                                                child: CustomPaint(
                                                  painter: StaffPainter(
                                                    note: _previousNote,
                                                    noteColor: Colors.black,
                                                    lineColor: AppTheme.getThemeTextColor(brightness),
                                                  ),
                                                  size: Size(staffWidth, staffHeight),
                                                ),
                                              );
                                            },
                                          ),
                                          AnimatedBuilder(
                                            animation: _animationController,
                                            builder: (context, child) {
                                              return Transform.translate(
                                                offset: Offset(0, _slideAnimation.value + 200),
                                                child: CustomPaint(
                                                  painter: StaffPainter(
                                                    note: _currentNote,
                                                    noteColor: Colors.black,
                                                    lineColor: AppTheme.getThemeTextColor(brightness),
                                                  ),
                                                  size: Size(staffWidth, staffHeight),
                                                ),
                                              );
                                            },
                                          ),
                                        ],
                                      ),
                                    ),
                                    Positioned(
                                      top: -10,
                                      left: 0,
                                      right: 0,
                                      child: Container(
                                        height: 25,
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            begin: Alignment.topCenter,
                                            end: Alignment.bottomCenter,
                                            colors: [
                                              AppTheme.getThemeBackgroundColor(brightness),
                                              AppTheme.getThemeBackgroundColor(brightness).withOpacity(0.0),
                                            ],
                                            stops: [0.0, 0.8],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: padding),
                      Text(
                        isSmallScreen ? 'Tap the note shown above' : 'Press or tap the note shown above',
                        style: TextStyle(
                          fontSize: constraints.maxWidth * 0.045,
                          color: AppTheme.getThemeTextColor(brightness),
                        ),
                      ),
                      if (_feedbackMessage != null)
                        Padding(
                          padding: EdgeInsets.only(top: padding),
                          child: Text(
                            _feedbackMessage!,
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: constraints.maxWidth * 0.045,
                            ),
                          ),
                        ),
                      SizedBox(height: padding),
                      Wrap(
                        alignment: WrapAlignment.center,
                        spacing: padding * 0.5,
                        runSpacing: padding * 0.5,
                        children: ['C', 'D', 'E', 'F', 'G', 'A', 'B'].map((note) {
                          return SizedBox(
                            width: buttonSize,
                            height: buttonSize,
                            child: ElevatedButton(
                              onPressed: () => _handleButtonPress(note),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppTheme.getThemeColor(brightness),
                                foregroundColor: AppTheme.getThemeTextColor(brightness),
                                padding: EdgeInsets.zero,
                                textStyle: TextStyle(fontSize: buttonSize * 0.4),
                              ),
                              child: Text(note),
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}