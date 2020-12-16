import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarPage extends StatefulWidget {
  CalendarPage({Key key}) : super(key: key);

  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  CalendarController _controllercalendar;
  @override
  void initState() {
    super.initState();
    _controllercalendar = CalendarController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.red,
          title: Text("Todo List"),
        ),
        backgroundColor: Colors.white,
        body: Container(
          child: Column(
            children: <Widget>[
              TableCalendar(
                calendarController: _controllercalendar,
                initialCalendarFormat: CalendarFormat.month,
                headerStyle: HeaderStyle(centerHeaderTitle: true),
                onDaySelected: (day, events, holidays) {
                  print(day.toString());
                },
                //builders: CalendarBuilders(dowWeekdayBuilder: ),
              )
            ],
          ),
        ));
  }
}
