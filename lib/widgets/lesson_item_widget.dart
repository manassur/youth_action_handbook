import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:youth_action_handbook/data/app_colors.dart';
import 'package:youth_action_handbook/models/course_response.dart';

class LessonItemCard extends StatefulWidget {
  final String? title;
  final String? duration;
  const LessonItemCard({Key? key, this.title, this.duration}) : super(key: key);

  @override
  _LessonItemCardState createState() => _LessonItemCardState();
}

class _LessonItemCardState extends State<LessonItemCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 20),
      padding: EdgeInsets.all(30),
      decoration: BoxDecoration(
          color: AppColors.colorGreenPrimary,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
                color: AppColors.colorGreenPrimary.withOpacity(0.2),
                spreadRadius: 3,
                blurRadius: 5,
                offset: Offset(4, 6)
            )
          ]
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Icon(Icons.play_circle_fill_outlined,
              color: Colors.white),
          SizedBox(width: 20,),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  // "What is Peace Education?",
                  widget.title!,
                  style: TextStyle(
                      fontSize: 19,
                      fontWeight: FontWeight.bold,
                      color: Colors.white),),
                SizedBox(height: 10,),

                Text(
                  widget.duration!,
                  style: TextStyle(
                      fontWeight: FontWeight.w100,
                      fontSize: 15,
                      color: Colors.white),),
              ],
            ),
          ),

          CircularPercentIndicator(
            radius: 20.0,
            lineWidth: 1.0,
            percent: 0.8,
            center: Text(""),
            progressColor: Colors.white,
            backgroundColor: Colors.grey.shade300,
          ),
        ],
      ),
    );
  }
}
