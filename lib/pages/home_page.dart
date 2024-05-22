import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:to_do_app/data/database.dart';
import 'package:to_do_app/utils/to_do_tile.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _myBox = Hive.box('mybox');
  var taskController = TextEditingController();
  DataBase db = DataBase();

  @override
  void initState() {
    if (_myBox.get('TODOLIST') == null) {
      db.createInitialData();
    } else {
      db.loadData();
    }
    super.initState();
  }

  void changeCheckbox(bool? value, int index) {
    setState(() {
      db.toDoList[index][1] = !db.toDoList[index][1];
    });
    db.updateDataBase();
  }

  void addTask() {
    setState(() {
      db.toDoList.add([taskController.text, false]);
      taskController.clear();
    });
    Navigator.pop(context);
    db.updateDataBase();
  }

  void cancel() {
    Navigator.pop(context);
  }

  void delete(int index) {
    setState(() {
      db.toDoList.removeAt(index);
    });
    db.updateDataBase();
  }

  void createTask() {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Colors.yellow,
            content: Container(
              height: 150,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextField(
                    controller: taskController,
                    decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Enter Your Task'),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.yellow),
                        onPressed: cancel,
                        child: const Text(
                          'Cancel',
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                      const SizedBox(
                        width: 50,
                      ),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.yellow),
                        onPressed: addTask,
                        child: const Text('Add Task',
                            style: TextStyle(color: Colors.black)),
                      )
                    ],
                  )
                ],
              ),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow[200],
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.yellow,
        onPressed: createTask,
        child: const Icon(Icons.add),
      ),
      appBar: AppBar(
        backgroundColor: Colors.yellow,
        title: const Center(child: Text('To Do')),
      ),
      body: ListView.builder(
        itemCount: db.toDoList.length,
        itemBuilder: (context, index) => ToDoTile(
          name: db.toDoList[index][0],
          onChanged: (p0) {
            changeCheckbox(p0, index);
          },
          taskCompleted: db.toDoList[index][1],
          onPressed: (context) {
            delete(index);
          },
        ),
      ),
    );
  }
}
