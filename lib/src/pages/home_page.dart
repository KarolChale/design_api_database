import 'package:flutter/material.dart';
import 'package:design_api_database/src/pages/menu_pages/todo_page.dart';
import 'package:design_api_database/src/pages/menu_pages/alarms_page.dart';
import 'package:design_api_database/src/pages/menu_pages/calendar_page.dart';
import 'package:animations/animations.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            decoration: BoxDecoration(
                color: Color(0xffF16E45), borderRadius: BorderRadius.only(bottomLeft: Radius.circular(25.0), bottomRight: Radius.circular(25.0))),
            child: Padding(
              padding: const EdgeInsets.all(25.0),
              child: Column(
                children: [
                  SizedBox(height: 8.0),
                  w_UserWB(),
                  SizedBox(height: 15.0),
                  Text("How are you today?",
                      style: TextStyle(fontFamily: "Calibri", color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18.0)),
                  SizedBox(height: 8.0),
                  w_EmojiSelect(),
                ],
              ),
            ),
          ),
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(25.0),
              child: Column(
                children: [
                  w_MenuTop(),
                  SizedBox(height: 20.0),
                  w_MenuBot(),
                  SizedBox(height: 20.0),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ignore: non_constant_identifier_names
  Widget w_UserWB() {
    return Container(
      child: Row(children: [
        CircleAvatar(backgroundColor: Color(0xff32292E), radius: 25.0),
        SizedBox(width: 20.0),
        Text(
          "Welcome Back User",
          style: TextStyle(fontFamily: "Calibri", color: Colors.white, fontSize: 13.0),
        )
      ]),
    );
  }

  // ignore: non_constant_identifier_names
  Widget w_EmojiSelect() {
    return Container(
      child: ListView.separated(
        physics: BouncingScrollPhysics(),
        shrinkWrap: true,
        separatorBuilder: (context, index) => SizedBox(width: 15),
        scrollDirection: Axis.horizontal,
        itemCount: 15,
        itemBuilder: (context, index) => Container(child: CircleAvatar(backgroundColor: Color(0xff32292E), radius: 20.0)),
      ),
      color: Colors.transparent,
      height: 70.0,
      width: 450.0,
    );
  }

  // ignore: non_constant_identifier_names
  Widget w_MenuTop() {
    return Container(
      color: Colors.transparent,
      height: 150.0,
      width: 450.0,
      child: Row(children: [
        w_MenuButtonTap(Color(0xff473E43), 150.0, 200.0, Todo(), "To-do", "btnTodo.png", 55, 0, 20, 0),
        SizedBox(width: 25.0),
        w_MenuButtonTap(Color(0xffD44E68), 150.0, 136.4, Todo(), "Notes", "btnNotes.png", 15, 0, 30, 0),
      ]),
    );
  }

  // ignore: non_constant_identifier_names
  Widget w_MenuBot() {
    return Container(
      color: Colors.transparent,
      height: 250.0,
      width: 450.0,
      child: Row(children: [
        w_MenuButtonTap(Color(0xffF16E45), 250.0, 168.24, CalendarPage(), "Calendar", "btnCalendar.png", 35, 0, 25, 0),
        SizedBox(width: 25.0),
        Container(
            color: Colors.transparent,
            height: 250.0,
            width: 168.18,
            child: Column(children: [
              w_MenuButtonTap(Color(0xff993030), 130.0, 168.24, AlarmPage(), "Alarms", "btnAlarms.png", 12, 0, 38, 0),
              SizedBox(height: 25.0),
              w_MenuButtonTap(Color(0xff557C67), 95.0, 168.24, Todo(), "Ideas", "btnIdeas.png", 30, 0, 73, 0),
            ])),
      ]),
    );
  }

  // ignore: non_constant_identifier_names
  Widget w_MenuButtonTap(Color colorC, double heightC, double widthC, Widget page, String title, String imagepath, double edgeTop, double edgeBot,
      double edgeLeft, double edgeRight) {
    return OpenContainer(
      openColor: colorC,
      closedColor: colorC,
      closedElevation: 0.0,
      transitionDuration: Duration(milliseconds: 1300),
      closedBuilder: (BuildContext c, VoidCallback action) => Container(
        decoration: BoxDecoration(
          //color: colorC,
          image: new DecorationImage(
            image: new AssetImage("assets/" + imagepath),
            fit: BoxFit.fitWidth,
          ),
          borderRadius: BorderRadius.circular(0.0),
        ),
        height: heightC,
        width: widthC,
        child: Padding(
          padding: EdgeInsets.only(top: edgeTop, bottom: edgeBot, left: edgeLeft, right: edgeRight),
          child: Text(
            title,
            style: TextStyle(color: Colors.white, fontSize: 22.0, fontFamily: "Calibri", letterSpacing: 0.2),
          ),
        ),
      ),
      openBuilder: (BuildContext c, VoidCallback action) => page,
      tappable: true,
    );
  }
}
