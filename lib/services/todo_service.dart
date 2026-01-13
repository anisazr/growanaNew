// lib/services/todo_service.dart
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/todo_item.dart';

class TodoService extends ChangeNotifier {
  static final TodoService _instance = TodoService._internal();
  factory TodoService() => _instance;
  TodoService._internal() {
    _loadTodos();
  }

  final ValueNotifier<List<TodoItem>> _todos = ValueNotifier([]);
  ValueNotifier<List<TodoItem>> get todos => _todos;

  static const String _keyTodos = 'todos';

  // Get all todos
  List<TodoItem> get allTodos => _todos.value;

  // Get active todos (not completed)
  List<TodoItem> get activeTodos => 
      _todos.value.where((todo) => !todo.isCompleted).toList();

  // Get completed todos
  List<TodoItem> get completedTodos => 
      _todos.value.where((todo) => todo.isCompleted).toList();

  // Get todos by category
  List<TodoItem> getTodosByCategory(String category) => 
      _todos.value.where((todo) => todo.category == category).toList();

  // Add new todo
  Future<void> addTodo(TodoItem todo) async {
    _todos.value = [..._todos.value, todo];
    await _saveTodos();
    notifyListeners();
  }

  // Update todo
  Future<void> updateTodo(String id, TodoItem updatedTodo) async {
    final index = _todos.value.indexWhere((todo) => todo.id == id);
    if (index != -1) {
      final newTodos = List<TodoItem>.from(_todos.value);
      newTodos[index] = updatedTodo;
      _todos.value = newTodos;
      await _saveTodos();
      notifyListeners();
    }
  }

  // Toggle completion status
  Future<void> toggleTodo(String id) async {
    final index = _todos.value.indexWhere((todo) => todo.id == id);
    if (index != -1) {
      final todo = _todos.value[index];
      final updatedTodo = todo.copyWith(isCompleted: !todo.isCompleted);
      
      final newTodos = List<TodoItem>.from(_todos.value);
      newTodos[index] = updatedTodo;
      _todos.value = newTodos;
      await _saveTodos();
      notifyListeners();
    }
  }

  // Delete todo
  Future<void> deleteTodo(String id) async {
    _todos.value = _todos.value.where((todo) => todo.id != id).toList();
    await _saveTodos();
    notifyListeners();
  }

  // Delete all completed todos
  Future<void> deleteCompleted() async {
    _todos.value = _todos.value.where((todo) => !todo.isCompleted).toList();
    await _saveTodos();
    notifyListeners();
  }

  // Load todos from SharedPreferences
  Future<void> _loadTodos() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final todosJson = prefs.getString(_keyTodos) ?? '[]';
      final List<dynamic> todosList = jsonDecode(todosJson);
      
      _todos.value = todosList
          .map((item) => TodoItem.fromMap(item))
          .toList();
      
      notifyListeners();
    } catch (e) {
      print('Error loading todos: $e');
    }
  }

  // Save todos to SharedPreferences
  Future<void> _saveTodos() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final todosJson = jsonEncode(_todos.value.map((todo) => todo.toMap()).toList());
      await prefs.setString(_keyTodos, todosJson);
    } catch (e) {
      print('Error saving todos: $e');
    }
  }

  // Generate unique ID
  String generateId() {
    return DateTime.now().millisecondsSinceEpoch.toString();
  }
}