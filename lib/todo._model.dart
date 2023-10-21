import 'dart:math';

class Todo {
  int id;
  String? todo;
  bool isCompleted;
  Todo({
    required this.id,
    required this.todo,
    this.isCompleted = false,
  });

  void generateRandVal() {
    id = Random().nextInt(100);
  }
}
