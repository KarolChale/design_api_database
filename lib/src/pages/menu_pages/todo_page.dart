import 'package:flutter/material.dart';
import 'package:design_api_database/src/widgets/calendar/horizontal_calendar.dart';
import 'package:design_api_database/src/models/task_model.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:design_api_database/src/widgets/sliding_up_panel_widget.dart';
import 'package:design_api_database/src/widgets/menu_options.dart';
import 'package:design_api_database/src/widgets/container_slidable/slidable.dart';
import 'package:design_api_database/src/widgets/container_slidable/slide_action.dart';
import 'package:design_api_database/src/widgets/container_slidable/slidable_action_pane.dart';
import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:design_api_database/src/database/providerDB.dart';
import 'package:design_api_database/src/pages/menu_pages/task_detail.dart';

class Todo extends StatefulWidget {
  Todo({Key key}) : super(key: key);

  @override
  _TodoState createState() => _TodoState();
}

class _TodoState extends State<Todo> {
  TaskDbProvider taskDB = TaskDbProvider();
  List<Tasks> tasksMarked;
  List<Tasks> _selectedDayTasks;
  String dateSelected;
  SlidingUpPanelController panelController = SlidingUpPanelController();
  int _bottomNavIndex = 0;
  bool _addItem = false;

  final iconList = <IconData>[
    Icons.arrow_back_rounded,
    Icons.dehaze_rounded,
  ];

  Future getTasks() async {
    tasksMarked = await taskDB.fetchMemos();
    //tasksMarked.forEach((element) => print("ALL tasks: " + element.task_id.toString() + "-" + element.task_desc + "--" + element.task_date));

    _selectedDayTasks = null;
    _selectedDayTasks = tasksMarked.where((i) => i.task_date.contains(dateSelected)).toList();
    _selectedDayTasks.forEach((element) => print("ALL selected: " + element.task_id.toString() + "-" + element.task_desc));
  }

  Future addTasks(String description, String dateTask, String timeTask) async {
    final taskAdd = Tasks(task_desc: description, task_date: dateTask, task_time: timeTask, task_status: 0);
    await taskDB.addItem(taskAdd);
    print("added task --> desc: " + description + " date: " + dateTask + " time: " + timeTask);
  }

  @override
  void initState() {
    super.initState();
    dateSelected = DateTime.now().toString().substring(0, 10);
    getTasks();
  }

