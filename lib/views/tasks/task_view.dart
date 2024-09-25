import 'package:flutter/material.dart';
import 'package:flutter_cupertino_date_picker_fork/flutter_cupertino_date_picker_fork.dart';
import 'package:intl/intl.dart';
import 'package:to_do_application/extensions/space_exs.dart';
import 'package:to_do_application/main.dart';
import 'package:to_do_application/models/task.dart';
import 'package:to_do_application/utils/app_colors.dart';
import 'package:to_do_application/utils/app_str.dart';
import 'package:to_do_application/utils/constants.dart';
import 'package:to_do_application/views/tasks/components/date_time_selection.dart';
import 'package:to_do_application/views/tasks/components/rep_textfield.dart';
import 'package:to_do_application/views/tasks/widget/task_view_app_bar.dart';


// import 'package:hive/hive.dart';

class TaskView extends StatefulWidget {
  const TaskView(
      {
        super.key,
      required this.titleTaskController,
      required this.descriptionTaskController,
      this.task});
  final TextEditingController? titleTaskController;
  final TextEditingController? descriptionTaskController;
  final Task? task;

  @override
  State<TaskView> createState() => _TaskViewState();
}

class _TaskViewState extends State<TaskView> {
  
  var title;
  var subTitle;

  DateTime? time;
  DateTime? date;

// show selected tiome as string format

String showTime(DateTime? time){
  if(widget.task?.createdAtTime == null){
    if(time==null){
      return DateFormat('hh:mm a').format(DateTime.now()).toString();
    }else{
      return DateFormat('hh:mm a').format(time).toString();
    }

  }else{
      return DateFormat('hh:mm a').format(widget.task!.createdAtTime).toString();
  }
}

String showDate(DateTime? date){
 if(widget.task?.createdAtDate == null){
    if(date == null){
      return DateFormat.yMMMEd().format(DateTime.now()).toString();
    }else{
      return DateFormat.yMMMEd().format(date).toString();
    }

  }else{
      return DateFormat.yMMMEd().format(widget.task!.createdAtDate).toString();
  }
}

// show Selected date as dateformat for init time
DateTime showDateAsDateTime(DateTime? date){
  if(widget.task?.createdAtDate == null){
    if(date == null){
      return DateTime.now();
    }else{
      return date;
    }
  }else{
    return widget.task!.createdAtDate;
  }
}

  // if any task already exits return true oyther wais efalse
 bool isTaskAlreadyExist() {
    if (widget.titleTaskController?.text == null &&
        widget.descriptionTaskController?.text == null) {
      return true;
    } else {
      return false;
    }
  }

  // Main function fo creating or updating task


  dynamic isTaskAlreadyExistUpdateTask() {
    if (widget.titleTaskController?.text != null &&
        widget.descriptionTaskController?.text != null) {
      try {
        widget.titleTaskController?.text = title;
        widget.descriptionTaskController?.text =subTitle;

        // widget.task?.createdAtDate = date!;
        // widget.task?.createdAtTime = time!;

        widget.task?.save();
        Navigator.of(context).pop();
      } catch (error) {
        
        updateTaskwarning(context);
      }
    } else {
      if (title != null && subTitle != null) {
        var task = Task.created(
          title: title,
          createdAtTime: time,
          createdAtDate: date,
          subTitle: subTitle,
        );
        BaseWidget.of(context).dataStore.addTask(task: task);
        Navigator.of(context).pop();
      } else {
        
        emptywarning(context);
      }
    }
  }

