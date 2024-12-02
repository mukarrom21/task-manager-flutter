import 'package:get/get.dart';
import 'package:myapp/data/models/network_response.dart';
import 'package:myapp/data/services/network_caller.dart';
import 'package:myapp/data/utils/urls.dart';

class AddNewTaskController extends GetxController {
  bool _isLoading = false;
  bool _isSuccess = false;
  String _errorMessage = "";

  bool get isLoading => _isLoading;
  bool get isSuccess => _isSuccess;
  String get errorMessage => _errorMessage;

  Future<bool> addNewTask(Map<String, dynamic> requestBody) async {
    _isLoading = true;
    update();
    NetworkResponse response = await NetworkCaller.postRequest(
      url: Urls.addNewTask,
      data: requestBody,
    );

    if (response.isSuccess) {
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
