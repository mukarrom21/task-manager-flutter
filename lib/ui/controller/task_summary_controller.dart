import 'package:get/get.dart';
import 'package:myapp/data/models/network_response.dart';
import 'package:myapp/data/models/task_status_count.dart';
import 'package:myapp/data/models/task_status_count_list.dart';
import 'package:myapp/data/services/network_caller.dart';
import 'package:myapp/data/utils/urls.dart';

class TaskSummaryController extends GetxController {
  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isSuccess = false;

  List<TaskStatusCount> _taskStatusCountList = [];
  List<TaskStatusCount> get taskStatusCountList => _taskStatusCountList;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  Future<bool> getTaskSummary() async {
    _isLoading = true;
    update();

    final NetworkResponse response =
        await NetworkCaller.getRequest(Urls.taskStatusCount);
    if (response.isSuccess) {
      final TaskStatusCountList taskStatusCountList =
          TaskStatusCountList.fromJson(response.responseData);
      _taskStatusCountList = taskStatusCountList.taskStatusCountList ?? [];
      _isSuccess = true;
    } else {
      _isSuccess = false;
      _errorMessage = response.errorMessage;
    }
    _isLoading = false;
    update();
    return _isSuccess;
  }
}
