// import 'package:isar/isar.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:todo_isar_db/todo._model.dart';

// class Repository {
//   late Future<Isar> db;
//   Repository() {
//     db = openDb();
//   }

//   Future<Isar> openDb() async {
//     if (Isar.instanceNames.isEmpty) {
//       final dir = await getApplicationDocumentsDirectory();
//       return await Isar.open(
//         [TodoSchema],
//         inspector: true,
//         directory: dir.path,
//       );
//     }
//     return Future.value(Isar.getInstance());
//   }

//   Future<void> addTodo(Todo newTodo) async {
//     final isar = await db;
//     isar.writeTxnSync(() {
//       isar.todos.putSync(newTodo);
//     });
//   }

//   Future<void> deleteTodo(int id) async {
//     final isar = await db;
//     await isar.writeTxn(() async {
//       await isar.todos.delete(id);
//     });
//   }

//   Future<void> updateTodo(Todo todo) async {
//     final isar = await db;
//     await isar.writeTxn(() async {
//       await isar.todos.put(todo);
//     });
//   }

//   Future<Todo?> getTodo(int id) async {
//     final isar = await db;
//     return await isar.todos.get(id);
//   }

//   Future<List<Todo>> getTodos() async {
//     final isar = await db;
//     return await isar.todos.where().findAll();
//   }

//   Stream<List<Todo>> listenToTodos() async* {
//     final isar = await db;
//     yield* isar.todos.where().watch(fireImmediately: true);
//   }
// }
