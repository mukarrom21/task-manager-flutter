import 'package:get/get.dart';
import 'package:myapp/data/models/network_response.dart';
import 'package:myapp/data/services/network_caller.dart';
import 'package:myapp/data/utils/urls.dart';

class VerifyOtpController extends GetxController {
  bool _isLoading = false;
  bool _isSuccess = false;
  String? _errorMessage;
  String? _data;

  bool get isLoading => _isLoading;

  bool get isSuccess => _isSuccess;

  String? get errorMessage => _errorMessage;

  String? get data => _data;

  Future<bool> verifyOtp(String email, String otp) async {
    _isLoading = true;
    update();
    final NetworkResponse response =
        await NetworkCaller.getRequest(Urls.verifyOtp(email, otp));
    if (response.isSuccess) {
      _isSuccess = true;
      _data = response.responseData["data"];
    } else {
      _isSuccess = false;
      _errorMessage = response.errorMessage;
    }
    _isLoading = false;
    update();
    return response.isSuccess;
  }
}
