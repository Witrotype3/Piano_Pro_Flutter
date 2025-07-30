class Note {
  final String name;
  final int staffPosition;

  const Note(this.name, this.staffPosition);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Note &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          staffPosition == other.staffPosition;

  @override
  int get hashCode => name.hashCode ^ staffPosition.hashCode;

  @override
  String toString() => 'Note(name: $name, staffPosition: $staffPosition)';
}
