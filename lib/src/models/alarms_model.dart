/*import 'dart:convert';

List<Alarm> alarmFromJson(String str) => List<Alarm>.from(json.decode(str).map((x) => Alarm.fromJson(x)));

String alarmToJson(List<Alarm> data) => json.encode(List<dynamic>.from(data.map((x) => x.toMap())));

class Alarm {
  String idAlarm;
  String timeAlarm;
  String statusAlarm;
  String repeatAlarm;

  Alarm({this.idAlarm, this.timeAlarm, this.statusAlarm, this.repeatAlarm});

  factory Alarm.fromJson(Map<String, dynamic> json) => Alarm(
        idAlarm: json["alarm_id"],
        timeAlarm: json["alarm_time"],
        statusAlarm: json["alarm_status"],
        repeatAlarm: json["alarm_repeat"],
      );

  Map<String, dynamic> toMap() {
    // used when inserting data to the database
    return <String, dynamic>{
      "alarm_id": idAlarm,
      "alarm_time": timeAlarm,
      "alarm_status": statusAlarm,
      "alarm_repeat": repeatAlarm,
    };
  }
}

*/

import 'dart:convert';

List<Alarm> alarmFromJson(String str) => List<Alarm>.from(json.decode(str).map((x) => Alarm.fromJson(x)));

String alarmToJson(List<Alarm> data) => json.encode(List<dynamic>.from(data.map((x) => x.toMap())));

class Alarm {
  int idAlarm;
  String timeAlarm;
  String statusAlarm;
  String repeatAlarm;

  Alarm({this.idAlarm, this.timeAlarm, this.statusAlarm, this.repeatAlarm});

  factory Alarm.fromJson(Map<String, dynamic> json) => Alarm(
        idAlarm: int.parse(json["alarm_id"]),
        timeAlarm: json["alarm_time"],
        statusAlarm: json["alarm_status"],
        repeatAlarm: json["alarm_repeat"],
      );

  Map<String, dynamic> toMap() {
    // used when inserting data to the database
    return <String, dynamic>{
      "alarm_id": idAlarm,
      "alarm_time": timeAlarm,
      "alarm_status": statusAlarm,
      "alarm_repeat": repeatAlarm,
    };
  }
}
