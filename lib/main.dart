import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:design_api_database/src/pages/home_page.dart';
import 'package:design_api_database/src/pages/login_page.dart';
import 'package:design_api_database/src/pages/menu_pages/todo_page.dart';
import 'package:design_api_database/src/pages/menu_pages/alarms_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light.copyWith(statusBarColor: Colors.transparent));

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Design',
      initialRoute: 'home',
      routes: {
        'login': (BuildContext context) => Login(),
        'home': (BuildContext context) => Home(),
        'todo': (BuildContext context) => Todo(),
        'alarms': (BuildContext context) => AlarmPage(),
      },
    );
  }
}

/*

import 'package:flutter/widgets.dart';
import 'package:design_database/src/database/providerDB.dart';
import 'package:design_database/src/models/task_model.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  TaskDbProvider memoDb = TaskDbProvider();

  final memo = Tasks(
    task_id: 1,
    task_desc: 'Title 1',
    task_date: '2020-12-11',
    task_time: '08:00 PM',
  );

  await memoDb.addItem(memo);
  var memos = await memoDb.fetchMemos();
  print(memos[0].task_desc); //Title 1

  final newmemo = Tasks(
    task_id: memo.task_id,
    task_desc: 'Title 1 changed',
    task_date: memo.task_date,
    task_time: '10:00 PM',
  );

  await memoDb.updateMemo(memo.task_id, newmemo);
  var updatedmemos = await memoDb.fetchMemos();
  print(updatedmemos[0].task_desc + " " + updatedmemos[0].task_id.toString()); //Title 1 changed

  await memoDb.deleteMemo(memo.task_id);
  print(await memoDb.fetchMemos()); //[]
}

*/
