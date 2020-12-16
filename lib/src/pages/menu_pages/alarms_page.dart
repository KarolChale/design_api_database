import 'package:design_api_database/src/database/providerDBAlarms.dart';
import 'package:design_api_database/src/database/providerAPI.dart';
import 'package:design_api_database/src/models/alarms_model.dart';
import 'package:flutter/material.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:design_api_database/src/widgets/sliding_up_panel_widget.dart';
import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:design_api_database/src/widgets/container_slidable/slidable.dart';
import 'package:design_api_database/src/widgets/container_slidable/slide_action.dart';
import 'package:design_api_database/src/widgets/container_slidable/slidable_action_pane.dart';
import 'package:design_api_database/src/pages/menu_pages/alarm_detail.dart';

class AlarmPage extends StatefulWidget {
  const AlarmPage({Key key}) : super(key: key);

  @override
  _AlarmPageState createState() => _AlarmPageState();
}

class _AlarmPageState extends State<AlarmPage> {
  var isLoading = false;
  var apiProvider = AlarmApiProvider();
  List<Alarm> alarmList;
  SlidingUpPanelController panelController = SlidingUpPanelController();
  int _bottomNavIndex = 0;
  bool _addItem = false;

  final iconList = <IconData>[
    Icons.arrow_back_rounded,
    Icons.settings_input_antenna,
    Icons.delete,
    Icons.dehaze_rounded,
  ];

  Future getAlarms() async {
    alarmList = await DBProvider.db.fetchAlarms();
    alarmList.forEach((element) => print("ALL alarms: " + element.idAlarm.toString() + "-" + element.timeAlarm));
  }

  Future addAlarm(String newTime, String newStatus, String newRepeat) async {
    final alarmAdd = Alarm(timeAlarm: newTime, statusAlarm: newStatus, repeatAlarm: newRepeat);
    await DBProvider.db.addAlarm(alarmAdd);
    await apiProvider.addAlarmToAPI(alarmAdd);
    print("added alarm --> time: " + newTime + " status: " + newStatus + " repeat: " + newRepeat);
  }

  Alarm newAlarmAdd = Alarm(idAlarm: 27, timeAlarm: "alarm_time 25", statusAlarm: "alarm_status 25", repeatAlarm: "alarm_repeat 26");

  @override
  void initState() {
    super.initState();
    getAlarms();
  }

  TextEditingController timeController = new TextEditingController();
  TextEditingController statusController = new TextEditingController();
  TextEditingController repeatController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    var addItem = _addItem;
    return Scaffold(
        backgroundColor: Color(0xff392F35),
        //body: w_Alarms(),
        body: Container(
          //color: Color(0xff332A2F),
          child: Column(children: [
            Center(
              child: Container(
                  height: 80,
                  width: 400,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: Center(child: Text("Alarms", style: TextStyle(color: Colors.white, fontFamily: "Calibri", fontSize: 17))),
                  ),
                  decoration: BoxDecoration(
                      color: Color(0xff750C0C),
                      borderRadius: BorderRadius.only(bottomLeft: Radius.circular(25.0), bottomRight: Radius.circular(25.0)))),
            ),
            SizedBox(height: 10),
            if (addItem) w_AddItem(timeController, statusController, repeatController) else SingleChildScrollView(child: w_Alarms()),
          ]),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            setState(() {
              _addItem = !_addItem;
            });
          },
          child: _addItem ? Icon(Icons.clear_rounded, size: 40.0) : Icon(Icons.add, size: 40.0),
          backgroundColor: _addItem ? Color(0xffAA4F4F) : Color(0xffF16E45),
          elevation: 0,
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
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
                  _loadFromApi();
                } else if (index == 2) {
                  _deleteData();
                } else if (index == 3) {
                  panelController.anchor();
                } else {
                  Navigator.pop(context);
                }
              });
            });
          },
        ));
  }

//Synchronize data and inserts to our database
  _loadFromApi() async {
    setState(() {
      isLoading = true;
    });
    await apiProvider.synchroAlarmsAPI();
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      alarmList = null;
      isLoading = false;
      getAlarms();
    });
  }

