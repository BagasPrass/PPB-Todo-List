import 'package:flutter/material.dart';
import 'package:todolist/database_helper.dart';
import 'package:todolist/todo.dart';

class TodoPage extends StatelessWidget {
  const TodoPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: TodoList(),
    );
  }
}

class TodoList extends StatefulWidget {
  const TodoList({
    super.key,
  });

  @override
  State<TodoList> createState() => _TodoList();
}

class _TodoList extends State<TodoList> {
  TextEditingController _namaCtrl = TextEditingController();
  TextEditingController _deskripsiCtrl = TextEditingController();
  TextEditingController _searchCtrl = TextEditingController();
  List<Todo> todoList = [];

  final dbHelper = DatabaseHelper();

  @override
  void initState() {
    super.initState();
    refreshList();
  }

  void refreshList() async {
    final todos = await dbHelper.getAllTodos();
    setState(() {
      todoList = todos;
    });
  }

  void addItem() async {
    await dbHelper.addTodo(Todo(_namaCtrl.text, _deskripsiCtrl.text));
    refreshList();

    _namaCtrl.text = '';
    _deskripsiCtrl.text = '';
  }

  void updateItem(int index, bool done) async {
    todoList[index].done = done;
    await dbHelper.updateTodo(todoList[index]);
    refreshList();
  }

  void deleteItem(int id) async {
    await dbHelper.deleteTodo(id);
    refreshList();
  }

  void cariTodo() async {
    String teks = _searchCtrl.text.trim();
    List<Todo> todos = [];
    if (teks.isEmpty) {
      todos = await dbHelper.getAllTodos();
    } else {
      todos = await dbHelper.searchTodo(teks);
    }

    setState(() {
      todoList = todos;
    });
  }

  void tampilForm() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
            title: const Text("Tambah Todo"),
            actions: [
              ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Tutup")),
              ElevatedButton(
                  onPressed: () {
                    addItem();
                    Navigator.pop(context);
                  },
                  child: const Text("Tambah")),
            ],
            content: Container(
              height: 200,
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: [
                  TextField(
                    controller: _namaCtrl,
                    decoration: InputDecoration(hintText: "Nama todo"),
                  ),
                  TextField(
                    controller: _deskripsiCtrl,
                    decoration:
                        InputDecoration(hintText: "Deskripsi pekerjaan"),
                  ),
                ],
              ),
            )));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Aplikasi Todo List')),
      floatingActionButton: FloatingActionButton(
        onPressed: () => tampilForm(),
        child: const Icon(Icons.add_box),
      ),
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: TextField(
              onChanged: (_) {
                cariTodo();
              },
              controller: _searchCtrl,
              decoration: InputDecoration(
                hintText: 'Cari apa?',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Expanded(
              child: ListView.builder(
                  itemCount: todoList.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      leading: IconButton(
                          onPressed: () =>
                              updateItem(index, !todoList[index].done),
                          icon: todoList[index].done
                              ? const Icon(Icons.check_circle)
                              : const Icon(Icons.radio_button_unchecked)),
                      title: Text(todoList[index].nama),
                      subtitle: Text(todoList[index].deskripsi),
                      trailing: IconButton(
                        onPressed: () => deleteItem(todoList[index].id ?? 0),
                        icon: const Icon(Icons.delete),
                      ),
                    );
                  })),
        ],
      ),
    );
  }
}
