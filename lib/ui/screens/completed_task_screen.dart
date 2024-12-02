import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myapp/data/utils/urls.dart';
import 'package:myapp/ui/controller/task_list_controller.dart';
import 'package:myapp/ui/screens/task_card.dart';
import 'package:myapp/ui/widgets/center_circuler_progress_indicator.dart';

class CompletedTaskScreen extends StatefulWidget {
  const CompletedTaskScreen({super.key});

  @override
  State<CompletedTaskScreen> createState() => _CompletedTaskScreenState();
}

class _CompletedTaskScreenState extends State<CompletedTaskScreen> {
  TaskListController taskListController = Get.find();

  @override
  void initState() {
    _getCompletedTasks();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<TaskListController>(builder: (controller) {
      return Visibility(
        visible: controller.isLoading == false,
        replacement: const CenterCircularProgressIndicator(),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView.separated(
            itemCount: controller.taskList.length,
            itemBuilder: (context, index) {
              return TaskCard(
                task: controller.taskList[index],
                getTaskList: _getCompletedTasks,
              );
            },
            separatorBuilder: (BuildContext context, int index) {
              return const SizedBox(
                height: 8,
              );
            },
          ),
        ),
      );
    });
  }

  Future<void> _getCompletedTasks() async {
    bool isSuccess =
        await taskListController.getTasksList(Urls.getCompletedTasks);
    if (!isSuccess) {
      Get.showSnackbar(GetSnackBar(
        message: taskListController.errorMessage,
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.red,
      ));
    }
  }
}
