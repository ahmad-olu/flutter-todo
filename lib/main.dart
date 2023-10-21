import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:todo_isar_db/todo._model.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: TodoPage(),
    );
  }
}

class TodoPage extends HookWidget {
  const TodoPage({super.key});

  @override
  Widget build(BuildContext context) {
    final todoController = useTextEditingController(text: '');
    final todos = useState<List<Todo>>([]);
    final todoValue = useState<String>('');
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Todos',
          style: TextStyle(
            color: Color.fromARGB(255, 4, 50, 87),
          ),
          textScaleFactor: 2,
        )
            .animate(
              onPlay: (controller) =>
                  controller.repeat(reverse: true, period: 7000.ms),
            )
            .fade(duration: 1000.ms)
            .scale(duration: 10.ms),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
        child: todos.value.isEmpty
            ? const Center(
                child: Text("No todos yet!!"),
              )
            : Padding(
                padding: const EdgeInsets.only(bottom: 30),
                child: ListView.builder(
                  itemCount: todos.value.length,
                  itemBuilder: (context, index) {
                    final todo = todos.value[index];
                    return Card(
                      elevation: 5.0,
                      child: SizedBox(
                        height: 50,
                        child: Center(
                          child: ListTile(
                            title: Text(
                              todo.todo!,
                              textScaleFactor: 1.5,
                              textAlign: TextAlign.left,
                            ),
                            titleAlignment: ListTileTitleAlignment.center,
                            leading: Checkbox.adaptive(
                              value: todo.isCompleted,
                              onChanged: (value) {
                                todos.value = todos.value.map((e) {
                                  if (e.id == todo.id) {
                                    return Todo(
                                      id: e.id,
                                      todo: e.todo,
                                      isCompleted: value!,
                                    );
                                  }
                                  return e;
                                }).toList();
                              },
                            ),
                            trailing: SizedBox(
                              width: 60,
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: 30,
                                    child: IconButton(
                                      onPressed: () {
                                        if (todoValue.value.isNotEmpty) {
                                          todos.value = todos.value.map((e) {
                                            if (e.id == todo.id) {
                                              return Todo(
                                                id: e.id,
                                                todo: todoValue.value,
                                                isCompleted: e.isCompleted,
                                              );
                                            }
                                            return e;
                                          }).toList();
                                          todoValue.value = '';
                                          todoController.text = '';
                                        }
                                      },
                                      icon: const Icon(
                                        Icons.update,
                                        color: Colors.green,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width: 30,
                                    child: IconButton(
                                      onPressed: () {
                                        todos.value = todos.value
                                            .where((element) =>
                                                element.id != todo.id)
                                            .toList();
                                      },
                                      icon: const Icon(
                                        Icons.delete,
                                        color: Colors.red,
                                      )
                                          .animate(
                                        onPlay: (controller) =>
                                            controller.repeat(),
                                      )
                                          .shimmer(
                                        colors: [
                                          const Color.fromARGB(255, 78, 8, 3),
                                          const Color.fromARGB(255, 151, 14, 5),
                                          const Color.fromARGB(
                                              255, 118, 138, 4),
                                          const Color.fromARGB(
                                              255, 207, 214, 6),
                                          const Color.fromARGB(
                                              255, 112, 34, 28),
                                          Colors.red
                                        ],
                                        duration: 1000.ms,
                                        delay: 1000.ms,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                        .animate()
                        .fadeIn(duration: 600.ms)
                        .blur(begin: const Offset(2, 5))
                        //.then(delay: 100.ms) // baseline=800ms
                        .slide();
                  },
                ),
              ),
      ),
      bottomSheet: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
        child: Row(
          children: [
            Expanded(
                flex: 5,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 22),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    decoration: BoxDecoration(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10)),
                        border: Border.all(
                          color: Colors.black,
                          width: 3,
                        )),
                    child: TextField(
                      controller: todoController,
                      decoration:
                          const InputDecoration(border: InputBorder.none),
                      onChanged: (value) {
                        todoValue.value = value;
                        todoController.text = todoValue.value;
                      },
                    ),
                  ),
                )),
            Expanded(
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 4, 44, 78),
                  fixedSize: const Size(100, 50),
                ),
                onPressed: () {
                  if (todoValue.value.isNotEmpty) {
                    final data =
                        Todo(id: Random().nextInt(100), todo: todoValue.value);
                    todos.value = [...todos.value, data];
                    todoValue.value = '';
                    todoController.text = '';
                  }
                },
                child: const Text('Add'),
              ),
            )
          ],
        ),
      ),
    );
  }
}
