import 'package:flutter/material.dart';
import 'package:flutter_todoo/screens/homePage.dart';

class InitialPage extends StatefulWidget {
  @override
  _InitialPageState createState() => _InitialPageState();
}

class _InitialPageState extends State<InitialPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: Stack(
            children: [
              Container(
                margin: EdgeInsets.only(bottom: 32, left: 110, top: 200),
                child: Material(
                  shape: CircleBorder(),
                  elevation: 10,
                  child: Image(
                    height: 130,
                    width: 130,
                    image: AssetImage('assets/images/planer.png'),
                  ),
                ),
              ),
              Center(
                child: Container(
                  child: Text(
                    "Welcome to NotePoint!",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                padding: EdgeInsets.all(24),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => HomePage()),
                    ).then((value) {
                      setState(() {});
                    });
                  },
                  child: Container(
                    width: 60,
                    height: 60,
                    margin: EdgeInsets.only(bottom: 32, top: 360),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Color(0xFF11C5DA)),
                    child: Center(
                      child: Text(
                        "Get Started",
                        style:
                            TextStyle(fontSize: 25, color: Color(0xFF373738)),
                      ),
                    ),
                  ),
                ),
              )
            ],
          )),
    ));
  }
}
