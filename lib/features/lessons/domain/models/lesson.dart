import 'package:flutter/material.dart';

class Lesson {
  final String id;
  final String title;
  final String imagePath;
  final IconData icon;
  final String description;
  final bool isCompleted;
  final int difficulty;

  const Lesson({
    required this.id,
    required this.title,
    required this.imagePath,
    required this.icon,
    required this.description,
    this.isCompleted = false,
    this.difficulty = 1,
  });

  factory Lesson.fromMap(Map<String, dynamic> map) {
    return Lesson(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      imagePath: map['imagePath'] ?? '',
      icon: _getIconFromString(map['icon'] ?? ''),
      description: map['description'] ?? '',
      isCompleted: map['isCompleted'] ?? false,
      difficulty: map['difficulty'] ?? 1,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'imagePath': imagePath,
      'icon': icon.codePoint,
      'description': description,
      'isCompleted': isCompleted,
      'difficulty': difficulty,
    };
  }

  Lesson copyWith({
    String? id,
    String? title,
    String? imagePath,
    IconData? icon,
    String? description,
    bool? isCompleted,
    int? difficulty,
  }) {
    return Lesson(
      id: id ?? this.id,
      title: title ?? this.title,
      imagePath: imagePath ?? this.imagePath,
      icon: icon ?? this.icon,
      description: description ?? this.description,
      isCompleted: isCompleted ?? this.isCompleted,
      difficulty: difficulty ?? this.difficulty,
    );
  }

  static IconData _getIconFromString(String iconName) {
    switch (iconName) {
      case 'music_note':
        return Icons.music_note;
      case 'queue_music':
        return Icons.queue_music;
      case 'hearing':
        return Icons.hearing;
      default:
        return Icons.music_note;
    }
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Lesson && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'Lesson(id: $id, title: $title, isCompleted: $isCompleted)';
  }
} 