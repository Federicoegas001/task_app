import 'package:hive_flutter/hive_flutter.dart';

class DataBase {
  List toDoList = [];

  final _myBox = Hive.box("mybox");

  void createInitialData() {
    toDoList = [
      ["Make Tutorial", false],
      ["Do excercise", false]
    ];
  }

  void loadData() {
    toDoList = _myBox.get('TODOLIST');
  }

  void updateDataBase() {
    _myBox.put("TODOLIST", toDoList);
  }
}
