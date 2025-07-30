import 'dart:math';
import 'package:flutter/material.dart';
import 'package:connect_to_go_server_flutter/constants/staff_config.dart';
import '../models/note_model.dart';

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

    final staffHeight = (lineCount - 1) * lineSpacing;
    final staffCenterY = size.height / 2;
    final staffTopY = staffCenterY - staffHeight / 2;

    for (int i = 0; i < lineCount; i++) {
      final y = staffTopY + i * lineSpacing;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), linePaint);
    }

    final clefFontSize = staffHeight * 1;
    final clefSpan = TextSpan(
      text: '\uE050', // SMuFL G clef (U+E050)
      style: TextStyle(
        color: lineColor,
        fontSize: clefFontSize,
        fontFamily: 'Bravura',
      ),
    );

    final clefPainter = TextPainter(
      text: clefSpan,
      textDirection: TextDirection.ltr,
    );
    clefPainter.layout();
    final gLineY = staffTopY + lineSpacing * 1;

    final clefOffsetY = gLineY - clefPainter.height / 2 + 40;

    clefPainter.paint(
      canvas,
      Offset(size.width * 0.05, clefOffsetY),
    );

    final notePaint = Paint()..color = noteColor;
    final noteRadiusX = lineSpacing * 0.6;
    final noteRadiusY = lineSpacing * 0.4;
    final noteStemHeight = lineSpacing * 3.5;

    final noteCenterY =
        staffTopY + (8 - note.staffPosition) * (lineSpacing / 2);
    final noteCenterX = size.width * 0.5;

    if (note.staffPosition < 0 || note.staffPosition > 8) {
      int startPos = note.staffPosition < 0 ? note.staffPosition : 10;
      int endPos = note.staffPosition < 0 ? -1 : note.staffPosition;
      for (int pos = startPos; pos <= endPos; pos += 2) {
        final ledgerY = staffTopY + (8 - pos) * (lineSpacing / 2);
        canvas.drawLine(
          Offset(noteCenterX - lineSpacing * 1.5, ledgerY),
          Offset(noteCenterX + lineSpacing * 1.5, ledgerY),
          linePaint,
        );
      }
    }

    canvas.save();
    canvas.translate(noteCenterX, noteCenterY);
    final rotationAngle = -15 * pi / 180;
    canvas.rotate(rotationAngle);
    final noteRect = Rect.fromCenter(
      center: Offset(0, 0),
      width: noteRadiusX * 2,
      height: noteRadiusY * 2,
    );
    canvas.drawOval(noteRect, notePaint);
    canvas.restore();

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
    return oldDelegate.note != note ||
        oldDelegate.noteColor != noteColor ||
        oldDelegate.lineColor != lineColor;
  }
}
