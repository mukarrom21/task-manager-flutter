import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myapp/ui/controller/reset_password_controller.dart';
import 'package:myapp/ui/screens/sign_in_screen.dart';
import 'package:myapp/ui/utils/app_colors.dart';
import 'package:myapp/ui/widgets/background_screen.dart';

class ResetPasswordScreen extends StatefulWidget {
  static const String name = '/reset-password-screen';

  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final ResetPasswordController _resetPasswordController = Get.find();
  final List<String> _emailPin = Get.arguments;
  final TextEditingController _passwordTEController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: BackgroundScreen(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 85,
              ),

              /// Title Section
              Text(
                'Set Password',
                style: textTheme.displaySmall?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              Text(
                'Your password must be at least 6 characters long with a mix of letters and numbers.',
                style: textTheme.titleMedium,
              ),
              const SizedBox(
                height: 30,
              ),

              /// Sign in form
              _buildSignInForm(),

              const SizedBox(
                height: 28,
              ),

              /// Forgot Password and Sign Up section
              _buildSignUpSection(textTheme),
            ],
          ),
        ),
      ),
    );
  }

  /// Build the sign in form
  Widget _buildSignInForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            keyboardType: TextInputType.text,
            obscureText: true,
            controller: _passwordTEController,
            validator: (String? value) {
              if (value?.isEmpty ?? true) {
                return "Please enter your password";
              }
              return null;
            },
            decoration: const InputDecoration(
              hintText: "Password",
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          TextFormField(
            validator: (String? value) {
              if (value?.isEmpty ?? true) {
                return "Please enter confirm password";
              }
              if (_passwordTEController.text != value) {
                return "Password not match";
              }
              return null;
            },
            keyboardType: TextInputType.text,
            decoration: const InputDecoration(
              hintText: "Confirm Password",
            ),
          ),
          const SizedBox(
            height: 24,
          ),
          ElevatedButton(
            onPressed: _onClickConfirmButton,
            child: const Text("Confirm"),
          ),
        ],
      ),
    );
  }

  /// Build the sign up section
  Widget _buildSignUpSection(TextTheme textTheme) {
    return Center(
      child: RichText(
        text: TextSpan(
          text: 'Have account? ',
          style: const TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
          children: [
            TextSpan(
              text: ' Sign in',
              style: textTheme.bodyLarge?.copyWith(
                color: AppColors.themeColor,
              ),
              recognizer: TapGestureRecognizer()
                ..onTap = _onClickHaveAccountSignIn,
            ),
          ],
        ),
      ),
    );
  }

  void _onClickConfirmButton() async {
    if (_formKey.currentState!.validate()) {
      bool isSuccess = await _resetPasswordController.resetPassword({
        "email": _emailPin[0],
        "OTP": _emailPin[1],
        "password": _passwordTEController.text,
      });
      if (isSuccess) {
        Get.showSnackbar(const GetSnackBar(
          message: "Password changed successfully. Please login.",
          duration: Duration(seconds: 3),
          backgroundColor: Colors.green,
        ));
        Get.offAllNamed(SignInScreen.name);
      } else {
        Get.showSnackbar(const GetSnackBar(
          message: "Something went wrong. Please try again.",
          duration: Duration(seconds: 3),
          backgroundColor: Colors.red,
        ));
      }
    }
  }

  void _onClickHaveAccountSignIn() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => const SignInScreen()),
      (_) => false,
    );
  }
}
