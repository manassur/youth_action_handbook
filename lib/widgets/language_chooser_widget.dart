import 'package:flutter/material.dart';
import 'package:youth_action_handbook/data/app_colors.dart';

class LanguagePicker extends StatelessWidget {
  const LanguagePicker({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200.0,
      padding: EdgeInsets.all(20.0),
      color: Colors.transparent, //could change this to Color(0xFF737373),
      //so you don't have to change MaterialApp canvasColor
      child: ListView(
        children: [
          Center(child: Text('Change Language',style: TextStyle(fontSize: 20,fontWeight: FontWeight.w600,color: AppColors.colorBlueSecondary),)),
          SizedBox(height: 20,),
          Text('English',style: TextStyle(fontSize: 18),),
         Divider(),
          Text('French',style: TextStyle(fontSize: 18),),

        ],
      ),
    );
  }
}
