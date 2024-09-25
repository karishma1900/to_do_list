import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:hive/hive.dart';
import 'package:to_do_application/utils/app_colors.dart';
import 'package:to_do_application/extensions/space_exs.dart';

class CustomDrawer extends StatelessWidget {
  CustomDrawer({super.key});

final List<IconData> icons = [
  CupertinoIcons.home,
  CupertinoIcons.person_2_fill,
  CupertinoIcons.settings,
  CupertinoIcons.info_circle_fill,
];

final List<String> texts= [
  "Home",
  "Profile",
  "Settings",
  "Details",
];
  @override
  Widget build(BuildContext context) {


    // ignore: unused_local_variable
    var textTheme  = Theme.of(context).textTheme;

    return Container(
      padding: const EdgeInsets.symmetric(vertical:90),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors:AppColors.primaryGradientColor,
          begin:Alignment.topLeft,
          end:Alignment.bottomRight
        ),
        
      ),
      child: Column(
        children: [

        const  CircleAvatar(
            radius: 50,
            backgroundImage: NetworkImage("https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRBAUqE61b-z8Yvx92SM2gPpRbOZgqoHAA-Nw&s"),
          
          ),

          15.h,
        Text("Karishma", style:textTheme.displayMedium,
          
          ),
        Text("Flutter Dev", style:textTheme.displaySmall),
     
           35.h,
      Container(
        margin: const EdgeInsets.symmetric(vertical: 30, horizontal: 10),
        width: double.infinity,
        height: 300,
        child: ListView.builder(
          itemCount: icons.length,
          itemBuilder: (BuildContext context, int index){
            return InkWell(
              onTap: (){
                log('${texts[index]} Item Tapped!');
              },
              child: Container(
                margin: EdgeInsets.all(3),
                child: ListTile(
                  leading: Icon(icons[index],
                  color: Colors.white,
                  size: 30,),
                  title: Text(texts[index],
                  style: textTheme.displaySmall),
                ),
              ),
            );
          },
        ),
      )
        ],
      ),
    );
  }
}