  // delete task
  dynamic deleteTask(){
    return widget.task?.delete();
  }
  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;

    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus!.unfocus(),
      child: Scaffold(
          appBar: TaskViewAppBar(),
          body: SizedBox(
            width: double.infinity,
            height: double.infinity,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  // top side texts
                  _buildTopSideTexts(textTheme),

                  _buildMainTaskViewActivity(textTheme, context),

                  // Bottom Side Button
                  _builtBottomSideButtons()
                ],
              ),
            ),
          )),
    );
  }

  Widget _builtBottomSideButtons() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        mainAxisAlignment:
        isTaskAlreadyExist()
        ? MainAxisAlignment.center
        :MainAxisAlignment.spaceEvenly,
        
       
        children: [
          isTaskAlreadyExist()
          ? Container()
          :
          // Delete Current Task Button
          MaterialButton(
            onPressed: () {
              deleteTask();
              Navigator.pop(context);
        
            },
            minWidth: 150,
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            height: 55,
            child: Row(
              children: const [
                Icon(
                  Icons.close,
                  color: AppColors.primaryColor,
                ),
                Text(
                  AppStr.deleteTask,
                  style: TextStyle(color: AppColors.primaryColor),
                ),
              ],
            ),
          ),

          MaterialButton(
            onPressed: () {
              // Add or Update Task Button
          isTaskAlreadyExistUpdateTask();
            },
            minWidth: 150,
            color: AppColors.primaryColor,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            height: 55,
            child: Text(
               isTaskAlreadyExist()
               ? AppStr.addTaskString
               :AppStr.updateCurrentTask,
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
  // Main Task View Activity

  Widget _buildMainTaskViewActivity(TextTheme textTheme, BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 530,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 30),
            child: Text(
              AppStr.titleOfTitleTextField,
              style: textTheme.headlineMedium,
            ),
          ),
          // task Title
          RepTextField(
            controller: widget.titleTaskController,
             onFieldSubmitted: (String inputTitle) { 
               title = inputTitle;
              }, 
            onChanged: (String inputTitle) {
              title = inputTitle;
       
             },
            
          ),
          10.h,
          RepTextField(
            controller: widget.descriptionTaskController,
            isForDescription: true, 
            onFieldSubmitted: (String inputSubTitle) { 
               subTitle = inputSubTitle;
             }, onChanged: (String inputSubTitle) { 
               subTitle = inputSubTitle;
              },
          ),

          // Time Selection
          DateTimeSelectionWidget(
            onTap: () {
              showModalBottomSheet(
                  context: context,
                  builder: (_) => SizedBox(
                        height: 280,
                        child: TimePickerWidget(
                          onChange: (_, __) {},
                          initDateTime: showDateAsDateTime(time),
                          dateFormat: 'HH:mm',
                          onConfirm: (dateTime, _) {
                            setState(() {
                              if(widget.task?.createdAtTime == null){
                                time = dateTime;

                              }else{
                                widget.task!.createdAtTime = dateTime;
                              }
                            });
                          },
                        ),
                      ));
            },
            title: AppStr.timeString, time:showTime(time),
          ),
          DateTimeSelectionWidget(
            onTap: () {
              DatePicker.showDatePicker(context,
                  maxDateTime: DateTime(2030, 4, 5),
                  minDateTime: DateTime.now(),
                  initialDateTime: showDateAsDateTime(date),
                  onConfirm: (dateTime, _) {
                     setState(() {
                              if(widget.task?.createdAtDate == null){
                                date = dateTime;

                              }else{
                                widget.task!.createdAtDate = dateTime;
                              }
                            });
                  });
            },
            title: AppStr.dateString, 
            isTime: true,
            time:showDate(date),
          )
        ],
      ),
    );
  }

  Widget _buildTopSideTexts(TextTheme TextTheme) {
    return SizedBox(
      width: double.infinity,
      height: 100,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(
            width: 80,
            child: Divider(
              thickness: 2,
            ),
          ),
          // late according to the task condition we will decide to add new task or update current
          RichText(
              text: TextSpan(
            text: isTaskAlreadyExist()?
            AppStr.addNewTask : AppStr.updateCurrentTask,
            style: TextTheme.titleLarge,
            children: const [
              TextSpan(
                  text: AppStr.taskString,
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                  ))
            ],
          )),
          const SizedBox(
            width: 80,
            child: Divider(
              thickness: 2,
            ),
          ),
        ],
      ),
    );
  }
}
