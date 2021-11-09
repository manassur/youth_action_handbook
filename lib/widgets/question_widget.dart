import 'package:flutter/material.dart';
import 'package:youth_action_handbook/data/app_colors.dart';

class QuestionWidget extends StatelessWidget {
  final int? number;
  final String? question,instruction;
  const QuestionWidget({Key? key,this.number,this.question,this.instruction}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 10,
            ),
            SizedBox(
                width: 240,
                child: Text('$number. $question',
                    style: TextStyle(
                        color: AppColors.colorBluePrimary,
                        fontSize: 14,
                        fontWeight: FontWeight.bold))),
            SizedBox(
              height: 5,
            ),
            Text(
              '$instruction',
              style: TextStyle(
                  color: AppColors.colorBluePrimary,
                  fontSize: 12,
                  fontWeight: FontWeight.w200),
            ),
          ],
        ),
        Spacer(),
        Container(
          height:25,
          width:80,
          decoration: BoxDecoration(
              color: Color(0xff4CD964),
              borderRadius: BorderRadius.circular(20)
          ),
          child: Center(child: Text('5 marks',style: TextStyle(color:Colors.white),)),
        ),
      ],
    );
  }
}
