import 'package:flutter/material.dart';
import 'package:flutter_todoo/database_helper.dart';
import 'package:flutter_todoo/models/todo.dart';
import 'package:flutter_todoo/widgets.dart';

import 'package:flutter_todoo/models/task.dart';

class TaskPage extends StatefulWidget {
  //retrieving the task
  final Task task;
  TaskPage({@required this.task});
  @override
  _TaskPageState createState() => _TaskPageState();
}

class _TaskPageState extends State<TaskPage> {
  DatabaseHelper _dbHelper = DatabaseHelper();

  int _taskId = 0;
  String _taskTitle = "";
  String _taskDescription = "";

  // Focus node
  FocusNode _titleFocus;
  FocusNode _descriptionFocus;
  FocusNode _todoFocus;

  bool _contentVisible = false;

  @override
  void initState() {
    //assigning the task
    //check if the title is available
    if (widget.task != null) {
      //set the visibility to true
      _contentVisible = true;
      _taskTitle = widget.task.title;
      _taskDescription = widget.task.description;
      _taskId = widget.task.id;
    }

    //initialize focus node
    _titleFocus = FocusNode();
    _descriptionFocus = FocusNode();
    _todoFocus = FocusNode();

    super.initState();
  }

  @override
  void dispose() {
    _titleFocus.dispose();
    _todoFocus.dispose();
    _descriptionFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
            child: Container(
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(top: 24, bottom: 6),
                child: Row(
                  children: [
                    // creates ripple effect on click
                    InkWell(
                      onTap: () {
                        // to go back to home page
                        Navigator.pop(context);
                      },
                      child: Padding(
                        padding: EdgeInsets.all(24.0),
                        child: Image(
                          image:
                              AssetImage('assets/images/back_arrow_icon.png'),
                        ),
                      ),
                    ),
                    Expanded(
                      child: TextField(
                        focusNode: _titleFocus,
                        //onsubmit for task
                        onSubmitted: (value) async {
                          // check if the field is not empty
                          if (value != "") {
                            //check if the task is null
                            if (widget.task == null) {
                              //creating a task instance
                              Task _newTask = Task(title: value);
                              // passing the information to db
                              _taskId = await _dbHelper.insertTask(_newTask);
                              setState(() {
                                _contentVisible = true;
                                _taskTitle = value;
                              });
                              print("New Task ID: $_taskId");
                            } else {
                              await _dbHelper.updateTaskTitle(_taskId, value);
                              print("updated new task");
                            }
                            _descriptionFocus.requestFocus();
                          }
                        },
                        //controller to get the task title in the widget
                        controller: TextEditingController()..text = _taskTitle,
                        // Task Title
                        decoration: InputDecoration(
                            hintText: "Enter Task Title",
                            border: InputBorder.none),
                        style: TextStyle(
                          fontSize: 26.0,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF211551),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              // Todo List
              Visibility(
                visible: _contentVisible,
                child: Padding(
                  padding: EdgeInsets.only(bottom: 12),
                  child: TextField(
                    focusNode: _descriptionFocus,
                    onSubmitted: (value) async {
                      if (value != "") {
                        if (_taskId != 0) {
                          await _dbHelper.updateTaskDescription(_taskId, value);
                          _taskDescription = value;
                        }
                      }
                      _todoFocus.requestFocus();
                    },
                    controller: TextEditingController()
                      ..text = _taskDescription,
                    decoration: InputDecoration(
                        hintText: "Enter the Description for the task...",
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(horizontal: 24)),
                  ),
                ),
              ),
              Visibility(
                visible: _contentVisible,
                child: FutureBuilder(
                    initialData: [],
                    future: _dbHelper.getTodo(_taskId),
                    builder: (context, snapshot) {
                      return Expanded(
                        child: ListView.builder(
                          itemCount: snapshot.data.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () async {
                                // change the state to true
                                if (snapshot.data[index].isDone == 0) {
                                  await _dbHelper.updateTodoDone(
                                      snapshot.data[index].id, 1);
                                } else {
                                  await _dbHelper.updateTodoDone(
                                      snapshot.data[index].id, 0);
                                }
                                setState(() {});
                              },
                              child: TodoWidget(
                                text: snapshot.data[index].title,
                                isDone: snapshot.data[index].isDone == 0
                                    ? false
                                    : true,
                              ),
                            );
                          },
                        ),
                      );
                    }),
              ),
              Visibility(
                visible: _contentVisible,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 24,
                  ),
                  child: Row(children: [
                    Container(
                      width: 20,
                      height: 20,
                      margin: EdgeInsets.only(right: 12),
                      decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(6),
                          border:
                              Border.all(color: Color(0xFF86829D), width: 1.5)),
                      child: Image(
                        image: AssetImage('assets/images/check_icon.png'),
                      ),
                    ),
                    Expanded(
                      child: TextField(
                        focusNode: _todoFocus,
                        controller: TextEditingController()..text = "",
                        //onsubmit to create in UI (To-DO)
                        onSubmitted: (value) async {
                          // check if the field is not empty
                          if (value != "") {
                            //check if the task is null
                            if (_taskId != 0) {
                              DatabaseHelper _dbHelper = DatabaseHelper();
                              //creating a task instance
                              Todo _newTodo = Todo(
                                  title: value, isDone: 0, taskId: _taskId);
                              // passing the information to db
                              await _dbHelper.insertTodo(_newTodo);
                              print("Creating new Todo");
                              //creates the todo to the screen
                              setState(() {});
                              _todoFocus.requestFocus();
                            } else {
                              print("Task doesn't exist");
                            }
                          }
                        },
                        decoration: InputDecoration(
                          hintText: "Enter Todo items...",
                          border: InputBorder.none,
                        ),
                      ),
                    )
                  ]),
                ),
              )
            ],
          ),
          Visibility(
            visible: _contentVisible,
            child: Positioned(
                bottom: 24,
                right: 24,
                child: GestureDetector(
                  onTap: () async {
                    if (_taskId != 0) {
                      await _dbHelper.deleteTask(_taskId);
                      Navigator.pop(context);
                    }
                  },
                  child: Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: Color(0xFFFE3577)),
                      child: Image(
                        image: AssetImage("assets/images/delete_icon.png"),
                      )),
                )),
          )
        ],
      ),
    )));
  }
}
