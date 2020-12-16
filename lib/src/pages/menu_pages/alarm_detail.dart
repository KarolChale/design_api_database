import 'package:design_api_database/src/models/alarms_model.dart';
import 'package:flutter/material.dart';
import 'package:design_api_database/src/database/providerDBAlarms.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:design_api_database/src/widgets/sliding_up_panel_widget.dart';
import 'dart:async';
import 'package:design_api_database/src/pages/menu_pages/alarms_page.dart';
import 'package:design_api_database/src/database/providerAPI.dart';

class AlarmDetail extends StatefulWidget {
  AlarmDetail({Key key, @required this.alarm}) : super(key: key);
  final Alarm alarm;

  @override
  _AlarmDetailState createState() => _AlarmDetailState();
}

class _AlarmDetailState extends State<AlarmDetail> {
  final iconList = <IconData>[Icons.arrow_back_rounded, Icons.dehaze_rounded];
  SlidingUpPanelController panelController = SlidingUpPanelController();
  int _bottomNavIndex = 1;
  var apiProvider = AlarmApiProvider();

  TextEditingController timeController = new TextEditingController();
  TextEditingController statusController = new TextEditingController();
  TextEditingController repeatController = new TextEditingController();

  Future updateTask(String newTime, String newStatus, String newRepeat) async {
    final newAlarm = Alarm(idAlarm: widget.alarm.idAlarm, timeAlarm: newTime, statusAlarm: newStatus, repeatAlarm: newRepeat);

    await DBProvider.db.updateAlarm(widget.alarm.idAlarm, newAlarm);
    await apiProvider.updateAlarmToAPI(widget.alarm.idAlarm, newAlarm);
    print("updated task --> id: " + widget.alarm.idAlarm.toString() + " time: " + newTime + " status: " + newStatus + " repeat: " + newRepeat);
  }

  @override
  Widget build(BuildContext context) {
    timeController.text = widget.alarm.timeAlarm;
    statusController.text = widget.alarm.statusAlarm;
    repeatController.text = widget.alarm.repeatAlarm;

    return Scaffold(
      backgroundColor: Color(0xff392F35),
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
                  Text("Modify Alarm", style: TextStyle(fontSize: 18, fontFamily: "Calibri", color: Colors.white)),
                  SizedBox(height: 25),
                  w_TextForm("Time", "00:00 PM/AM", Icon(Icons.timer, color: Color(0xff5B5256)), timeController, TextInputType.text),
                  SizedBox(height: 25),
                  w_TextForm("Status", "In Progress", Icon(Icons.assignment_turned_in_sharp, color: Color(0xff5B5256)), statusController,
                      TextInputType.text),
                  SizedBox(height: 25),
                  w_TextForm("Repeat", "Y/N", Icon(Icons.timer, color: Color(0xff5B5256)), repeatController, TextInputType.text),
                  SizedBox(height: 35),
                  FloatingActionButton(
                    elevation: 0,
                    child: Icon(Icons.check_rounded, size: 40.0),
                    foregroundColor: Colors.white,
                    backgroundColor: Color(0xff438964),
                    onPressed: () {
                      updateTask(timeController.text, statusController.text, repeatController.text);
                      Timer(Duration(seconds: 2), () {
                        Navigator.push(context, new MaterialPageRoute(builder: (context) => new AlarmPage()));
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
        style: TextStyle(color: Colors.white),
        autovalidateMode: AutovalidateMode.always,
        controller: textController,
        keyboardType: typeInput,
        maxLines: null,
        decoration: InputDecoration(
            prefixIcon: iconText,
            hintText: hiddenText,
            focusColor: Color(0xffAA9FA5),
            fillColor: Color(0xff5B5256),
            enabledBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xff5B5256), width: 1.0)),
            border: OutlineInputBorder(borderSide: BorderSide(color: Color(0xff5B5256), width: 1.0)),
            labelText: labeltexto,
            hintStyle: TextStyle(color: Color(0xffAA9FA5)),
            focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xffAA9FA5), width: 1.0)),
            labelStyle: TextStyle(color: Color(0xff5B5256))));
  }
}
