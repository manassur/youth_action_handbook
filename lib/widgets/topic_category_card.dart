import 'package:flutter/material.dart';
import 'package:youth_action_handbook/data/app_colors.dart';

class TopicCategoryCard extends StatelessWidget {
  final String? title;
  final bool? isSelected;
  const TopicCategoryCard( {Key? key,this.title,this.isSelected}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: isSelected==true?AppColors.colorPurple:Color(0xFFE6ECF5),
        borderRadius: BorderRadius.circular(15)
      ),
      padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
      child: Text(title!,style: TextStyle(color: isSelected==true? Colors.white:Colors.black45,fontWeight: FontWeight.w700)
      ));
  }
}
