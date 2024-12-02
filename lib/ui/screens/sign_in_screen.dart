import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myapp/ui/controller/login_controller.dart';
import 'package:myapp/ui/screens/main_screen.dart';
import 'package:myapp/ui/screens/signup_screen.dart';
import 'package:myapp/ui/screens/verify_email_screen.dart';
import 'package:myapp/ui/utils/app_colors.dart';
import 'package:myapp/ui/widgets/background_screen.dart';

class SignInScreen extends StatefulWidget {
  static const String name = "/sign-in-screen";

  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return Scaffold(
      // resizeToAvoidBottomInset: false,
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
                'Get Started With',
                style: textTheme.displaySmall?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
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

  Widget _buildSignInForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            controller: _emailController,
            validator: (String? value) {
              if (value?.isEmpty ?? true) {
                return "Please enter your email address";
              }
              return null;
            },
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              hintText: "Email",
            ),
          ),
          const SizedBox(
            height: 12,
          ),
          TextFormField(
            controller: _passwordController,
            validator: (String? value) {
              if (value?.isEmpty ?? true) {
                return "Please enter your password";
              } else if (value!.length < 6) {
                return "Password must be at least 6 characters long";
              } else {
                return null;
              }
            },
            keyboardType: TextInputType.visiblePassword,
            obscureText: true,
            decoration: const InputDecoration(
              hintText: "Password",
            ),
          ),
          const SizedBox(
            height: 24,
          ),
          GetBuilder<LoginController>(
            builder: (controller) {
              return Visibility(
                visible: controller.isLoading == false,
                replacement: const Center(
                  child: CircularProgressIndicator(),
                ),
                child: ElevatedButton(
                  onPressed: _onClickLoginButton,
                  child: const Icon(Icons.arrow_circle_right_outlined),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  /// Build the sign up section
  Widget _buildSignUpSection(TextTheme textTheme) {
    return Center(
      child: Column(
        children: [
          TextButton(
            onPressed: () => Get.toNamed(VerifyEmailScreen.name),
            child: const Text(
              'Forgot Password?',
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
          ),
          RichText(
            text: TextSpan(
              text: 'Don\'t have an account? ',
              style: const TextStyle(
                color: Colors.black,
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
              children: [
                TextSpan(
                  text: ' Sign Up',
                  style: textTheme.bodyLarge?.copyWith(
                    color: AppColors.themeColor,
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () => Get.toNamed(SignupScreen.name),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _onClickLoginButton() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    _login();
  }

  Future<void> _login() async {
    bool isSuccess = await LoginController().login(
      _emailController.text.trim(),
      _passwordController.text,
    );

    if (isSuccess) {
      Get.offAllNamed(MainScreen.name);
    } else {
      Get.showSnackbar(const GetSnackBar(
        message: "Login failed",
        backgroundColor: Colors.red,
        duration: Duration(seconds: 2),
        snackPosition: SnackPosition.TOP,
      ));
    }
  }

  @override
  void dispose() {
    _emailController.clear();
    _passwordController.clear();
    super.dispose();
  }
}
