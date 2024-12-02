import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:myapp/data/models/network_response.dart';
import 'package:myapp/ui/controller/verify_otp_controller.dart';
import 'package:myapp/ui/screens/reset_password_screen.dart';
import 'package:myapp/ui/screens/sign_in_screen.dart';
import 'package:myapp/ui/utils/app_colors.dart';
import 'package:myapp/ui/widgets/background_screen.dart';
import 'package:myapp/ui/widgets/center_circuler_progress_indicator.dart';

class PinVerificationScreen extends StatefulWidget {
  static const String name = 'PinVerificationScreen';

  const PinVerificationScreen({super.key});

  @override
  State<PinVerificationScreen> createState() => _PinVerificationScreenState();
}

class _PinVerificationScreenState extends State<PinVerificationScreen> {
  final VerifyOtpController _verifyOtpController = Get.find();
  final String _email = Get.arguments;
  String? _pinCode;

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
                'PIN Verification',
                style: textTheme.displaySmall?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              Text(
                'A 6 digits verification pin has been sent to your email address',
                style: textTheme.titleMedium,
              ),
              const SizedBox(
                height: 30,
              ),

              /// Sign in form
              _buildPinVerificationForm(),

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
  Widget _buildPinVerificationForm() {
    return Form(
      child: Column(
        children: [
          PinCodeTextField(
            length: 6,
            obscureText: false,
            animationType: AnimationType.fade,
            textStyle: const TextStyle(
              color: Colors.white,
            ),
            pinTheme: PinTheme(
              shape: PinCodeFieldShape.box,
              borderRadius: BorderRadius.circular(8),
              fieldHeight: 50,
              fieldWidth: 40,
              activeFillColor: Colors.green,
              activeColor: Colors.green,
              inactiveColor: Colors.white,
              selectedColor: AppColors.themeColor,
              selectedFillColor: Colors.white,
              inactiveFillColor: Colors.white,
            ),
            animationDuration: const Duration(milliseconds: 300),
            backgroundColor: Colors.transparent,
            enableActiveFill: true,
            // errorAnimationController: errorController,
            // controller: textEditingController,
            onCompleted: (v) {
              _pinCode = v;
              setState(() {});
            },
            // onChanged: (value) {
            //   print(value);
            //   setState(() {
            //     currentText = value;
            //   });
            // },
            beforeTextPaste: (text) {
              print("Allowing to paste $text");
              //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
              //but you can show anything you want here, like your pop up saying wrong paste format or etc
              return true;
            },
            appContext: context,
          ),
          const SizedBox(
            height: 24,
          ),
          GetBuilder<VerifyOtpController>(builder: (controller) {
            return Visibility(
              visible: !controller.isLoading,
              replacement: const CenterCircularProgressIndicator(),
              child: ElevatedButton(
                statesController: WidgetStatesController(),
                onPressed: () {
                  if (_pinCode != null && _pinCode!.length == 6) {
                    _onClickVerifyButton();
                  }
                  return;
                },
                child: const Text("Verify"),
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

  void _onClickVerifyButton() async {
    final bool isSuccess =
        await _verifyOtpController.verifyOtp(_email, _pinCode!);
    if (isSuccess) {
      Get.snackbar("Success", _verifyOtpController.data ?? "");
      Get.toNamed(ResetPasswordScreen.name, arguments: [_email, _pinCode!]);
    } else {
      Get.snackbar("Error", _verifyOtpController.errorMessage ?? "");
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
