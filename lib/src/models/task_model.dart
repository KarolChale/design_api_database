class Tasks {
  // ignore: non_constant_identifier_names
  final int task_id;
  final String task_desc;
  final String task_date;
  final String task_time;
  final int task_status;

  // ignore: non_constant_identifier_names
  Tasks({this.task_id, this.task_desc, this.task_date, this.task_time, this.task_status});

  Map<String, dynamic> toMap() {
    // used when inserting data to the database
    return <String, dynamic>{
      "id": task_id,
      "description": task_desc,
      "date": task_date,
      "time": task_time,
      "status": task_status,
    };
  }
}
