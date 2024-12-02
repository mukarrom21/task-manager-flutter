import 'package:get/get.dart';
import 'package:myapp/data/models/network_response.dart';
import 'package:myapp/data/models/task_list_model.dart';
import 'package:myapp/data/models/task_model.dart';
import 'package:myapp/data/services/network_caller.dart';

class TaskListController extends GetxController {
  bool _isLoading = false;
  bool _isSuccess = false;
  List<TaskModel> _taskList = <TaskModel>[];
  String? _errorMessage;

  bool get isLoading => _isLoading;
  bool get isSuccess => _isSuccess;
  List<TaskModel> get taskList => _taskList;
  String? get errorMessage => _errorMessage;

  Future<bool> getTasksList(String url) async {
    _taskList.clear();
    _isLoading = true;
    update();

    final NetworkResponse response = await NetworkCaller.getRequest(url);

    if (response.isSuccess) {
      final TaskListModel taskListModel =
          TaskListModel.fromJson(response.responseData);
      _taskList = taskListModel.taskList ?? [];
      _isSuccess = true;
    } else {
      _errorMessage = response.errorMessage;
    }

    _isLoading = false;
    update();

    return _isSuccess;
  }
}
