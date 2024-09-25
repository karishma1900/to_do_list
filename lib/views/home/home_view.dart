

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slider_drawer/flutter_slider_drawer.dart';
import 'package:hive/hive.dart';
import 'package:to_do_application/extensions/space_exs.dart';
import 'package:to_do_application/main.dart';
// import 'package:hive/hive.dart';
import 'package:to_do_application/models/task.dart';
import 'package:to_do_application/utils/app_colors.dart';
import 'package:to_do_application/utils/app_str.dart';
import 'package:to_do_application/utils/constants.dart';
import 'package:to_do_application/views/tasks/components/fab.dart';
import 'package:to_do_application/views/tasks/components/home_app_bar.dart';
import 'package:to_do_application/views/tasks/components/slider_drawer.dart';
import 'package:to_do_application/views/tasks/widget/task_widget.dart';
import 'package:lottie/lottie.dart';
class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
GlobalKey<SliderDrawerState> drawerKey = GlobalKey<SliderDrawerState>();
  

  // check vbalue of circle indicator

  dynamic valueOfIndicator(List<Task> task){
    if(task.isNotEmpty){
      return task.length;
    }else{
      return 3;
    }
  }

  // check Done tasks
  int checkDoneTask(List<Task> tasks){
    int i = 0;
    for(Task doneTask in tasks){
      if(doneTask.isCompleted){
       i++;
      }
      
    }
    return i;
  }
  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable

    var textTheme = Theme.of(context).textTheme;
    final base = BaseWidget.of(context);
 

    return ValueListenableBuilder(
      valueListenable: base.dataStore.listenToTask(), 
      builder: (ctx, Box<Task> box, Widget? child){

      var tasks = box.values.toList();

      tasks.sort((a,b)=>a.createdAtDate.compareTo(b.createdAtDate));
       return Scaffold(
      backgroundColor: Colors.white,
      // FAB
      floatingActionButton:Fab() ,

      body:SliderDrawer(
        key:drawerKey,
        isDraggable: false,
        animationDuration: 1000,
        slider:  CustomDrawer(),
        
        appBar: HomeAppBar(
          drawerKey: drawerKey,
        ),
        child: _buildHomeBody(
          tasks,
          textTheme
        ,base,
        ),
        )

    );
      }
      
      );
  }

// Home Body
  Widget _buildHomeBody(
      List<Task> tasks,
  TextTheme textTheme,
  BaseWidget base,

  )
   {
    return SizedBox(
      width: double.infinity,
      height: double.infinity,
 
      child: Column(
        children: [
          //Custom App Bar
          Container(
            margin: const EdgeInsets.only(top:60),
            width: double.infinity,
            height: 100,
          
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                // progress Inicator
                 SizedBox(
                  width: 25,
                  height: 25,
                  
                  child: CircularProgressIndicator(
                     value: checkDoneTask(tasks) / valueOfIndicator(tasks),
                    backgroundColor: Colors.grey,
                    valueColor: AlwaysStoppedAnimation(AppColors.primaryColor),
            
                  ),
                ),
                // Space
               20.w,

              //  top Level Task info

                Column(
                  
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      AppStr.mainTitle,
                      style:textTheme.titleLarge,
                      
                    ),
                    3.h,
                    Text("${checkDoneTask(tasks)} of ${tasks.length} task",
                    style: textTheme.titleMedium,)

                ],),
           
              ],
            ),
         
       
        
          ),


                  //  divider
            const Padding(
                padding: EdgeInsets.only(top: 10),
                child: Divider(
                  thickness: 2,
                  indent: 100,
                  
                   
                ),
              ),
      SizedBox(
              width: double.infinity,
      height: 500,
      
      child:tasks.isNotEmpty 
      ?ListView.builder(
       
       
       itemCount:tasks.length,
       scrollDirection: Axis.vertical,
              
       itemBuilder: (context,index){
         // Get single Task for showing in list
         var task = tasks[index];
      
         return Dismissible(
           
           direction: DismissDirection.horizontal,
           onDismissed: (_){
             base.dataStore.deleteTask(task: task);
             // We will remove current task from db
           },
           background: Row(
             mainAxisAlignment: MainAxisAlignment.center,
             children: [
              const Icon(
                 Icons.delete_outline,
                 color: Colors.grey,
               ),
               8.w,
              const Text(AppStr.deletedTask,
               style: TextStyle(
                 color: Colors.grey,
               ),)
             ],
           ),
           key:Key(
             task.id,
           ),
           child:TaskWidget(
             task:tasks[index],
             ));
        
       },
      ): Column(
         mainAxisAlignment: MainAxisAlignment.center,
       children:[
        FadeIn(
          child: SizedBox(
           width: 200,
           height: 200,
            child: Lottie.asset(
             lottieURL, 
             animate: tasks.isNotEmpty ? false: true,
            ),
          ),
        ),
       //  sub text
        FadeInUp(
         from:30,
          child: 
        const Text(AppStr.doneAllTask))
       ],
      ),
              )
        ],
        
      ),
    );
  }
}

