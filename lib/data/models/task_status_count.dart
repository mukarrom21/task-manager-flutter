class TaskStatusCount {
  String? sId;
  int? sum;

  TaskStatusCount({this.sId, this.sum});

  TaskStatusCount.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    sum = json['sum'];
  }
}