import 'package:get/get.dart';
import 'package:myapp/data/models/login_model.dart';
import 'package:myapp/data/models/network_response.dart';
import 'package:myapp/data/services/network_caller.dart';
import 'package:myapp/data/utils/urls.dart';
import 'package:myapp/ui/controller/auth_controller.dart';

class LoginController extends GetxController {
  bool _isLoading = false;
  bool _isLoggedIn = false;

  bool get isLoading => _isLoading;
  bool get isLoggedIn => _isLoggedIn;

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    update();

    NetworkResponse response = await NetworkCaller.postRequest(
      url: Urls.login,
      data: {"email": email, "password": password},
    );

    print(response.isSuccess);

    if (response.isSuccess) {
      LoginModel loginModel = LoginModel.fromJson(response.responseData);
      await AuthController.saveAccessToken(loginModel.token!);
      await AuthController.saveUserData(loginModel.userData!);
      _isLoggedIn = true;
    } else {
      _isLoggedIn = false;
    }
    _isLoading = false;
    update();
    return _isLoggedIn;
  }
}