//Delete all data of the database
  _deleteData() async {
    setState(() {
      isLoading = true;
    });
    await DBProvider.db.deleteAllAlarms();

    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      isLoading = false;
      alarmList = null;
    });

    print('All alarms are deleted of the database');
  }

  Widget w_Alarms() {
    //getAlarms();
    return Container(
        height: 670,
        child: FutureBuilder(
          future: DBProvider.db.fetchAlarms(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData && alarmList != null) {
              return SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 2.0),
                  child: Column(children: [
                    getTextWidgets(alarmList),
                  ]),
                ),
              );
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ));
  }

  Widget getTextWidgets(List<Alarm> strings) {
    return new Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        for (var item in strings)
          Padding(
            padding: const EdgeInsets.all(1.5),
            child: Slidable(
              actionPane: SlidableBehindActionPane(),
              actionExtentRatio: 0.15,
              child: InkWell(
                onTap: () {
                  setState(() {
                    Navigator.push(context, new MaterialPageRoute(builder: (context) => AlarmDetail(alarm: item)));
                  });
                },
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  color: item.statusAlarm.contains("ON") ? Color(0xff231D21) : Color(0xff44363F),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 20),
                      Row(
                        children: [
                          Text(item.timeAlarm,
                              style: TextStyle(
                                fontSize: 35,
                                fontWeight: FontWeight.bold,
                                fontFamily: "Calibri",
                                color: item.statusAlarm.contains("ON") ? Color(0xffC9BCC3) : Color(0xff6B6568),
                              )),
                          Spacer(),
                          Text(item.idAlarm.toString(),
                              style: TextStyle(
                                fontSize: 12,
                                fontFamily: "Calibri",
                                color: Color(0xff6B6568),
                              )),
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        children: [
                          Text("repeat: " + item.repeatAlarm, style: TextStyle(color: Color(0xff6B6568), fontFamily: "Calibri", fontSize: 10)),
                          Spacer(),
                          Text(item.statusAlarm,
                              style: TextStyle(
                                color: item.statusAlarm.contains("ON") ? Color(0xffC9BCC3) : Color(0xff6B6568),
                                fontSize: 15,
                                fontFamily: "Calibri",
                              )),
                        ],
                      ),
                    ],
                  ),
                  height: 130.0,
                ),
              ),
              secondaryActions: <Widget>[
                IconSlideAction(
                  color: Colors.transparent,
                  foregroundColor: Colors.red,
                  icon: Icons.delete,
                  onTap: () {
                    setState(() {
                      apiProvider.deleteAlarmToAPI(item.idAlarm);
                      DBProvider.db.deleteAlarm(item.idAlarm);
                      getAlarms();
                    });
                  },
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget w_AddItem(TextEditingController timeController, TextEditingController statusController, TextEditingController repeatController) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 30.0),
      child: Container(
        decoration: BoxDecoration(color: Colors.transparent, borderRadius: BorderRadius.circular(8.0)),
        padding: EdgeInsets.all(30.0),
        width: 370,
        height: 480,
        child: Column(
          children: [
            Text("Add New Task", style: TextStyle(fontSize: 18, fontFamily: "Calibri", color: Colors.white)),
            SizedBox(height: 40),
            w_TextForm("Time", "00:00 PM/AM", Icon(Icons.timer, color: Color(0xff5B5256)), timeController),
            SizedBox(height: 25),
            w_TextForm("Status", "In Progress", Icon(Icons.assignment_turned_in_sharp, color: Color(0xff5B5256)), statusController),
            SizedBox(height: 25),
            w_TextForm("Repeat", "Y/N", Icon(Icons.timer, color: Color(0xff5B5256)), repeatController),
            SizedBox(height: 35),
            InkWell(
              onTap: () {
                setState(() {
                  if (_addItem) {
                    //Comprobar que los campos esten rellenados
                    if (timeController.text.length > 0 && statusController.text.length > 0 && repeatController.text.length > 0) {
                      addAlarm(timeController.text, statusController.text, repeatController.text);
                      getAlarms();
                      timeController.text = "";
                      statusController.text = "";
                      repeatController.text = "";
                    }
                  }
                  _addItem = !_addItem;
                });
              },
              child: Container(
                height: 50,
                width: 150,
                decoration: BoxDecoration(color: Color(0xff438964), borderRadius: BorderRadius.circular(8.0)),
                child: Center(child: Text("Submit", style: TextStyle(fontSize: 18, fontFamily: "Calibri", color: Colors.white))),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget w_TextForm(String labeltexto, String hiddenText, Icon iconText, TextEditingController textController) {
    return TextFormField(
      style: TextStyle(color: Colors.white),
      autovalidateMode: AutovalidateMode.always,
      controller: textController,
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
          labelStyle: TextStyle(color: Color(0xff5B5256))),
    );
  }
}
