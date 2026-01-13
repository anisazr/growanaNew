// lib/widgets/todo_list_widget.dart
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/todo_service.dart';
import '../models/todo_item.dart';

class TodoListWidget extends StatefulWidget {
  final String? categoryFilter;
  final bool showCompleted;

  const TodoListWidget({
    super.key,
    this.categoryFilter,
    this.showCompleted = false,
  });

  @override
  State<TodoListWidget> createState() => _TodoListWidgetState();
}

class _TodoListWidgetState extends State<TodoListWidget> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  DateTime? _selectedDueDate;
  String _selectedCategory = 'umum';

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _showAddTodoDialog() async {
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Tambah Todo Baru'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    labelText: 'Judul Todo',
                    border: OutlineInputBorder(),
                  ),
                  maxLength: 50,
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Deskripsi (opsional)',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: _selectedCategory,
                  decoration: const InputDecoration(
                    labelText: 'Kategori',
                    border: OutlineInputBorder(),
                  ),
                  items: const [
                    DropdownMenuItem(
                      value: 'umum',
                      child: Text('Umum'),
                    ),
                    DropdownMenuItem(
                      value: 'tanaman',
                      child: Text('Tanaman'),
                    ),
                    DropdownMenuItem(
                      value: 'pameran',
                      child: Text('Pameran'),
                    ),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _selectedCategory = value!;
                    });
                  },
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Text('Tanggal Jatuh Tempo:'),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextButton(
                        onPressed: () async {
                          final date = await showDatePicker(
                            context: context,
                            firstDate: DateTime.now(),
                            lastDate: DateTime(2100),
                            initialDate: DateTime.now().add(const Duration(days: 1)),
                          );
                          if (date != null) {
                            setState(() {
                              _selectedDueDate = date;
                            });
                          }
                        },
                        child: Text(
                          _selectedDueDate == null
                              ? 'Pilih Tanggal'
                              : '${_selectedDueDate!.day}/${_selectedDueDate!.month}/${_selectedDueDate!.year}',
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _clearForm();
              },
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () {
                _addTodo();
                Navigator.pop(context);
                _clearForm();
              },
              child: const Text('Tambah'),
            ),
          ],
        );
      },
    );
  }

  void _addTodo() {
    if (_titleController.text.trim().isEmpty) return;

    final todoService = Provider.of<TodoService>(context, listen: false);
    final newTodo = TodoItem(
      id: todoService.generateId(),
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim().isEmpty 
          ? null 
          : _descriptionController.text.trim(),
      dueDate: _selectedDueDate,
      category: _selectedCategory,
    );

    todoService.addTodo(newTodo);
  }

  void _clearForm() {
    _titleController.clear();
    _descriptionController.clear();
    _selectedDueDate = null;
    _selectedCategory = 'umum';
  }

  Widget _buildTodoItem(TodoItem todo) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
      child: ListTile(
        leading: Checkbox(
          value: todo.isCompleted,
          onChanged: (value) {
            Provider.of<TodoService>(context, listen: false)
                .toggleTodo(todo.id);
          },
        ),
        title: Text(
          todo.title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            decoration: todo.isCompleted 
                ? TextDecoration.lineThrough 
                : TextDecoration.none,
            color: todo.isCompleted ? Colors.grey : null,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (todo.description != null && todo.description!.isNotEmpty)
              Text(
                todo.description!,
                style: const TextStyle(fontSize: 12),
              ),
            if (todo.dueDate != null)
              Text(
                'Jatuh tempo: ${_formatDate(todo.dueDate!)}',
                style: TextStyle(
                  fontSize: 11,
                  color: todo.dueDate!.isBefore(DateTime.now()) && !todo.isCompleted
                      ? Colors.red
                      : Colors.grey,
                ),
              ),
            Chip(
              label: Text(
                _getCategoryLabel(todo.category),
                style: const TextStyle(fontSize: 10),
              ),
              backgroundColor: _getCategoryColor(todo.category),
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 0),
              visualDensity: VisualDensity.compact,
            ),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete, size: 20),
          onPressed: () {
            Provider.of<TodoService>(context, listen: false)
                .deleteTodo(todo.id);
          },
        ),
        onTap: () {
          _showEditTodoDialog(todo);
        },
      ),
    );
  }

  void _showEditTodoDialog(TodoItem todo) {
    _titleController.text = todo.title;
    _descriptionController.text = todo.description ?? '';
    _selectedDueDate = todo.dueDate;
    _selectedCategory = todo.category;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Todo'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: _titleController,
                  decoration: const InputDecoration(
                    labelText: 'Judul Todo',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Deskripsi',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String>(
                  value: _selectedCategory,
                  decoration: const InputDecoration(
                    labelText: 'Kategori',
                    border: OutlineInputBorder(),
                  ),
                  items: const [
                    DropdownMenuItem(
                      value: 'umum',
                      child: Text('Umum'),
                    ),
                    DropdownMenuItem(
                      value: 'tanaman',
                      child: Text('Tanaman'),
                    ),
                    DropdownMenuItem(
                      value: 'pameran',
                      child: Text('Pameran'),
                    ),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _selectedCategory = value!;
                    });
                  },
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Text('Tanggal Jatuh Tempo:'),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextButton(
                        onPressed: () async {
                          final date = await showDatePicker(
                            context: context,
                            firstDate: DateTime.now(),
                            lastDate: DateTime(2100),
                            initialDate: _selectedDueDate ?? DateTime.now(),
                          );
                          if (date != null) {
                            setState(() {
                              _selectedDueDate = date;
                            });
                          }
                        },
                        child: Text(
                          _selectedDueDate == null
                              ? 'Pilih Tanggal'
                              : '${_selectedDueDate!.day}/${_selectedDueDate!.month}/${_selectedDueDate!.year}',
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                _clearForm();
              },
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () {
                _updateTodo(todo);
                Navigator.pop(context);
                _clearForm();
              },
              child: const Text('Simpan'),
            ),
          ],
        );
      },
    );
  }

  void _updateTodo(TodoItem originalTodo) {
    if (_titleController.text.trim().isEmpty) return;

    final todoService = Provider.of<TodoService>(context, listen: false);
    final updatedTodo = originalTodo.copyWith(
      title: _titleController.text.trim(),
      description: _descriptionController.text.trim().isEmpty 
          ? null 
          : _descriptionController.text.trim(),
      dueDate: _selectedDueDate,
      category: _selectedCategory,
    );

    todoService.updateTodo(originalTodo.id, updatedTodo);
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  String _getCategoryLabel(String category) {
    switch (category) {
      case 'tanaman':
        return 'Tanaman';
      case 'pameran':
        return 'Pameran';
      default:
        return 'Umum';
    }
  }

  Color _getCategoryColor(String category) {
    switch (category) {
      case 'tanaman':
        return Colors.green.withOpacity(0.2);
      case 'pameran':
        return Colors.blue.withOpacity(0.2);
      default:
        return Colors.grey.withOpacity(0.2);
    }
  }

  @override
  Widget build(BuildContext context) {
    final todoService = Provider.of<TodoService>(context);

    List<TodoItem> filteredTodos = widget.showCompleted
        ? todoService.completedTodos
        : todoService.activeTodos;

    if (widget.categoryFilter != null) {
      filteredTodos = filteredTodos
          .where((todo) => todo.category == widget.categoryFilter)
          .toList();
    }

    // Sort by due date (soonest first)
    filteredTodos.sort((a, b) {
      if (a.dueDate == null && b.dueDate == null) return 0;
      if (a.dueDate == null) return 1;
      if (b.dueDate == null) return -1;
      return a.dueDate!.compareTo(b.dueDate!);
    });

    return ValueListenableBuilder<List<TodoItem>>(
      valueListenable: todoService.todos,
      builder: (context, todos, child) {
        return Column(
          children: [
            // Header dengan statistik
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Todo List',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                      Text(
                        '${todoService.activeTodos.length} aktif • ${todoService.completedTodos.length} selesai',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                  ElevatedButton.icon(
                    icon: const Icon(Icons.add),
                    label: const Text('Tambah'),
                    onPressed: _showAddTodoDialog,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
            ),

            // List todos
            if (filteredTodos.isEmpty)
              Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  children: [
                    Icon(
                      widget.showCompleted
                          ? Icons.check_circle_outline
                          : Icons.list,
                      size: 64,
                      color: Colors.grey[400],
                    ),
                    const SizedBox(height: 16),
                    Text(
                      widget.showCompleted
                          ? 'Belum ada todo yang selesai'
                          : 'Tidak ada todo aktif',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                    if (!widget.showCompleted)
                      TextButton(
                        onPressed: _showAddTodoDialog,
                        child: const Text('Buat todo pertama'),
                      ),
                  ],
                ),
              )
            else
              Expanded(
                child: ListView.builder(
                  itemCount: filteredTodos.length,
                  itemBuilder: (context, index) {
                    return _buildTodoItem(filteredTodos[index]);
                  },
                ),
              ),

            // Footer actions
            if (todoService.completedTodos.isNotEmpty && !widget.showCompleted)
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${todoService.completedTodos.length} todo selesai',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.grey,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        todoService.deleteCompleted();
                      },
                      child: const Text(
                        'Hapus yang selesai',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ],
                ),
              ),
          ],
        );
      },
    );
  }
}