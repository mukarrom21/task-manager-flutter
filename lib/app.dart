import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myapp/controller_binder.dart';
import 'package:myapp/ui/screens/main_screen.dart';
import 'package:myapp/ui/screens/pin_verification_screen.dart';
import 'package:myapp/ui/screens/reset_password_screen.dart';
import 'package:myapp/ui/screens/sign_in_screen.dart';
import 'package:myapp/ui/screens/signup_screen.dart';
import 'package:myapp/ui/screens/splash_screen.dart';
import 'package:myapp/ui/screens/verify_email_screen.dart';
import 'package:myapp/ui/utils/app_colors.dart';

class TaskManagerApp extends StatefulWidget {
  const TaskManagerApp({super.key});

  static GlobalKey<NavigatorState> navigationKey = GlobalKey<NavigatorState>();

  @override
  State<TaskManagerApp> createState() => _TaskManagerAppState();
}

class _TaskManagerAppState extends State<TaskManagerApp> {
  Map<String, Widget Function(BuildContext)> routes = {
    SplashScreen.name: (context) => const SplashScreen(),
    MainScreen.name: (context) => const MainScreen(),
    SignInScreen.name: (context) => const SignInScreen(),
    SignupScreen.name: (context) => const SignupScreen(),
    VerifyEmailScreen.name: (context) => const VerifyEmailScreen(),
    PinVerificationScreen.name: (context) => const PinVerificationScreen(),
    ResetPasswordScreen.name: (context) => const ResetPasswordScreen(),
  };
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: TaskManagerApp.navigationKey,
      // debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: AppColors.themeColor,
        inputDecorationTheme: _inputDecorationTheme(),
        elevatedButtonTheme: _elevatedButtonThemeData(),
      ),
      initialBinding: ControllerBinder(),
      initialRoute: SplashScreen.name,
      routes: routes,
    );
  }

  ElevatedButtonThemeData _elevatedButtonThemeData() {
    return ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.themeColor,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 10),
        fixedSize: const Size.fromWidth(double.maxFinite),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(8)),
        ),
      ),
    );
  }

  InputDecorationTheme _inputDecorationTheme() {
    return InputDecorationTheme(
      hintStyle: const TextStyle(color: Colors.grey),
      fillColor: Colors.white,
      filled: true,
      border: _inputBorder(),
      focusedBorder: _inputBorder(),
      enabledBorder: _inputBorder(),
      errorBorder: _inputBorder(),
      focusedErrorBorder: _inputBorder(),
    );
  }

  OutlineInputBorder _inputBorder() {
    return OutlineInputBorder(
      borderSide: BorderSide.none,
      borderRadius: BorderRadius.circular(8),
    );
  }
}
