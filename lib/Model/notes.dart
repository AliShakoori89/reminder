import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:reminder/DB/databasehelper.dart';

class Todo {
  int id, priority;
  String title, description, reminder;

  DateTime get getReminder {
    return DateTime.tryParse(reminder);
  }

  String get getFormatedDate {
    if (reminder.isNotEmpty)
      return DateFormat('MMM d, ').format(getReminder) +
          DateFormat.jm().format(getReminder);
    else
      return '';
  }

  //CHANGE ME IF(a new proprity is added to the [Note])
  static const tableCreation = 'id INTEGER PRIMARY KEY,' +
      'priority INTEGER,' +
      'title TEXT,' +
      'description TEXT,' +
      'reminder TEXT ';

//CHANGE ME IF(a new proprity is added to the [Note])
  Todo({
    this.priority = 0,
    this.title = '',
    this.description = '',
    this.reminder = '',
  });

//CHANGE ME IF(a new proprity is added to the [Note])
  Todo.fromRow(Map<String, dynamic> row) {
    id = row['id'];
    priority = row['priority'];
    title = row['title'];
    description = row['description'];
    reminder = row['reminder'];
  }

//CHANGE ME IF(a new proprity is added to the [Note])
  Map<String, dynamic> toRow() {
    return {
      'id': id,
      'priority': priority,
      'title': title,
      'description': description,
      'reminder': reminder
    };
  }

//CHANGE ME IF(a new proprity is added to the [Note])
  void copyValuesFrom(Todo todo) {
    id = todo.id;
    priority = todo.priority;
    title = todo.title;
    description = todo.description;
    reminder = todo.reminder;
  }

  @override
  bool operator ==(Object o2) {
    if (o2 is! Todo) return false;

    Todo n2 = o2;

    if (id != n2.id ||
        title != n2.title ||
        description != n2.description ||
        priority != n2.priority ||
        reminder != n2.reminder) return false;

    return true;
  }
}

class Todos extends ChangeNotifier {
  List<Map<String, dynamic>> _todos;

  int todosLength = 0;

  List<Map<String, dynamic>> get todos => _todos;

  Todos() {
    _load();
  }

  Future<void> _load() async {
    _todos = await AppDatabase.getTableRows();
    todosLength = _todos.length;
    notifyListeners();
  }

  Future<int> add(Todo note) async {
    note.id = await AppDatabase.nextRowId();

    await AppDatabase.insertRow(note.toRow());
    _todos.add(note.toRow());

    todosLength++;

    _todos.sort((Map<String, dynamic> r1, Map<String, dynamic> r2) {
      if (r1['priority'] > r2['priority']) return -1;
      if (r1['priority'] < r2['priority']) return 1;

      return 0;
    });

    notifyListeners();

    return note.id;
  }

  Future<int> update(Todo note) async {
    await AppDatabase.updateRow(note.toRow(), where: 'id = ${note.id}');

    for (int i = 0; i < _todos.length; i++)
      if (_todos[i]['id'] == note.id) {
        _todos[i] = note.toRow();
        break;
      }

    _todos.sort((Map<String, dynamic> r1, Map<String, dynamic> r2) {
      if (r1['priority'] > r2['priority']) return -1;
      if (r1['priority'] < r2['priority']) return 1;

      return 0;
    });

    notifyListeners();
    return note.id;
  }

  Future<int> remove(Todo note) async {
    await AppDatabase.deleteRow('id = ${note.id}');

    for (int i = 0; i < _todos.length; i++)
      if (_todos[i]['id'] == note.id) {
        _todos.removeAt(i);
        break;
      }
    todosLength--;

    notifyListeners();
    return note.id;
  }

  Future<void> removeAll() async {
    await AppDatabase.deleteAllRows();
    _todos.clear();
    todosLength = 0;
    notifyListeners();
  }

  //CHANGE ME IF(a new proprity is added to the [Note])
  String toCSV() {
    String s = '';

    for (Map<String, dynamic> field in _todos)
      s +=
      '${field['id']},${field['priority']},${field['title']},${field['description']},${field['reminder']}\n';

    return s;
  }

  Future<bool> fromCSV(String csv) async {
    csv = csv.trim();

    final newNotes = List<Todo>();

    List<String> lines = csv.split('\n');

    try {
      for (String line in lines) {
        List<String> values = line.split(',');

        int id = int.parse(values[0]);
        int priority = int.parse(values[1]);
        String reminder = values[4];

        if (priority < 0 || priority > 2 || id.isNegative || id.isInfinite)
          return false;

        final note = Todo.fromRow(
          {
            'id': id,
            'priority': priority,
            'title': values[2],
            'description': values[3],
            'reminder': reminder,
          },
        );

        newNotes.add(note);
      }
    } catch (e) {
      return false;
    }

    await removeAll();

    for (Todo note in newNotes) await add(note);

    await _load();
    notifyListeners();

    return true;
  }
}
