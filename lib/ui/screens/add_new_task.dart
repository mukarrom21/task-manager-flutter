import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myapp/ui/controller/add_new_task_controller.dart';
import 'package:myapp/ui/widgets/app_bar_header.dart';

class AddNewTask extends StatefulWidget {
  const AddNewTask({super.key});

  @override
  State<AddNewTask> createState() => _AddNewTaskState();
}

class _AddNewTaskState extends State<AddNewTask> {
  final AddNewTaskController addNewTaskController =
      Get.put(AddNewTaskController());

  final TextEditingController _titleTEController = TextEditingController();
  final TextEditingController _descriptionTEController =
      TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  // final bool _isLoading = false;
  // final bool _shouldRefreshPreviousPage = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const AppBarHeader(),
      // body: PopScope(
      //   canPop: false,
      //   onPopInvokedWithResult: (didPop, result) {
      //     if (didPop) {
      //       return;
      //     }
      //     // Get.back(result: _shouldRefreshPreviousPage);
      //     Navigator.pop(context, _shouldRefreshPreviousPage);
      //   },
      //   child: Padding(
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 40,
              ),
              Text(
                "Add New Task",
                style: Theme.of(context)
                    .textTheme
                    .headlineSmall
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 12,
              ),

              /// title form field
              TextFormField(
                controller: _titleTEController,
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return "Please add title";
                  }
                  return null;
                },
                decoration: const InputDecoration(
                  hintText: 'Title',
                ),
              ),
              const SizedBox(
                height: 12,
              ),

              /// description form field
              TextFormField(
                controller: _descriptionTEController,
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return "Please add Description";
                  }
                  return null;
                },
                keyboardType: TextInputType.multiline,
                maxLines: 5,
                decoration: const InputDecoration(
                  hintText: 'Description',
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              GetBuilder<AddNewTaskController>(
                builder: (controller) {
                  return Visibility(
                    visible: !controller.isLoading,
                    replacement: const Center(
                      child: CircularProgressIndicator(),
                    ),
                    child: ElevatedButton(
                      onPressed: _onPressedSubmitButton,
                      child: const Icon(Icons.arrow_circle_right_outlined),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onPressedSubmitButton() {
    if (_formKey.currentState!.validate()) {
      _addNewTask();
    }
  }

  Future<void> _addNewTask() async {
    Map<String, dynamic> requestBody = {
      "title": _titleTEController.text.trim(),
      "description": _descriptionTEController.text,
      "status": "New"
    };

    bool isSuccess = await addNewTaskController.addNewTask(requestBody);
    if (isSuccess) {
      Get.back(closeOverlays: true, result: true);
      Get.snackbar(
        "Success",
        "Task added successfully",
        backgroundColor: Colors.green,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    } else {
      Get.snackbar(
        "Error",
        addNewTaskController.errorMessage,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  // void _clearTextField() {
  //   _titleTEController.clear();
  //   _descriptionTEController.clear();
  // }

  @override
  void dispose() {
    super.dispose();
    _titleTEController.dispose();
    _descriptionTEController.dispose();
  }
}
