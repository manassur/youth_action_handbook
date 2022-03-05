import 'package:flutter/material.dart';
import 'package:youth_action_handbook/data/app_colors.dart';
import 'package:youth_action_handbook/models/course_response.dart';
import 'package:youth_action_handbook/widgets/progress_header_widget.dart';
import 'package:youth_action_handbook/widgets/quiz_card.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class IndividualCourseEvaluation extends StatefulWidget {
  final Courses? courses;
  const IndividualCourseEvaluation({Key? key, required this.courses}) : super(key: key);

  @override
  _IndividualCourseEvaluationState createState() => _IndividualCourseEvaluationState();
}

class _IndividualCourseEvaluationState extends State<IndividualCourseEvaluation> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          crossAxisAlignment:CrossAxisAlignment.start ,
          children: [
            ProgressHeaderWidget(courses:widget.courses!,),
            SizedBox(height: 20,),
            RichText(
              text: TextSpan(
                  text: AppLocalizations.of(context)!.quizzes,
                  style: TextStyle(
                      color: AppColors.colorBluePrimary,
                      fontSize: 25,
                      fontWeight: FontWeight.w900),
                  children: const <TextSpan>[]),
            ),
            SizedBox(height: 10,),
            RichText(
              text: TextSpan(
                  text:AppLocalizations.of(context)!.takeaQuizToChallengeYourselfWeKnowYoullDoGreat,
                  style: TextStyle(
                      color: AppColors.colorBluePrimary,
                      fontSize: 12,
                      fontWeight: FontWeight.w300),
                  children: const <TextSpan>[]),
            ),

            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: widget.courses!.quiz!.length,
              itemBuilder: (context, pos){
                return QuizzCard(
                   quiz: widget.courses!.quiz![pos],
                  courseId: widget.courses!.id,
                  );
              },
            ),
            SizedBox(height: 20,),
          ],
        ),
      ),
    );
  }

}
