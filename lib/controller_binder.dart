import 'package:get/get.dart';
import 'package:myapp/ui/controller/initial_controller.dart';
import 'package:myapp/ui/controller/login_controller.dart';
import 'package:myapp/ui/controller/reset_password_controller.dart';
import 'package:myapp/ui/controller/sign_up_controller.dart';
import 'package:myapp/ui/controller/task_list_controller.dart';
import 'package:myapp/ui/controller/task_summary_controller.dart';
import 'package:myapp/ui/controller/update_profile_controller.dart';
import 'package:myapp/ui/controller/verify_email_controller.dart';
import 'package:myapp/ui/controller/verify_otp_controller.dart';

class ControllerBinder extends Bindings {
  @override
  void dependencies() {
    Get.put(InitialController());
    Get.put(LoginController());
    Get.put(SignUpController());
    Get.put(VerifyEmailController());
    Get.put(VerifyOtpController());
    Get.put(ResetPasswordController());
    Get.put(UpdateProfileController());
    Get.put(TaskListController());
    Get.put(TaskSummaryController());
  }
}
