import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:youth_action_handbook/data/app_colors.dart';
import 'package:youth_action_handbook/models/course_response.dart';
import 'package:youth_action_handbook/screens/evaluation.dart';
import 'package:youth_action_handbook/widgets/evaluation_card.dart';
import 'package:youth_action_handbook/widgets/progress_header_widget.dart';
import 'package:youth_action_handbook/widgets/question_widget.dart';
import 'package:youth_action_handbook/widgets/quiz_card.dart';
import 'package:youth_action_handbook/widgets/title_body_widget.dart';
import 'package:percent_indicator/percent_indicator.dart';

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
                  text: 'Quizes',
                  style: TextStyle(
                      color: AppColors.colorBluePrimary,
                      fontSize: 25,
                      fontWeight: FontWeight.w900),
                  children: const <TextSpan>[]),
            ),
            SizedBox(height: 10,),
            RichText(
              text: TextSpan(
                  text:"Take a quiz to challenge yourself, we know you'll do great",
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
                return InkWell(
                  onTap: (){
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context)=>
                            EvaluationScreen(quiz: widget.courses!.quiz![pos],)));
                  },
                  child: QuizzCard(
                    title: widget.courses!.quiz![pos].title,
                    subtitle: widget.courses!.quiz![pos].quizType,
                    score: '5.0',
                    isDone:true,
                    isAvailable:true,
                    ),
                );
              },
            ),
            SizedBox(height: 20,),
            RichText(
              text: TextSpan(
                  text: 'Evaluation',
                  style: TextStyle(
                      color: AppColors.colorBluePrimary,
                      fontSize: 25,
                      fontWeight: FontWeight.w900),
                  children: const <TextSpan>[]),
            ),
            SizedBox(height: 10,),
            RichText(
              text: TextSpan(
                  text:"Evaluate yourself",
                  style: TextStyle(
                      color: AppColors.colorBluePrimary,
                      fontSize: 12,
                      fontWeight: FontWeight.w300),
                  children: const <TextSpan>[]),
            ),

            ListView(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              children: const [
                EvaluationCard(title: 'Fundamental Principles',subtitle: 'Quiz A',isDone:true,isAvailable:true,score: '5.0',),
                EvaluationCard(title: 'What is peace Education',subtitle: 'Quiz B',isDone:false,isAvailable:true,score: 'N/A',),
                EvaluationCard(title: 'What is peace Education',subtitle: 'Quiz B',isDone:false,isAvailable:true,score: 'N/A',),
              ],
            )

          ],
        ),
      ),
    );
  }

}