  TextEditingController descController = new TextEditingController();
  TextEditingController dateController = new TextEditingController();
  TextEditingController timeController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Scaffold(
        backgroundColor: Colors.white,
        body: Column(children: [
          Container(
            height: 200.0,
            decoration: BoxDecoration(
              color: Color(0xff473E43),
              //color: Colors.red,
              borderRadius: BorderRadius.only(bottomLeft: Radius.circular(20.0), bottomRight: Radius.circular(20.0)),
            ),
            child: Padding(
              padding: const EdgeInsets.only(top: 35.0),
              child: HorizontalCalendar(
                lastDate: DateTime.now().add(Duration(days: 14)),
                date: DateTime.now(),
                textColor: Color(0xff68463E),
                backgroundColor: Colors.white,
                selectedColor: Color(0xff15040D),
                //onDateSelected: (date) => print(date.toString()),
                onDateSelected: (date) {
                  setState(() {
                    getTasks();
                    dateSelected = date.toString();
                    _selectedDayTasks = tasksMarked.where((i) => i.task_date.contains(dateSelected)).toList();
                    //_selectedDayTasks.forEach((element) {
                    //print(element.descTask);
                    //});
                  });
                  //print("onDateSelected: " + date.toString());
                  return dateSelected;
                },
              ),
            ),
          ),
          SizedBox(height: 20),
          _addItem ? w_AddItem(descController, dateController, timeController) : SingleChildScrollView(child: w_SelectedDateTasks(dateSelected)),
        ]),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            setState(() {
              _addItem = !_addItem;
            });
          },
          child: _addItem ? Icon(Icons.clear_rounded, size: 40.0) : Icon(Icons.add, size: 40.0),
          backgroundColor: _addItem ? Colors.red[400] : Color(0xffF16E45),
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
                  panelController.anchor();
                } else {
                  Navigator.pop(context);
                }
              });
            });
          },
          //onTap: (index) => setState(() => _bottomNavIndex = index),
        ),
      ),
      SlidingUpPanelWidget(
        child: w_MenuOptions(),
        controlHeight: 0.0,
        anchor: 0.4,
        panelStatus: SlidingUpPanelStatus.hidden,
        panelController: panelController,
        enableOnTap: false,
      )
    ]);
  }

  Widget w_SelectedDateTasks(String date) {
    getTasks();
    return Container(
        height: 530,
        child: FutureBuilder(
          future: taskDB.fetchMemos(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.hasData && _selectedDayTasks != null) {
              return SingleChildScrollView(
                child: Container(
                  child: Column(children: [
                    //Text("Selected day: '" + date + "'"),
                    //Text(tasksMarked.where((w) => w.dateTask.contains(date)).join(" ")),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15.0),
                      child: getTextWidgets(_selectedDayTasks),
                      //child: Text("Selected day: '" + date + "'"),
                    ),
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

  Widget getTextWidgets(List<Tasks> strings) {
    Path customPath = Path()
      ..moveTo(3, 63)
      ..lineTo(370, 63);
    TaskDbProvider taskDB = TaskDbProvider();

    return new Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        for (var item in strings)
          Slidable(
            actionPane: SlidableBehindActionPane(),
            actionExtentRatio: 0.15,
            child: DottedBorder(
              customPath: (size) => customPath,
              color: Color(0xff993030),
              dashPattern: [8, 4],
              strokeWidth: 2,
              child: InkWell(
                onTap: () {
                  setState(() {
                    Navigator.push(context, new MaterialPageRoute(builder: (context) => TaskDetail(task: item)));
                  });
                },
                child: Container(
                    color: Colors.white,
                    child: Row(
                      children: [
                        Container(width: 15.0, color: Color(0xffEE6B42)),
                        SizedBox(width: 10.0),
                        Text(item.task_desc, style: TextStyle(fontSize: 15, fontFamily: "Calibri")),
                        Spacer(),
                        Text(item.task_time, style: TextStyle(fontSize: 12, fontFamily: "Calibri")),
                        SizedBox(width: 15.0),
                      ],
                    ),
                    height: 60.0),
              ),
            ),
            actions: <Widget>[
              IconSlideAction(
                foregroundColor: Colors.green,
                color: Colors.transparent,
                icon: Icons.check_circle,
                //onTap: () => _showSnackBar('Archive'),
              ),
              IconSlideAction(
                color: Colors.transparent,
                foregroundColor: Colors.red,
                icon: Icons.cancel,
                //onTap: () => _showSnackBar('Share'),
              ),
            ],
            secondaryActions: <Widget>[
              IconSlideAction(
                color: Colors.transparent,
                foregroundColor: Colors.red,
                icon: Icons.delete,
                onTap: () {
                  setState(() {
                    taskDB.deleteMemo(item.task_id);
                    getTasks();
                  });
                },
              ),
            ],
          ),
      ],
    );
  }

  Widget w_AddItem(TextEditingController descController, TextEditingController dateController, TextEditingController timeController) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 30.0),
      child: DottedBorder(
        borderType: BorderType.RRect,
        strokeWidth: 2,
        dashPattern: [8, 4],
        color: Color(0xff2D2529),
        radius: Radius.circular(12),
        child: Container(
          decoration: BoxDecoration(color: Colors.transparent, borderRadius: BorderRadius.circular(8.0)),
          padding: EdgeInsets.all(30.0),
          width: 370,
          height: 480,
          child: Column(
            children: [
              Text("Add New Task", style: TextStyle(fontSize: 18, fontFamily: "Calibri")),
              SizedBox(height: 40),
              w_TextForm("Description", "Write your task", Icon(Icons.art_track_outlined, color: Color(0xff5B5256)), descController),
              SizedBox(height: 25),
              w_TextForm("Date", "YYYY-MM-DD", Icon(Icons.calendar_today_sharp, color: Color(0xff5B5256)), dateController),
              SizedBox(height: 25),
              w_TextForm("Time", "00:00 PM/AM", Icon(Icons.timer, color: Color(0xff5B5256)), timeController),
              SizedBox(height: 35),
              InkWell(
                onTap: () {
                  setState(() {
                    if (_addItem) {
                      //Comprobar que los campos esten rellenados
                      if (descController.text.length > 0 && dateController.text.length > 0 && timeController.text.length > 0) {
                        addTasks(descController.text, dateController.text, timeController.text);
                        descController.text = "";
                        dateController.text = "";
                        timeController.text = "";
                      }
                    }
                    _addItem = !_addItem;
                  });
                },
                child: Container(
                  height: 50,
                  width: 150,
                  decoration: BoxDecoration(color: Colors.green[400], borderRadius: BorderRadius.circular(8.0)),
                  child: Center(child: Text("Submit", style: TextStyle(fontSize: 18, fontFamily: "Calibri", color: Colors.white))),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget w_TextForm(String labeltexto, String hiddenText, Icon iconText, TextEditingController textController) {
    return TextFormField(
      autovalidateMode: AutovalidateMode.always,
      controller: textController,
      decoration: InputDecoration(
          prefixIcon: iconText,
          hintText: hiddenText,
          focusColor: Color(0xff5B5256),
          border: OutlineInputBorder(),
          labelText: labeltexto,
          focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Color(0xff2D2529), width: 1.0)),
          labelStyle: TextStyle(color: Color(0xff5B5256))),
      onSaved: (String value) {},
    );
  }
}
