import 'package:myapp/data/models/task_status_count.dart';

class TaskStatusCountList {
  String? status;
  List<TaskStatusCount>? taskStatusCountList;

  TaskStatusCountList({this.status, this.taskStatusCountList});

  TaskStatusCountList.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      taskStatusCountList = <TaskStatusCount>[];
      json['data'].forEach((v) {
        taskStatusCountList!.add(TaskStatusCount.fromJson(v));
      });
    }
  }
}
