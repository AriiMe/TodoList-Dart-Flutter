import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(MyApp());
}

// Define the main app widget
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Todo List',
      theme: ThemeData(
        primarySwatch: Colors.yellow,
        textTheme: GoogleFonts.poppinsTextTheme(),
      ),
      home: TodoList(),
    );
  }
}

// StatefulWidget for the TodoList
class TodoList extends StatefulWidget {
  @override
  _TodoListState createState() => _TodoListState();
}

// State for the TodoList StatefulWidget
class _TodoListState extends State<TodoList> {
  List<String> _todoItems = [];

  // Function to add a todo item
  void _addTodoItem(String task) {
    if (task.length > 0) {
      setState(() => _todoItems.add(task));
      _saveTodoItems();
    }
  }

  // Function to remove a completed todo item
  void _removeTodoItem(int index) {
    setState(() => _todoItems.removeAt(index));
    _saveTodoItems();
  }

  // Save the todo items to local storage
  Future<void> _saveTodoItems() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList('todoItems', _todoItems);
  }

  // Load the todo items from local storage
  Future<void> _loadTodoItems() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _todoItems = prefs.getStringList('todoItems') ?? [];
    });
  }

  @override
  void initState() {
    super.initState();
    _loadTodoItems();
  }

  // Function to build the list of todo items
  Widget _buildTodoList() {
    return ListView.builder(
      itemBuilder: (context, index) {
        if (index < _todoItems.length) {
          return _buildTodoItem(_todoItems[index], index);
        }
        return null;
      },
    );
  }

  // Function to build a single todo item
  Widget _buildTodoItem(String todoText, int index) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      margin: EdgeInsets.all(8),
      color: Colors.yellow.shade200,
      child: ListTile(
        title: Text(todoText, style: TextStyle(fontWeight: FontWeight.w500)),
        trailing: IconButton(
          icon: Icon(Icons.delete, color: Colors.red),
          onPressed: () => _removeTodoItem(index),
        ),
      ),
    );
  }

  // Function to show the add todo item dialog
  void _showAddTodoDialog(BuildContext context) {
    TextEditingController _textFieldController = TextEditingController();

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Add a new task'),
            content: TextField(
              controller: _textFieldController,
              decoration: InputDecoration(hintText: "Enter task here"),
            ),
            actions: <Widget>[
              TextButton(
                child: Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: Text('Add'),
                onPressed: () {
                  _addTodoItem(_textFieldController.text);
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Todo List')),
      body: _buildTodoList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddTodoDialog(context),
        tooltip: 'Add task',
        child: Icon(Icons.add),
        backgroundColor: Colors.yellow.shade700,
      ),
    );
  }
}
