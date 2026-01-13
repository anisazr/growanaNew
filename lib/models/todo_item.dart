// lib/models/todo_item.dart
class TodoItem {
  final String id;
  final String title;
  final String? description;
  final DateTime createdAt;
  final DateTime? dueDate;
  bool isCompleted;
  final String category; // 'tanaman', 'pameran', 'umum'

  TodoItem({
    required this.id,
    required this.title,
    this.description,
    DateTime? createdAt,
    this.dueDate,
    this.isCompleted = false,
    this.category = 'umum',
  }) : createdAt = createdAt ?? DateTime.now();

  // Convert to Map for SharedPreferences
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'createdAt': createdAt.toIso8601String(),
      'dueDate': dueDate?.toIso8601String(),
      'isCompleted': isCompleted,
      'category': category,
    };
  }

  // Create from Map
  factory TodoItem.fromMap(Map<String, dynamic> map) {
    return TodoItem(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      description: map['description'],
      createdAt: DateTime.parse(map['createdAt']),
      dueDate: map['dueDate'] != null ? DateTime.parse(map['dueDate']) : null,
      isCompleted: map['isCompleted'] ?? false,
      category: map['category'] ?? 'umum',
    );
  }

  // Copy with
  TodoItem copyWith({
    String? id,
    String? title,
    String? description,
    DateTime? createdAt,
    DateTime? dueDate,
    bool? isCompleted,
    String? category,
  }) {
    return TodoItem(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      dueDate: dueDate ?? this.dueDate,
      isCompleted: isCompleted ?? this.isCompleted,
      category: category ?? this.category,
    );
  }
}