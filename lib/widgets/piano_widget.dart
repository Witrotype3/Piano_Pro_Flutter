import 'package:flutter/material.dart';
import 'package:connect_to_go_server_flutter/widgets/custom_scrollbar.dart';
import 'package:audioplayers/audioplayers.dart';

class PianoWidget extends StatefulWidget {
  final Function(String note)? onNotePressed;
  final Function(String note)? onNoteReleased;
  final List<String>? highlightedKeys;
  final bool showNoteLabels;
  final double keyHeight;
  final double keyWidth;
  final double minKeyWidth;
  final double maxKeyWidth;
  final bool showControls;
  final double keyAspectRatio;
  final Function(double keyWidth)?
      onKeyWidthChanged;
  final bool enableAudio;
  final double audioVolume;

  const PianoWidget({
    super.key,
    this.onNotePressed,
    this.onNoteReleased,
    this.highlightedKeys,
    this.showNoteLabels = true,
    this.keyHeight = 120,
    this.keyWidth = 40,
    this.minKeyWidth = 20,
    this.maxKeyWidth = 60,
    this.showControls = true,
    this.keyAspectRatio = 4.0,
    this.onKeyWidthChanged,
    this.enableAudio = true,
    this.audioVolume = 0.7,
  });

  @override
  State<PianoWidget> createState() => _PianoWidgetState();
}

class _PianoWidgetState extends State<PianoWidget> {
  final Set<String> _pressedKeys = {};
  double _currentKeyWidth = 40;
  final ScrollController _pianoScrollController = ScrollController();
  final ScrollController _scrollBarController = ScrollController();
  bool _isSyncingScroll = false;
  final Map<String, AudioPlayer> _audioPlayers = {};
  final Map<String, bool> _fadeOutTasks = {};

  static const List<String> whiteKeys = ['C', 'D', 'E', 'F', 'G', 'A', 'B'];
  static const List<String> blackKeys = ['C#', 'D#', 'F#', 'G#', 'A#'];
  static const List<int> blackKeyPositions = [0, 1, 3, 4, 5];

  List<String> get allKeys {
    List<String> keys = [];
    for (int octave = 0; octave <= 8; octave++) {
      if (octave == 0) {
        keys.addAll(['A0', 'B0']);
      } else if (octave == 8) {
        keys.add('C8');
      } else {
        for (String key in whiteKeys) {
          keys.add('$key$octave');
        }
      }
    }
    return keys;
  }

  List<String> get allBlackKeys {
    List<String> keys = [];
    for (int octave = 1; octave <= 7; octave++) {
      for (String key in blackKeys) {
        keys.add('$key$octave');
      }
    }
    return keys;
  }

  double get _currentKeyHeight => _currentKeyWidth * widget.keyAspectRatio;

  Future<void> _playNote(String note) async {
    if (!widget.enableAudio) return;

    _fadeOutTasks[note] = false;

    try {
      String filename = _getAudioFilename(note);

      final newAudioPlayer = AudioPlayer();
      final uniqueKey = '${note}_${DateTime.now().millisecondsSinceEpoch}';
      _audioPlayers[uniqueKey] = newAudioPlayer;

      await newAudioPlayer.setVolume(1.0);
      await newAudioPlayer.play(AssetSource('audio/keys/$filename'));
    } catch (e) {
      debugPrint('Error playing note $note: $e');
    }
  }

  String _getAudioFilename(String note) {
    Map<String, String> enharmonicMap = {
      'C#': 'Db',
      'D#': 'Eb',
      'F#': 'Gb',
      'G#': 'Ab',
      'A#': 'Bb',
    };

    String noteName = note.substring(0, note.length - 1);
    String octave = note.substring(note.length - 1);

    if (enharmonicMap.containsKey(noteName)) {
      noteName = enharmonicMap[noteName]!;
    }

    return '$noteName$octave.wav';
  }

  @override
  void initState() {
    super.initState();
    _currentKeyWidth = widget.keyWidth;
    widget.onKeyWidthChanged?.call(_currentKeyWidth);

    _pianoScrollController.addListener(() {
      if (_isSyncingScroll) return;
      if (!_scrollBarController.hasClients ||
          !_pianoScrollController.hasClients) {
        return;
      }
      _isSyncingScroll = true;
      try {
        final double target = _pianoScrollController.position.pixels;
        final double max = _scrollBarController.position.maxScrollExtent;
        _scrollBarController.jumpTo(target.clamp(0.0, max));
      } finally {
        _isSyncingScroll = false;
      }
    });

    _scrollBarController.addListener(() {
      if (_isSyncingScroll) return;
      if (!_scrollBarController.hasClients ||
          !_pianoScrollController.hasClients) {
        return;
      }
      _isSyncingScroll = true;
      try {
        final double target = _scrollBarController.position.pixels;
        final double max = _pianoScrollController.position.maxScrollExtent;
        _pianoScrollController.jumpTo(target.clamp(0.0, max));
      } finally {
        _isSyncingScroll = false;
      }
    });
  }

