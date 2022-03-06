import 'package:flutter/material.dart';
import 'package:youth_action_handbook/data/app_colors.dart';

class CustomTab extends StatelessWidget {
  final String? title;
  final bool? isSelected;
  const CustomTab( {Key? key,this.title,this.isSelected}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      width: 100,
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: isSelected==true?AppColors.colorPurple:Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          isSelected==true?BoxShadow():BoxShadow(
            color: AppColors.colorBluePrimary.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 8
          )
        ]
      ),
      padding: EdgeInsets.symmetric(vertical: 10),
      child: Center(
        child: Text(title!,style: TextStyle(color: isSelected==true? Colors.white:Colors.black45,fontWeight: FontWeight.w700)
        ),
      ));
  }
}
