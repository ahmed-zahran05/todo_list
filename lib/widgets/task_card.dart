import 'package:flutter/material.dart';
import 'package:todo_list/core/colors.dart';

Widget TaskCard() {
  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Card(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SizedBox(width: 7),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width: 8,
              height: 62,
              decoration: BoxDecoration(
                borderRadius: BorderRadiusGeometry.circular(5),
                color: AppColors.appBarColor,
              ),
            ),
          ),
          SizedBox(width: 7),
          Column(
            children: [
              Text("play basket ball"),
            ],
          ),
          Spacer(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.appBarColor,
                borderRadius: BorderRadiusGeometry.circular(15),
              ),
              height: 34,
              width: 69,
              child: Icon(Icons.check, size: 25 , color: Colors.white,),
            ),
          ),
        ],
      ),
    ),
  );
}