  @override
  void dispose() {
    _pianoScrollController.dispose();
    _scrollBarController.dispose();
    for (final audioPlayer in _audioPlayers.values) {
      audioPlayer.dispose();
    }
    _audioPlayers.clear();
    super.dispose();
  }

  void _zoomIn() {
    setState(() {
      _currentKeyWidth =
          (_currentKeyWidth + 5).clamp(widget.minKeyWidth, widget.maxKeyWidth);
    });
    widget.onKeyWidthChanged?.call(_currentKeyWidth);
  }

  void _zoomOut() {
    setState(() {
      _currentKeyWidth =
          (_currentKeyWidth - 5).clamp(widget.minKeyWidth, widget.maxKeyWidth);
    });
    widget.onKeyWidthChanged?.call(_currentKeyWidth);
  }

  void _scrollToMiddleC() {
    int middleCIndex = allKeys.indexOf('C4');
    if (middleCIndex != -1) {
      double targetOffset = middleCIndex * (_currentKeyWidth + 2) -
          (MediaQuery.of(context).size.width / 2) +
          (_currentKeyWidth / 2);
      _pianoScrollController.animateTo(
        targetOffset.clamp(0, _pianoScrollController.position.maxScrollExtent),
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> children = [];

    if (widget.showControls) {
      children.addAll([
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              onPressed: _zoomOut,
              icon: const Icon(Icons.zoom_out),
              tooltip: 'Zoom Out',
            ),
            Text('${_currentKeyWidth.toInt()}px'),
            IconButton(
              onPressed: _zoomIn,
              icon: const Icon(Icons.zoom_in),
              tooltip: 'Zoom In',
            ),
            const SizedBox(width: 20),
            ElevatedButton(
              onPressed: _scrollToMiddleC,
              child: const Text('Go to Middle C'),
            ),
          ],
        ),
        const SizedBox(height: 10),
      ]);
    }

