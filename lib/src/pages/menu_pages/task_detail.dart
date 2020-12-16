import 'package:flutter/material.dart';
import 'package:design_api_database/src/models/task_model.dart';
import 'package:design_api_database/src/database/providerDB.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:design_api_database/src/widgets/sliding_up_panel_widget.dart';
import 'dart:async';
import 'package:design_api_database/src/pages/menu_pages/todo_page.dart';

class TaskDetail extends StatefulWidget {
  TaskDetail({Key key, @required this.task}) : super(key: key);
  final Tasks task;

  @override
  _TaskDetailState createState() => _TaskDetailState();
}

class _TaskDetailState extends State<TaskDetail> {
  TaskDbProvider taskDB = TaskDbProvider();
  final iconList = <IconData>[Icons.arrow_back_rounded, Icons.dehaze_rounded];
  SlidingUpPanelController panelController = SlidingUpPanelController();
  int _bottomNavIndex = 1;
  TextEditingController descController = new TextEditingController();
  TextEditingController dateController = new TextEditingController();
  TextEditingController timeController = new TextEditingController();
  TextEditingController statusController = new TextEditingController();

  Future updateTask(String newDesc, String newDate, String newTime) async {
    final newtask = Tasks(task_id: widget.task.task_id, task_desc: newDesc, task_date: newDate, task_time: newTime);

    await taskDB.updateMemo(widget.task.task_id, newtask);
    print("updated task --> id: " + widget.task.task_id.toString() + " desc: " + newDesc + " date: " + newDate + " time: " + newTime);
  }

  @override
  Widget build(BuildContext context) {
    descController.text = widget.task.task_desc;
    dateController.text = widget.task.task_date;
    timeController.text = widget.task.task_time;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(top: 50.0, bottom: 20.0, left: 20.0, right: 20.0),
            //child: Text(widget.task.task_id.toString() + "  " + widget.task.task_desc + " " + widget.task.task_date),
            child: Container(
              decoration: BoxDecoration(color: Colors.transparent, borderRadius: BorderRadius.circular(8.0)),
              padding: EdgeInsets.all(30.0),
              width: 370,
              height: 600,
              child: Column(
                children: [
                  Text("Modify Task", style: TextStyle(fontSize: 18, fontFamily: "Calibri")),
                  SizedBox(height: 40),
                  w_TextForm("Description", "Write your task", Icon(Icons.art_track_outlined, color: Color(0xff5B5256)), descController,
                      TextInputType.multiline),
                  SizedBox(height: 25),
                  w_TextForm("Date", "YYYY-MM-DD", Icon(Icons.calendar_today_sharp, color: Color(0xff5B5256)), dateController, TextInputType.text),
                  SizedBox(height: 25),
                  w_TextForm("Time", "00:00 PM/AM", Icon(Icons.timer, color: Color(0xff5B5256)), timeController, TextInputType.text),
                  SizedBox(height: 25),
                  w_TextForm("Status", "In Progress", Icon(Icons.assignment_turned_in_sharp, color: Color(0xff5B5256)), statusController,
                      TextInputType.text),
                  SizedBox(height: 35),
                  FloatingActionButton(
                    elevation: 0,
                    child: Icon(Icons.check_rounded, size: 40.0),
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.green[400],
                    onPressed: () {
                      updateTask(descController.text, dateController.text, timeController.text);
                      Timer(Duration(seconds: 2), () {
                        Navigator.push(context, new MaterialPageRoute(builder: (context) => new Todo()));
                      });
                    },
                  )
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: AnimatedBottomNavigationBar(
        icons: iconList,
        activeIndex: _bottomNavIndex,
        gapLocation: GapLocation.center,
        notchSmoothness: NotchSmoothness.softEdge,
        backgroundColor: Color(0xff2D2529),
        inactiveColor: Color(0xff6C6669),
        activeColor: Colors.white,
        leftCornerRadius: 25,
        rightCornerRadius: 25,
        onTap: (index) {
          setState(() {
            _bottomNavIndex = index;
            Timer(Duration(seconds: 1), () {
              if (index == 1) {
                panelController.anchor();
              } else {
                Navigator.pop(context);
              }
            });
          });
        },
      ),
    );
  }

  Widget w_TextForm(String labeltexto, String hiddenText, Icon iconText, TextEditingController textController, TextInputType typeInput) {
    return TextFormField(
      autovalidateMode: AutovalidateMode.always,
      controller: textController,
      keyboardType: typeInput,
      maxLines: null,
      decoration: InputDecoration(
        //icon: iconText,
        prefixIcon: iconText,
        hintText: hiddenText,
        focusColor: Color(0xff5B5256),
        border: OutlineInputBorder(),
        //hintText: hiddentexto,
        labelText: labeltexto,

        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Color(0xff2D2529), width: 1.0),
        ),

        labelStyle: TextStyle(color: Color(0xff5B5256)),
      ),
      onSaved: (String value) {},
    );
  }
}
