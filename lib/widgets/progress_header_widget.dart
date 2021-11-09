import 'package:flutter/material.dart';
import 'package:youth_action_handbook/data/app_colors.dart';
import 'package:percent_indicator/percent_indicator.dart';

class ProgressHeaderWidget extends StatelessWidget {
  const ProgressHeaderWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
              text: 'Peace',
              style: TextStyle(
                  color: AppColors.colorBluePrimary,
                  fontSize: 25,
                  fontWeight: FontWeight.w900),
              children: const <TextSpan>[]),
        ),
        RichText(
          text: TextSpan(
              text: 'Education',
              style: TextStyle(
                  color: AppColors.colorBluePrimary,
                  fontSize: 25,
                  fontWeight: FontWeight.w900),
              children: const <TextSpan>[]),
        ),
        Row(
          children: [
            RichText(
              text: TextSpan(
                  text: '1250 Enrolled',
                  style: TextStyle(
                      color: AppColors.colorBluePrimary,
                      fontSize: 14,
                      fontWeight: FontWeight.w200),
                  children: <TextSpan>[
                    TextSpan(
                      text: ' . ',
                      style: TextStyle(
                          color: AppColors.colorBluePrimary,
                          fontSize: 20,
                          fontWeight: FontWeight.w900),
                    ),
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