    children.add(
      Column(
        children: [
          SizedBox(
            height: _currentKeyHeight,
            child: SingleChildScrollView(
              controller: _pianoScrollController,
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              child: SizedBox(
                width: allKeys.length * (_currentKeyWidth + 2),
                child: Stack(
                  children: [
                    Row(
                      children: allKeys.map((note) {
                        bool isPressed = _pressedKeys.contains(note);
                        bool isHighlighted =
                            widget.highlightedKeys?.contains(note) ?? false;
                        bool isMiddleC = note == 'C4';

                        return GestureDetector(
                          onTapDown: (_) => _onKeyPressed(note),
                          onTapUp: (_) => _onKeyReleased(note),
                          onTapCancel: () => _onKeyReleased(note),
                          child: Container(
                            width: _currentKeyWidth,
                            height: _currentKeyHeight,
                            margin: const EdgeInsets.symmetric(horizontal: 1),
                            decoration: BoxDecoration(
                              color: isPressed
                                  ? Colors.blue.shade300
                                  : isHighlighted
                                      ? Colors.yellow.shade200
                                      : isMiddleC
                                          ? Colors.green.shade100
                                          : Colors.white,
                              border: Border.all(
                                color: isMiddleC
                                    ? Colors.green
                                    : Colors.grey.shade400,
                                width: isMiddleC
                                    ? _currentKeyWidth * 0.05
                                    : _currentKeyWidth * 0.025,
                              ),
                              borderRadius: BorderRadius.only(
                                bottomLeft:
                                    Radius.circular(_currentKeyWidth * 0.1),
                                bottomRight:
                                    Radius.circular(_currentKeyWidth * 0.1),
                              ),
                            ),
                            child: widget.showNoteLabels
                                ? Center(
                                    child: Text(
                                      note,
                                      style: TextStyle(
                                        fontSize: _currentKeyWidth * 0.2,
                                        color: isMiddleC
                                            ? Colors.green.shade700
                                            : Colors.grey.shade700,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  )
                                : null,
                          ),
                        );
                      }).toList(),
                    ),
                    ...List.generate(allKeys.length, (index) {
                      String? blackKey = _getBlackKeyForPosition(index);

                      if (blackKey == null) {
                        return const SizedBox.shrink();
                      }

                      bool isPressed = _pressedKeys.contains(blackKey);
                      bool isHighlighted =
                          widget.highlightedKeys?.contains(blackKey) ?? false;

                      return Positioned(
                        left: (index * (_currentKeyWidth + 2)) +
                            _currentKeyWidth +
                            1 -
                            (_currentKeyWidth * 0.25),
                        child: GestureDetector(
                          onTapDown: (_) => _onKeyPressed(blackKey),
                          onTapUp: (_) => _onKeyReleased(blackKey),
                          onTapCancel: () => _onKeyReleased(blackKey),
                          child: Container(
                            width: _currentKeyWidth * 0.6,
                            height: _currentKeyHeight * 0.6,
                            decoration: BoxDecoration(
                              color: isPressed
                                  ? Colors.blue.shade600
                                  : isHighlighted
                                      ? Colors.yellow.shade400
                                      : Colors.black,
                              borderRadius: BorderRadius.only(
                                bottomLeft:
                                    Radius.circular(_currentKeyWidth * 0.1),
                                bottomRight:
                                    Radius.circular(_currentKeyWidth * 0.1),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.3),
                                  blurRadius: 2,
                                  offset: const Offset(0, 1),
                                ),
                              ],
                            ),
                            child: widget.showNoteLabels
                                ? Center(
                                    child: Text(
                                      blackKey,
                                      style: TextStyle(
                                        fontSize: _currentKeyWidth * 0.15,
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  )
                                : null,
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Scroll Bar (${allKeys.length} keys, ${(allKeys.length * (_currentKeyWidth + 2)).toInt()}px wide)',
            style: const TextStyle(fontSize: 10, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          SizedBox(
            height: 20,
            child: ScrollbarStyles.blue(
              controller: _scrollBarController,
              thickness: 12,
              radius: 6,
              child: SingleChildScrollView(
                controller: _scrollBarController,
                scrollDirection: Axis.horizontal,
                physics: const ClampingScrollPhysics(),
                child: SizedBox(
                  width: allKeys.length * (_currentKeyWidth + 2),
                  height: 20,
                ),
              ),
            ),
          ),
        ],
      ),
    );

    return Column(
      children: children,
    );
  }

  String? _getBlackKeyForPosition(int whiteKeyIndex) {
    String whiteKey = allKeys[whiteKeyIndex];
    String noteName = whiteKey.substring(0, whiteKey.length - 1);
    int octave = int.parse(whiteKey.substring(whiteKey.length - 1));

    if (octave == 0 && noteName == 'B') return null;
    if (octave == 8 && noteName == 'C') return null;

    int positionInOctave = whiteKeys.indexOf(noteName);
    if (blackKeyPositions.contains(positionInOctave)) {
      int blackKeyIndex = blackKeyPositions.indexOf(positionInOctave);
      return '${blackKeys[blackKeyIndex]}$octave';
    }
    return null;
  }

  void _onKeyPressed(String note) {
    setState(() {
      _pressedKeys.add(note);
    });
    widget.onNotePressed?.call(note);
    _playNote(note);
  }

  Future<void> _reduceVolume(String note) async {
    if (!widget.enableAudio) return;

    _fadeOutTasks[note] = true;

    try {
      final keysToReduce =
          _audioPlayers.keys.where((key) => key.startsWith(note)).toList();

      for (final key in keysToReduce) {
        final audioPlayer = _audioPlayers[key];
        if (audioPlayer != null && audioPlayer.state == PlayerState.playing) {
          _fadeOutAudioInstance(audioPlayer, key);
        }
      }
    } catch (e) {
      debugPrint('Error reducing volume for note $note: $e');
    }
  }

  Future<void> _fadeOutAudioInstance(
      AudioPlayer audioPlayer, String key) async {
    try {
      const fadeDuration = Duration(milliseconds: 1000);
      const steps = 20;
      final stepDuration = fadeDuration.inMilliseconds ~/ steps;
      const volumeStep = 1.0 / steps;

      for (int i = 0; i < steps; i++) {
        final noteName = key.split('_')[0];
        if (_fadeOutTasks[noteName] == false) {
          break;
        }

        await Future.delayed(Duration(milliseconds: stepDuration));
        final newVolume = 1.0 - (volumeStep * (i + 1));
        if (newVolume > 0) {
          await audioPlayer.setVolume(newVolume);
        } else {
          await audioPlayer.stop();
          break;
        }
      }
    } catch (e) {
      debugPrint('Error fading out audio instance $key: $e');
    }
  }

  void _onKeyReleased(String note) {
    setState(() {
      _pressedKeys.remove(note);
    });
    widget.onNoteReleased?.call(note);
    _reduceVolume(note);
  }
}

// Example usage widget
class PianoExample extends StatefulWidget {
  const PianoExample({super.key});

  @override
  State<PianoExample> createState() => _PianoExampleState();
}

class _PianoExampleState extends State<PianoExample> {
  String? currentNote;
  List<String> highlightedKeys = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('88-Key Piano Widget'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (currentNote != null)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Current Note: $currentNote',
                style:
                    const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
          PianoWidget(
            keyHeight: 150,
            keyWidth: 40,
            minKeyWidth: 20,
            maxKeyWidth: 60,
            showNoteLabels: true,
            showControls: true,
            keyAspectRatio: 4.0,
            enableAudio: true,
            audioVolume: 0.7,
            highlightedKeys: highlightedKeys,
            onNotePressed: (note) {
              setState(() {
                currentNote = note;
                highlightedKeys = [note];
              });
            },
            onNoteReleased: (note) {
              setState(() {
                currentNote = null;
                highlightedKeys = [];
              });
            },
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    highlightedKeys = ['C4', 'E4', 'G4'];
                  });
                },
                child: const Text('C Major'),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    highlightedKeys = [
                      'A0',
                      'A1',
                      'A2',
                      'A3',
                      'A4',
                      'A5',
                      'A6',
                      'A7'
                    ];
                  });
                },
                child: const Text('All A Notes'),
              ),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    highlightedKeys = ['C8'];
                  });
                },
                child: const Text('Highest C'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
