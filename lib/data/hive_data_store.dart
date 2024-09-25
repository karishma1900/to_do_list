import 'package:flutter/foundation.dart';
// import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:to_do_application/models/task.dart';


// All crud operations hive
class HiveDataStore {
  // Box Name String
  static const boxName = 'tasksBox';

  // Our Current Box wiith asll the saved data insdide box<Tassk>
  final Box<Task> box = Hive.box<Task>(boxName);

  // Add New Tsk to box
  Future<void> addTask({required Task task}) async{
    await box.put(task.id,task);
  }

  // ShowTask 
  Future<Task?> getTask({required String id}) async{
    return box.get(id);

  }

  // Update Task 
  Future<void> updateTask({required Task task}) async{
    await task.save();
  }

  // Delete Task
  Future<void> deleteTask({required Task task}) async{
    await task.delete();
  }

  // listem to Box Changes
  // using this method we will listem to box changes and update the Ui accordingly

  ValueListenable<Box<Task>> listenToTask() {
    return box.listenable();
    }
}