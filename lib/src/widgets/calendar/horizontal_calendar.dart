import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'date_utils.dart';

typedef OnDateSelected(date);

class HorizontalCalendar extends StatefulWidget {
  final DateTime date;
  final DateTime initialDate;
  final DateTime lastDate;
  final Color textColor;
  final Color backgroundColor;
  final Color selectedColor;
  final OnDateSelected onDateSelected;

  HorizontalCalendar({
    Key key,
    @required this.date,
    this.initialDate,
    this.lastDate,
    this.textColor,
    this.backgroundColor,
    this.selectedColor,
    @required this.onDateSelected,
  }) : super(key: key);

  @override
  _CalendarState createState() => _CalendarState();
}

class _CalendarState extends State<HorizontalCalendar> {
  DateTime _startDate;
  DateTime selecteDate;
  DateTime _today = DateTime.now();

  @override
  void initState() {
    super.initState();

    selecteDate = widget.date;
  }

  @override
  Widget build(BuildContext context) {
    String titleDay = Utils.getTodayLabel(_today);
    double width = MediaQuery.of(context).size.width;
    _startDate = selecteDate.subtract(Duration(days: 3));

    return Container(
      height: 180.0,
      decoration: BoxDecoration(
        //color: widget.backgroundColor ?? Colors.white,
        color: Colors.transparent,
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 15.0, right: 15.0),
        child: Column(
          children: [
            //SizedBox(height: 50.0),
            Container(
              //padding: EdgeInsets.symmetric(horizontal: 15.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    titleDay,
                    style: TextStyle(color: Colors.white, fontFamily: "Calibri", fontSize: 18.0),
                  ),
                  w_CalendarIcon(),
                ],
              ),
            ),
            SizedBox(height: 10.0),
            LimitedBox(
              maxHeight: 80.0,
              child: ListView.separated(
                //padding: EdgeInsets.only(left: 15.0, right: 15.0),
                itemCount: 10,
                physics: BouncingScrollPhysics(),
                shrinkWrap: true,
                separatorBuilder: (context, index) => SizedBox(width: 5),
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  DateTime _date = _startDate.add(Duration(days: index));
                  int diffDays = _date.difference(selecteDate).inDays;
                  int checkPastDate = _date.difference(DateTime.now()).inDays;

                  return Container(
                    width: 50.0,
                    height: 80.0,
                    decoration: BoxDecoration(
                      color: diffDays != 0 ? widget.backgroundColor ?? Colors.white : widget.selectedColor ?? Colors.blue,
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    //color: diffDays != 0 ? widget.backgroundColor ?? Colors.white : widget.selectedColor ?? Colors.blue,
                    alignment: Alignment.center,
                    child: FlatButton(
                      height: 80.0,
                      padding: EdgeInsets.symmetric(horizontal: 2.0),
                      onPressed: () {
                        if (checkPastDate >= 0) {
                          widget.onDateSelected(Utils.getDate(_date));
                          setState(() {
                            selecteDate = _startDate.add(Duration(days: index));
                            _startDate = _startDate.add(Duration(days: index));
                          });
                        }
                      },
                      child: w_DayBox(_date, diffDays, checkPastDate),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<DateTime> selectDate() async {
    return await showDatePicker(
      context: context,
      initialDatePickerMode: DatePickerMode.day,
      initialDate: selecteDate,
      firstDate: widget.initialDate ?? DateTime.now().subtract(Duration(days: 30)),
      lastDate: widget.lastDate ?? DateTime.now().add(Duration(days: 30)),
    );
  }

  Widget w_DayBox(DateTime _date, int diffDays, int checkPastDate) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Text(
          Utils.getDayLabel(_date),
          style: TextStyle(
            color: diffDays != 0
                ? checkPastDate >= 0
                    ? widget.textColor ?? Colors.black45
                    : Colors.grey[300]
                : Colors.white,
            fontSize: 10.0,
          ),
        ),
        SizedBox(height: 2.0),
        Text(
          Utils.getDayOfMonth(_date),
          style: TextStyle(
            color: diffDays != 0
                ? checkPastDate >= 0
                    ? widget.textColor ?? Colors.black45
                    : Colors.grey[300]
                : Colors.white,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: 2.0),
        Text(
          Utils.getMonthLabelShort(_date),
          style: TextStyle(
            color: diffDays != 0
                ? checkPastDate >= 0
                    ? widget.textColor ?? Colors.black45
                    : Colors.grey[300]
                : Colors.white,
            fontSize: 10.0,
          ),
        ),
      ],
    );
  }

  Widget w_CalendarIcon() {
    return Container(
      child: IconButton(
        //padding: EdgeInsets.symmetric(horizontal: 5.0),
        icon: Icon(
          Icons.calendar_today,
          color: Colors.white,
          size: 30.0,
        ),
        onPressed: () async {
          DateTime date = await selectDate();
          widget.onDateSelected(Utils.getDate(date));
          setState(() => selecteDate = date);
        },
      ),
    );
  }
}
