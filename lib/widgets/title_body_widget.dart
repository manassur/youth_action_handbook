import 'package:flutter/material.dart';
import 'package:youth_action_handbook/data/app_colors.dart';

class TitleBodyWidget extends StatelessWidget {
  final String? title;
  final String? courses;
  const TitleBodyWidget({Key? key,this.title, required this.courses}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:CrossAxisAlignment.start ,

      children: [
        RichText(
          text: TextSpan(
              text: title,
              style: TextStyle(
                  color: AppColors.colorBluePrimary,
                  fontSize: 25,
                  fontWeight: FontWeight.w900),
              children: const <TextSpan>[]),
        ),
        SizedBox(height: 15,),
        RichText(
          text: TextSpan(
              text: courses,
              style: TextStyle(
                  color: Colors.grey.shade700,
                  fontWeight: FontWeight.w400),
              children: const <TextSpan>[]),
        ),

      ],
    );
  }
}
