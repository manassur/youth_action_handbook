import 'package:flutter/material.dart';
import 'package:youth_action_handbook/models/course_response.dart';
import 'package:youth_action_handbook/widgets/lesson_item_widget.dart';
import 'package:youth_action_handbook/widgets/progress_header_widget.dart';

class IndividualCourseLesson extends StatefulWidget {
  final Courses? courses;
  const IndividualCourseLesson({Key? key, required this.courses}) : super(key: key);

  @override
  _IndividualCourseLessonState createState() => _IndividualCourseLessonState();
}

class _IndividualCourseLessonState extends State<IndividualCourseLesson> {

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          crossAxisAlignment:CrossAxisAlignment.start ,
          children: [
            ProgressHeaderWidget(courses:widget.courses!,),
            ListView.builder(
              shrinkWrap: true,
              itemCount: widget.courses!.lessons!.length,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, pos){
                return LessonItemCard(
                  title:widget.courses!.lessons![pos].title! ,
                  duration: widget.courses!.lessons![pos].duration!,
                );
                },
            ),
          ],
        ),
      ),
    );
  }
}
