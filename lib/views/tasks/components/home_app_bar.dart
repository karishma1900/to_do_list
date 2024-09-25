import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slider_drawer/flutter_slider_drawer.dart';
import 'package:to_do_application/main.dart';
import 'package:to_do_application/utils/constants.dart';
// import 'package:to_do_application/utils/constants.dart';

class HomeAppBar extends StatefulWidget {
  const HomeAppBar({super.key, required this.drawerKey});
  final GlobalKey<SliderDrawerState> drawerKey;
  @override
  State<HomeAppBar> createState() => _HomeAppBarState();
}

class _HomeAppBarState extends State<HomeAppBar> with SingleTickerProviderStateMixin{
  late AnimationController animationController;
  bool isDrawerOpen = false;
   @override
  void initState() {
   animationController = AnimationController(vsync: this,
   duration: const Duration(seconds:1));
    super.initState();
  }

  @override
  void dispose(){
    animationController.dispose();
    super.dispose();
  }

// ontoggle
  void onDrawerToggle(){
    setState(() {
      isDrawerOpen = !isDrawerOpen;
      if(isDrawerOpen){
        animationController.forward();
        widget.drawerKey.currentState!.openSlider();

      }else{
        animationController.reverse();
            widget.drawerKey.currentState!.closeSlider();
      }
    });
  }
  @override
  Widget build(BuildContext context) {

var base = BaseWidget.of(context).dataStore.box;

    return SizedBox(
     width:double.infinity,
     height:130,
     child:Padding(
       padding: const EdgeInsets.only(top:20),
       child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [

          // menu Icon
          Padding(
            padding: const EdgeInsets.only(left:20),
            child: IconButton(
              onPressed:onDrawerToggle,
               icon: AnimatedIcon(
                icon:AnimatedIcons.menu_close,
                progress:animationController,
                size: 40,
                )),
          ),
          // trash Icon
          Padding(
            padding: const EdgeInsets.only(right:20),
            child: IconButton(
              onPressed:(){
               base.isEmpty
               ? noTaskWarning(context)
               :deleteAllTask(context);
                // we will remove all task from db using this delete
              },
               icon: Icon(
               CupertinoIcons.trash_fill,
                size: 40,
                )),
          )
        ],
       ),
     )
    );
  }
}