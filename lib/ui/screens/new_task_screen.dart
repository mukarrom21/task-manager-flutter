import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:myapp/data/utils/urls.dart';
import 'package:myapp/ui/controller/task_list_controller.dart';
import 'package:myapp/ui/controller/task_summary_controller.dart';
import 'package:myapp/ui/screens/add_new_task.dart';
import 'package:myapp/ui/screens/task_card.dart';
import 'package:myapp/ui/screens/task_summary_card.dart';
import 'package:myapp/ui/widgets/center_circuler_progress_indicator.dart';

class NewTaskScreen extends StatefulWidget {
  const NewTaskScreen({super.key});

  @override
  State<NewTaskScreen> createState() => _NewTaskScreenState();
}

class _NewTaskScreenState extends State<NewTaskScreen> {
  final TaskListController taskListController = Get.find();
  final TaskSummaryController taskSummaryController = Get.find();

  @override
  void initState() {
    _getTaskSummary();
    _getNewTasksList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => _onPressedFAB(),
        child: const Icon(Icons.add),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          _getNewTasksList();
          _getTaskSummary();
        },
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: GetBuilder<TaskListController>(builder: (controller) {
            return Visibility(
              visible: !controller.isLoading,
              replacement: const CenterCircularProgressIndicator(),
              child: Column(
                children: [
                  _taskSummary(),
                  const SizedBox(
                    height: 8,
                  ),
                  Expanded(
                    child: ListView.separated(
                      itemCount: controller.taskList.length,
                      itemBuilder: (context, index) {
                        return TaskCard(
                          task: controller.taskList[index],
                          getTaskList: () {
                            _getNewTasksList();
                            _getTaskSummary();
                          },
                        );
                      },
                      separatorBuilder: (BuildContext context, int index) {
                        return const SizedBox(
                          height: 8,
                        );
                      },
                    ),
                  ),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }

  Widget _taskSummary() {
    return GetBuilder<TaskSummaryController>(builder: (controller) {
      return Visibility(
        visible: controller.isLoading == false,
        replacement: const CenterCircularProgressIndicator(),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: controller.taskStatusCountList
                .map(
                  (e) => TaskSummaryCard(
                    title: e.sId ?? "",
                    count: e.sum ?? 0,
                  ),
                )
                .toList(),
          ),
        ),
      );
    });
  }

  Future<void> _getTaskSummary() async {
    bool isSuccess = await taskSummaryController.getTaskSummary();
    if (!isSuccess) {
      Get.showSnackbar(GetSnackBar(
        message: taskSummaryController.errorMessage,
        duration: const Duration(seconds: 2),
        backgroundColor: Colors.red,
      ));
    }
  }

  Future<void> _getNewTasksList() async {
    bool isSuccess = await taskListController.getTasksList(Urls.getNewTasks);
    if (!isSuccess) {
      Get.showSnackbar(GetSnackBar(
        message: taskListController.errorMessage,
      ));
    }
  }

  /// On Pressed FAB
  _onPressedFAB() async {
    final bool? shouldRefresh = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const AddNewTask()),
    );
    if (shouldRefresh == true) {
      _getNewTasksList();
    }
  }
}
