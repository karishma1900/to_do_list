import 'package:flutter/material.dart';
import 'package:ftoast/ftoast.dart';
import 'package:panara_dialogs/panara_dialogs.dart';
import 'package:to_do_application/main.dart';
import 'package:to_do_application/utils/app_str.dart';

String lottieURL = 'assets/lottie/1.json';

// empty title od subtitle wrnings

dynamic emptywarning(BuildContext context){
  return FToast.toast(
    context,
  msg:AppStr.oopsMsh,
  subMsg: 'You Must Fill all the fields',
  corner:20.0,
  duration: 2000,
  padding: const EdgeInsets.all(20));
 
}
// nothing enterets when user try to edit or upadte the current task
dynamic updateTaskwarning(BuildContext context){
  return FToast.toast(
    context,
  msg:AppStr.oopsMsh,
  subMsg: 'You Must edit the task the try to update it!',
  corner:20.0,
  duration: 5000,
  padding: const EdgeInsets.all(20));
 
}

// no task warning dialog for deleting

dynamic noTaskWarning(BuildContext context){
  return PanaraInfoDialog.showAnimatedGrow(context,
  title: AppStr.oopsMsh,
  message:"There is no Task for delete \n Try adding some and then try to delete it!",
  buttonText:"ok",
  onTapDismiss:(){
    Navigator.pop(context);
  },
  panaraDialogType: PanaraDialogType.warning,
   );

}

// delete all task from DB dialog
dynamic deleteAllTask(BuildContext context){
  return PanaraConfirmDialog.show(
    context,
    title: AppStr.areYouSure,
    message: "Do You Really want to delete all task? you will no be able to undo this action!",
    confirmButtonText: 'Yes',
    cancelButtonText: "No",
    onTapConfirm: (){
      // we will clear all the box data using this command
      BaseWidget.of(context).dataStore.box.clear();
      Navigator.pop(context);
    },
    onTapCancel: (){
      Navigator.pop(context);
    },
    panaraDialogType: PanaraDialogType.error,barrierDismissible: false
  );
}

