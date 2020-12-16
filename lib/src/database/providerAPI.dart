import 'package:design_api_database/src/models/alarms_model.dart';
import 'package:design_api_database/src/database/providerDBAlarms.dart';
import 'package:dio/dio.dart';

class AlarmApiProvider {
  var urlmain = "https://5fd671b8ea55c40016042080.mockapi.io/alarms";

  Future<List<Alarm>> synchroAlarmsAPI() async {
    var url = urlmain;
    Response response = await Dio().get(url);

    print(response.data);

    return (response.data as List).map((alarm) {
      print('Inserting $alarm');
      DBProvider.db.createAlarm(Alarm.fromJson(alarm));
    }).toList();
  }

  Future<Alarm> addAlarmToAPI(Alarm newAlarm) async {
    Response response = await Dio().post(urlmain, data: newAlarm.toMap());

    if (response.statusCode == 201) {
      return Alarm.fromJson(response.data);
    } else {
      throw Exception('Failed to add new alarm.');
    }
  }

  Future<Alarm> deleteAlarmToAPI(int id) async {
    Response response = await Dio().delete(urlmain + "/" + id.toString());

    if (response.statusCode == 200) {
      return Alarm.fromJson(response.data);
    } else {
      throw Exception('Failed to add new alarm.');
    }
  }

  Future<Alarm> updateAlarmToAPI(int id, Alarm newAlarm) async {
    Response response = await Dio().put(urlmain + "/" + id.toString(), data: newAlarm.toMap());

    if (response.statusCode == 200) {
      return Alarm.fromJson(response.data);
    } else {
      throw Exception('Failed to update alarm with id ' + id.toString());
    }
  }
}
