import 'package:flutter/material.dart';
import 'package:youth_action_handbook/data/app_colors.dart';

class TitleBodyWidget extends StatelessWidget {
  final String? title;
  const TitleBodyWidget({Key? key,this.title}) : super(key: key);

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
              text: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vivamus sodales diam mi, ut luctus sapien vehicula vitae. Fusce iaculis eget nisl at finibus. Etiam vel libero urna. Cras a ligula non sem ultricies lobortis vitae vitae velit.',
              style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 12,
                  fontWeight: FontWeight.w200),
              children: const <TextSpan>[]),
        ),

      ],
    );
  }
}
