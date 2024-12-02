import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myapp/ui/controller/verify_email_controller.dart';
import 'package:myapp/ui/screens/pin_verification_screen.dart';
import 'package:myapp/ui/utils/app_colors.dart';
import 'package:myapp/ui/widgets/background_screen.dart';
import '../widgets/center_circuler_progress_indicator.dart';

class VerifyEmailScreen extends StatefulWidget {
  static const String name = '/verify_email';

  const VerifyEmailScreen({super.key});

  @override
  State<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends State<VerifyEmailScreen> {
  final VerifyEmailController verifyEmailController = Get.find();
  final TextEditingController _emailTEController = TextEditingController();
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
                'Your Email Address',
                style: textTheme.displaySmall?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              Text(
                'A 6 digits verification pin will send to your email address',
                style: textTheme.titleMedium,
              ),
              const SizedBox(
                height: 30,
              ),

              /// Sign in form
              _buildVerifyEmailForm(),

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
  Widget _buildVerifyEmailForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextFormField(
            validator: (String? value) {
              if (value?.isEmpty ?? true) {
                return "Please enter your email address";
              }
              return null;
            },
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.done,
            controller: _emailTEController,
            decoration: const InputDecoration(
              hintText: "Email",
            ),
          ),
          const SizedBox(
            height: 24,
          ),
          GetBuilder<VerifyEmailController>(builder: (controller) {
            return Visibility(
              visible: !controller.isLoading,
              replacement: const CenterCircularProgressIndicator(),
              child: ElevatedButton(
                onPressed: _onClickVerifyEmailButton,
                child: const Icon(Icons.arrow_circle_right_outlined),
              ),
            );
          })
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

  void _onClickVerifyEmailButton() async {
    if (_formKey.currentState!.validate()) {
      // Get.toNamed(PinVerificationScreen.name, arguments: _emailTEController.text);
      _verifyEmail();
    }
  }

  void _verifyEmail() async {
    bool isSuccess =
        await verifyEmailController.verifyEmail(_emailTEController.text.trim());
    if (isSuccess) {
      Get.toNamed(PinVerificationScreen.name,
          arguments: _emailTEController.text);
      Get.snackbar(
        "Success",
        verifyEmailController.data ?? "Success",
        backgroundColor: Colors.green,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    } else {
      Get.snackbar(
        "Error",
        verifyEmailController.errorMessage ?? "Error",
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void _onClickHaveAccountSignIn() {
    Get.back();
  }
}
