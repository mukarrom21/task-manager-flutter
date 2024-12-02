import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myapp/ui/controller/auth_controller.dart';
import 'package:myapp/ui/controller/update_profile_controller.dart';
import 'package:myapp/ui/screens/update_profile_screen.dart';
import 'package:myapp/ui/screens/sign_in_screen.dart';
import 'package:myapp/ui/widgets/center_circuler_progress_indicator.dart';
import '../utils/app_colors.dart';

class AppBarHeader extends StatelessWidget implements PreferredSizeWidget {
  const AppBarHeader({
    super.key,
    this.isProfileScreen = false,
  });

  final bool isProfileScreen;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (isProfileScreen) return;
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const UpdateProfileScreen()));
      },
      child: AppBar(
        backgroundColor: AppColors.themeColor,
        title: GetBuilder<UpdateProfileController>(builder: (controller) {
          return Visibility(
            visible: !controller.isLoading,
            replacement: const CenterCircularProgressIndicator(),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 25,
                  backgroundColor: Colors.white,
                  child: AuthController.userData?.photo != null
                      ? ClipOval(
                          child: Image.memory(
                            base64Decode(AuthController.userData!.photo!),
                            fit: BoxFit.cover,
                            width: 50,
                            height: 50,
                          ),
                        )
                      : const Icon(
                          Icons.person,
                          color: AppColors.themeColor,
                        ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${AuthController.userData?.firstName} ${AuthController.userData?.lastName}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    Text(
                      '${AuthController.userData?.email}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        }),
        actions: [
          IconButton(
              onPressed: () async {
                /// Clear access token
                await AuthController.clearUserData();

                /// Navigate to sign in screen
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SignInScreen(),
                  ),
                  (Route<dynamic> route) => false,
                );
              },
              icon: const Icon(Icons.logout_outlined)),
        ],
      ),
    );
  }

  @override
  // TODO: implement preferredSize
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
