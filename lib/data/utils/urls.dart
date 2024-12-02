class Urls {
  static const String _baseUrl = "http://35.73.30.144:2005/api/v1";
  static const String register = '$_baseUrl/Registration';
  static const String login = '$_baseUrl/Login';
  static const String addNewTask = '$_baseUrl/createTask';
  static const String getNewTasks = '$_baseUrl/listTaskByStatus/New';
  static const String getCompletedTasks =
      '$_baseUrl/listTaskByStatus/Completed';

  static const String getInProgressTasks =
      '$_baseUrl/listTaskByStatus/Progress';

  static const String getCancelledTasks =
      '$_baseUrl/listTaskByStatus/Cancelled';

  static updateTaskStatus(String id, String status) =>
      '$_baseUrl/updateTaskStatus/$id/$status';

  static deleteTask(String id) => '$_baseUrl/deleteTask/$id';

  static const String taskStatusCount = '$_baseUrl/taskStatusCount';
  static const String updateProfile = '$_baseUrl/ProfileUpdate';

  static const String resetPassword = '$_baseUrl/RecoverResetPassword';

  static String verifyEmail(String email)=> '$_baseUrl/RecoverVerifyEmail/$email';
  static String verifyOtp(String email, String otp)=> '$_baseUrl/RecoverVerifyOtp/$email/$otp';
}
