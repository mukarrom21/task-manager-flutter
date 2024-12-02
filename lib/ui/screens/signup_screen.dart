import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myapp/ui/controller/sign_up_controller.dart';
import 'package:myapp/ui/utils/app_colors.dart';
import 'package:myapp/ui/widgets/background_screen.dart';

class SignupScreen extends StatefulWidget {
  static const String name = '/signup-screen';

  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final SignUpController signUpController = Get.find();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailTEController = TextEditingController();
  final TextEditingController _firstNameTEController = TextEditingController();
  final TextEditingController _lastNameTEController = TextEditingController();
  final TextEditingController _mobileTEController = TextEditingController();
  final TextEditingController _passwordTEController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return Scaffold(
      // resizeToAvoidBottomInset: false,
      body: BackgroundScreen(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 85,
                ),

                /// Title Section
                Text(
                  'Join With Us',
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
      ),
    );
  }

  /// Build the sign in form
  Widget _buildSignInForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          /// email
          TextFormField(
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              hintText: "Email",
            ),
            autovalidateMode: AutovalidateMode.onUserInteraction,
            controller: _emailTEController,
            validator: (String? value) {
              if (value?.isEmpty ?? true) {
                return "Please enter your valid email address.";
              }
              return null;
            },
          ),
          const SizedBox(
            height: 12,
          ),

          /// first name
          TextFormField(
            keyboardType: TextInputType.text,
            decoration: const InputDecoration(
              hintText: "First Name",
            ),
            autovalidateMode: AutovalidateMode.onUserInteraction,
            controller: _firstNameTEController,
            validator: (String? value) {
              if (value?.isEmpty ?? true) {
                return "Please enter your first name.";
              }
              return null;
            },
          ),
          const SizedBox(
            height: 12,
          ),

          /// last name
          TextFormField(
            keyboardType: TextInputType.text,
            decoration: const InputDecoration(
              hintText: "Last Name",
            ),
            autovalidateMode: AutovalidateMode.onUserInteraction,
            controller: _lastNameTEController,
            validator: (String? value) {
              if (value?.isEmpty ?? true) {
                return "Please enter your last name.";
              }
              return null;
            },
          ),
          const SizedBox(
            height: 12,
          ),

          /// mobile no
          TextFormField(
            keyboardType: TextInputType.phone,
            decoration: const InputDecoration(
              hintText: "Mobile",
            ),
            autovalidateMode: AutovalidateMode.onUserInteraction,
            controller: _mobileTEController,
            validator: (String? value) {
              if (value?.isEmpty ?? true) {
                return "Please enter your mobile no.";
              }
              return null;
            },
          ),
          const SizedBox(
            height: 12,
          ),

          /// password
          TextFormField(
            keyboardType: TextInputType.text,
            obscureText: true,
            decoration: const InputDecoration(
              hintText: "Password",
            ),
            autovalidateMode: AutovalidateMode.onUserInteraction,
            controller: _passwordTEController,
            validator: (String? value) {
              if (value?.isEmpty ?? true) {
                return "Please enter your password.";
              }
              return null;
            },
          ),
          const SizedBox(
            height: 24,
          ),

          // const CircularProgressIndicator(),

          /// save button
          GetBuilder<SignUpController>(builder: (controller) {
            return Visibility(
              visible: !controller.isLoading,
              replacement: const Center(
                child: CircularProgressIndicator(),
              ),
              child: ElevatedButton(
                onPressed: _onClickNextArrowSignUpButton,
                child: const Icon(Icons.arrow_circle_right_outlined),
              ),
            );
          }),
        ],
      ),
    );
  }

  /// Build the sign up section
  Widget _buildSignUpSection(TextTheme textTheme) {
    return Center(
      child: Column(
        children: [
          RichText(
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
        ],
      ),
    );
  }

  void _onClickNextArrowSignUpButton() {
    if (_formKey.currentState!.validate()) {
      _signUp();
    }
  }

  Future<void> _signUp() async {
    Map<String, dynamic> requestData = {
      "email": _emailTEController.text.trim(),
      "firstName": _firstNameTEController.text.trim(),
      "lastName": _lastNameTEController.text.trim(),
      "mobile": _mobileTEController.text.trim(),
      "password": _passwordTEController.text,
    };

    bool isSuccess = await signUpController.signUp(requestData);
    if (isSuccess) {
      Get.back();
      Get.showSnackbar(const GetSnackBar(
        message: "Signup completed successfully. Please login.",
        duration: Duration(seconds: 3),
        backgroundColor: Colors.green,
      ));
    } else {
      Get.showSnackbar(const GetSnackBar(
        message: "Signup failed",
        duration: Duration(seconds: 3),
        backgroundColor: Colors.red,
        snackPosition: SnackPosition.TOP,
      ));
    }
  }

  void _onClickHaveAccountSignIn() => Get.back();

  @override
  void dispose() {
    _firstNameTEController.dispose();
    _lastNameTEController.dispose();
    _mobileTEController.dispose();
    _emailTEController.dispose();
    _passwordTEController.dispose();
    super.dispose();
  }
}
