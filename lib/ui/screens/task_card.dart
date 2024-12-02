import 'package:flutter/material.dart';
import 'package:myapp/data/models/network_response.dart';
import 'package:myapp/data/models/task_model.dart';
import 'package:myapp/ui/widgets/center_circuler_progress_indicator.dart';
import 'package:myapp/ui/widgets/snack_bar_message.dart';

import '../../data/services/network_caller.dart';
import '../../data/utils/urls.dart';
import '../utils/app_colors.dart';

class TaskCard extends StatefulWidget {
  const TaskCard({super.key, this.task, required this.getTaskList});

  final TaskModel? task;
  final Function() getTaskList;

  @override
  State<TaskCard> createState() => _TaskCardState();
}

class _TaskCardState extends State<TaskCard> {
  bool _changeStatusInProgress = false;
  bool _deleteInProgress = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 0,
      child: SizedBox(
        width: 100,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.task?.title ?? "title",
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              Text(widget.task?.description ??
                  'Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet. Lorem ipsum dolor sit amet. '),
              Text(widget.task?.createdDate ?? "26/10/2022"),
              Row(
                children: [
                  _buildStatusChip(),
                  const Spacer(),

                  /// Edit Button
                  Visibility(
                    visible: _changeStatusInProgress == false,
                    replacement: const CenterCircularProgressIndicator(),
                    child: IconButton(
                      onPressed: _onPressedEditButton,
                      icon: const Icon(
                        Icons.edit,
                        color: AppColors.themeColor,
                      ),
                    ),
                  ),

                  /// Delete Button
                  Visibility(
                    visible: _deleteInProgress == false,
                    replacement: const CenterCircularProgressIndicator(),
                    child: IconButton(
                      onPressed: _onPressedDeleteButton,
                      icon: const Icon(
                        Icons.delete,
                        color: Colors.red,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusChip() {
    return Chip(
      label: Text(
        widget.task?.status ?? "New",
        style: const TextStyle(
          color: AppColors.themeColor,
        ),
      ),
      color: const WidgetStatePropertyAll(Colors.white),
      side: const BorderSide(
        color: AppColors.themeColor,
        width: 1,
      ),
      shape: const StadiumBorder(
        side: BorderSide(
          color: AppColors.themeColor,
          width: 1,
        ),
      ),
    );
  }

  void _onPressedEditButton() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text("Edit Task Status"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: ["New", "Completed", "Cancelled", "Progress"]
                    .map(
                      (e) => ListTile(
                        tileColor:
                            widget.task?.status == e ? Colors.grey : null,
                        title: Text(e),
                        onTap: () {
                          _onTapChangeStatus(e);
                          Navigator.pop(context);
                        },
                        selected: widget.task?.status == e ? true : false,
                        selectedColor: AppColors.themeColor,
                        trailing: widget.task?.status == e
                            ? const Icon(Icons.check)
                            : null,
                      ),
                    )
                    .toList(),
              ),
            ));
  }

  Future<void> _onTapChangeStatus(String e) async {
    setState(() {
      _changeStatusInProgress = true;
    });
    NetworkResponse response = await NetworkCaller.getRequest(
      Urls.updateTaskStatus(widget.task!.sId!, e),
    );
    if (response.isSuccess) {
      setState(() {
        _changeStatusInProgress = false;
      });
      widget.getTaskList();
    } else {
      setState(() {
        _changeStatusInProgress = false;
      });
      showSnackBarMessage(context, response.errorMessage, true);
    }
  }

  Future<void> _onPressedDeleteButton() async {
    setState(() {
      _deleteInProgress = true;
    });
    NetworkResponse response = await NetworkCaller.getRequest(
      Urls.deleteTask(widget.task!.sId!),
    );
    if (response.isSuccess) {
      widget.getTaskList();
    } else {
      showSnackBarMessage(context, response.errorMessage, true);
    }
    setState(() {
      _deleteInProgress = false;
    });
  }
}
