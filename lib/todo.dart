class Todo {
  int? id;
  String nama;
  String deskripsi;
  bool done;

  Todo(this.nama, this.deskripsi, {this.done = false, this.id});

  static List<Todo> dummyData = [
    Todo("Latihan menggambar", "Latihan perlombaan menggambar"),
    Todo("Makan malam", "Makan malam bersama camer", done: true),
    Todo("Bernyanyi bersama", "Nyanyi bersama teman-teman"),
  ];
}
