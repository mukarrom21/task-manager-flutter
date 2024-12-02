import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:myapp/data/models/network_response.dart';
import 'package:myapp/data/models/user_model.dart';
import 'package:myapp/data/services/network_caller.dart';
import 'package:myapp/data/utils/urls.dart';
import 'package:myapp/ui/controller/auth_controller.dart';
import 'package:myapp/ui/controller/update_profile_controller.dart';
import 'package:myapp/ui/widgets/app_bar_header.dart';
import 'package:myapp/ui/widgets/center_circuler_progress_indicator.dart';
import 'package:myapp/ui/widgets/snack_bar_message.dart';

class UpdateProfileScreen extends StatefulWidget {
  const UpdateProfileScreen({super.key});

  @override
  State<UpdateProfileScreen> createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  final UpdateProfileController _updateProfileController = Get.find();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  XFile? _imageFile;
  final TextEditingController _emailTEController = TextEditingController(
    text: AuthController.userData?.email,
  );
  final TextEditingController _firstNameTEController = TextEditingController(
    text: AuthController.userData?.firstName,
  );
  final TextEditingController _lastNameTEController = TextEditingController(
    text: AuthController.userData?.lastName,
  );
  final TextEditingController _mobileTEController = TextEditingController(
    text: AuthController.userData?.mobile,
  );
  final TextEditingController _passwordTEController = TextEditingController();

  @override
  void initState() {
    if (AuthController.userData?.photo != null) {
      _setImageFromBase64(AuthController.userData!.photo!);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarHeader(
        isProfileScreen: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: _buildForm(context),
        ),
      ),
    );
  }

  Widget _buildForm(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 48),
          Text(
            'Profile Screen',
            style: Theme.of(context).textTheme.headlineLarge,
          ),
          const SizedBox(
            height: 24,
          ),
          _buildAddPhoto(),
          const SizedBox(
            height: 8,
          ),
          TextFormField(
            keyboardType: TextInputType.emailAddress,
            controller: _emailTEController,
            enabled: false,
            decoration: const InputDecoration(
              hintText: 'Email',
            ),
            validator: (String? value) {
              if (value?.trim().isEmpty ?? true) {
                return 'Please enter your valid email address';
              }
              return null;
            },
          ),
          const SizedBox(
            height: 8,
          ),
          TextFormField(
            keyboardType: TextInputType.text,
            controller: _firstNameTEController,
            decoration: const InputDecoration(
              hintText: 'First Name',
            ),
            validator: (String? value) {
              if (value?.trim().isEmpty ?? true) {
                return 'Please enter your first name';
              }
              return null;
            },
          ),
          const SizedBox(
            height: 8,
          ),
          TextFormField(
            keyboardType: TextInputType.text,
            controller: _lastNameTEController,
            decoration: const InputDecoration(
              hintText: 'Last Name',
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          TextFormField(
            keyboardType: TextInputType.phone,
            controller: _mobileTEController,
            decoration: const InputDecoration(
              hintText: 'Mobile',
            ),
            validator: (String? value) {
              if (value?.trim().isEmpty ?? true) {
                return 'Please enter your mobile number';
              }
              return null;
            },
          ),
          const SizedBox(
            height: 8,
          ),
          TextFormField(
            obscureText: true,
            controller: _passwordTEController,
            decoration: const InputDecoration(
              hintText: 'Password',
            ),
          ),
          const SizedBox(
            height: 8,
          ),
          GetBuilder<UpdateProfileController>(builder: (controller) {
            return Visibility(
              visible: !controller.isLoading,
              replacement: const CenterCircularProgressIndicator(),
              child: ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _updateProfile();
                  }
                },
                child: const Icon(Icons.arrow_circle_right_outlined),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildAddPhoto() {
    return GestureDetector(
      onTap: _pickImage,
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: Colors.white,
        ),
        child: Row(
          children: [
            Container(
              width: 100,
              height: 50,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(8),
                  bottomLeft: Radius.circular(8),
                ),
                color: Colors.grey,
              ),
              child: Center(
                child: Text(
                  _imageFile != null ? 'Change' : 'Add',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            if (_imageFile != null)
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text(
                    _imageFile!.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickImage() async {
    // Pick an image
    final ImagePicker picker = ImagePicker();
    final XFile? pickedImage =
        await picker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        _imageFile = pickedImage;
      });
    }
  }

  // update profile
  Future<void> _updateProfile() async {
    Map<String, dynamic> requestBody = {
      'email': _emailTEController.text.trim(),
      'firstName': _firstNameTEController.text.trim(),
      'lastName': _lastNameTEController.text.trim(),
      'mobile': _mobileTEController.text.trim(),
    };
    // check if image is not null then add it
    if (_imageFile != null) {
      List<int> imageBytes = await _imageFile!.readAsBytes();
      String encodedImage = base64Encode(imageBytes);
      requestBody["photo"] = encodedImage;
    }
    // check if password is not null then add it
    if (_passwordTEController.text.isNotEmpty) {
      requestBody["password"] = _passwordTEController.text;
    }

    final bool isSuccess =
        await _updateProfileController.updateProfile(requestBody);
    if (isSuccess) {
      Get.snackbar(
        "Congratulations",
        "Your profile has been updated successfully",
        backgroundColor: Colors.green,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    } else {
      Get.snackbar(
        "Error",
        _updateProfileController.errorMessage,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  // dispose
  @override
  void dispose() {
    _firstNameTEController.dispose();
    _lastNameTEController.dispose();
    _mobileTEController.dispose();
    _emailTEController.dispose();
    _passwordTEController.dispose();
    super.dispose();
  }

  Future<void> _setImageFromBase64(String base64String) async {
    // Decode the Base64 string into bytes
    List<int> imageBytes = base64Decode(base64String);

    // Get the temporary directory for saving the image
    final Directory tempDir = await getTemporaryDirectory();
    final String filePath = '${tempDir.path}/profile_image.png';

    // Write the bytes to a file
    File imageFile = File(filePath);
    await imageFile.writeAsBytes(imageBytes);

    // Create an XFile from file path
    setState(() {
      _imageFile = XFile(filePath);
    });
  }
}
