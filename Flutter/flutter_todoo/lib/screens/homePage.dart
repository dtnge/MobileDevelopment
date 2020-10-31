import 'package:flutter/material.dart';
import 'package:flutter_todoo/database_helper.dart';
import 'package:flutter_todoo/widgets.dart';
import 'package:flutter_todoo/screens/taskpage.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  //Database Helper instance
  DatabaseHelper _dbHelper = DatabaseHelper();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(
            horizontal: 24,
          ),
          color: Color(0xFFE0E0E0),
          child: Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: EdgeInsets.only(bottom: 32, top: 32),
                    child: Material(
                      shape: CircleBorder(),
                      elevation: 10,
                      child: Image(
                          height: 70,
                          width: 70,
                          image: AssetImage('assets/images/planer.png')),
                    ),
                  ),
                  // Column(
                  //   children: [
                  //     DefaultWidget()
                  //   ],
                  // ),
                  Expanded(
                    //to determine what is the future state in the current state
                    //to populate the task saved in the db to UI
                    child: FutureBuilder(
                      initialData: [],
                      future: _dbHelper.getTasks(),
                      builder: (contect, snapshot) {
                        return ScrollConfiguration(
                          behavior: ScrollBehaviour(),
                          child: ListView.builder(
                              itemCount: snapshot.data.length,
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => TaskPage(
                                          task: snapshot.data[index],
                                        ),
                                      ),
                                    ).then((value) {
                                      setState(() {});
                                    });
                                  },
                                  child: TaskCardWidget(
                                    title: snapshot.data[index].title,
                                    desc: snapshot.data[index].description,
                                  ),
                                );
                              }),
                        );
                      },
                    ),
                  )
                ],
              ),
              Positioned(
                  bottom: 24,
                  right: 0,
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => TaskPage(task: null)),
                      ).then((value) {
                        // to repopulate the homepage without refresh ---> setting the state
                        setState(() {});
                      });
                    },
                    child: Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            gradient: LinearGradient(
                                colors: [Color(0xFF7349FE), Color(0xFF643FDB)],
                                begin: Alignment(0.0, -1.0),
                                end: Alignment(0.0, 1.0))),
                        child: Image(
                          image: AssetImage("assets/images/add_icon.png"),
                        )),
                  ))
            ],
          ),
        ),
      ),
    );
  }
}
