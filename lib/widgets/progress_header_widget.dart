import 'package:flutter/material.dart';
import 'package:youth_action_handbook/data/app_colors.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:youth_action_handbook/models/course_response.dart';

class ProgressHeaderWidget extends StatefulWidget {
  final Courses? courses;
  const ProgressHeaderWidget({Key? key, required this.courses}) : super(key: key);

  @override
  State<ProgressHeaderWidget> createState() => _ProgressHeaderWidgetState();
}

class _ProgressHeaderWidgetState extends State<ProgressHeaderWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: widget.courses!.title!,
              style: TextStyle(
                  color: AppColors.colorBluePrimary,
                  fontSize: 25,
                  fontWeight: FontWeight.w900),
              children: const <TextSpan>[]),
        ),
        // RichText(
        //   text: TextSpan(
        //       text: 'Education',
        //       style: TextStyle(
        //           color: AppColors.colorBluePrimary,
        //           fontSize: 25,
        //           fontWeight: FontWeight.w900),
        //       children: const <TextSpan>[]),
        // ),
        Row(
          children: [
            RichText(
              text: TextSpan(
                  text: '',
                  style: TextStyle(
                      color: AppColors.colorBluePrimary,
                      fontSize: 14,
                      fontWeight: FontWeight.w200),
                  children: <TextSpan>[

                    TextSpan(
                      text: 'Duration : 20hrs',
                      style: TextStyle(
                          color: AppColors.colorPurple,
                          fontSize: 14,
                          fontWeight: FontWeight.w700),
                    ),
                  ]),
            ),
            Spacer(),
            RichText(
              text: TextSpan(
                  text: '65%',
                  style: TextStyle(
                      color: AppColors.colorPurple,
                      fontSize: 20,
                      fontWeight: FontWeight.w900),
                  children: const <TextSpan>[]),
            ),
          ],
        ),
        SizedBox(height: 10),
        LinearPercentIndicator(
          width: MediaQuery.of(context).size.width - 50,
          animation: true,
          animationDuration: 1000,
          lineHeight: 15.0,
          percent: 0.2,
          center: Text(""),
          linearStrokeCap: LinearStrokeCap.roundAll,
          progressColor: AppColors.colorGreenPrimary,
        ),
      ],
    );
  }
}
