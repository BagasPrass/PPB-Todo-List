import 'package:flutter/material.dart';
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
  List<Todo> todoList = Todo.dummyData;

  void refreshList() async {
    setState(() {
      todoList = todoList;
    });
  }

  void addItem() async {
    todoList.add(Todo(_namaCtrl.text, _deskripsiCtrl.text));
    refreshList();

    _namaCtrl.text = '';
    _deskripsiCtrl.text = '';
  }

  void updateItem(int index, bool done) async {
    todoList[index].done = done;
    refreshList();
  }

  void deleteItem(int id) async {
    todoList.removeAt(id);
    refreshList();
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
                        onPressed: () => deleteItem(index),
                        icon: const Icon(Icons.delete),
                      ),
                    );
                  })),
        ],
      ),
    );
  }
}
