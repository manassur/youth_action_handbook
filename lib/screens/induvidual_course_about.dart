import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:youth_action_handbook/data/app_colors.dart';
import 'package:youth_action_handbook/models/course_response.dart';
import 'package:youth_action_handbook/widgets/progress_header_widget.dart';
import 'package:youth_action_handbook/widgets/title_body_widget.dart';
import 'package:percent_indicator/percent_indicator.dart';

class IndividualCourseAbout extends StatefulWidget {
  // final Courses courses;
  final Courses? courses;
  const IndividualCourseAbout({Key? key, required this.courses}) : super(key: key);

  @override
  _IndividualCourseAboutState createState() => _IndividualCourseAboutState();
}

class _IndividualCourseAboutState extends State<IndividualCourseAbout> {
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
            TitleBodyWidget(title: "Overview", courses: widget.courses!.overview,),
            SizedBox(height: 20,),
            TitleBodyWidget(title: "Objectives",courses: widget.courses!.objectives),
            SizedBox(height: 20,),
            TitleBodyWidget(title: "Approach",courses: widget.courses!.approach),
            SizedBox(height: 20,),
            TitleBodyWidget(title: "References",courses: widget.courses!.references),
            SizedBox(height: 20,),
            RichText(
              text: TextSpan(
                  text: 'Did you like this Course?',
                  style: TextStyle(
                      color: AppColors.colorBluePrimary,
                      fontSize: 25,
                      fontWeight: FontWeight.w900),
                  children: const <TextSpan>[]),
            ),
            SizedBox(height: 10,),
            RichText(
              text: TextSpan(
                text:'Rate this course',
                  style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 15,
                      fontWeight: FontWeight.w200),
                  children: const <TextSpan>[]),
            ),
        Row(
          children: [
            RatingBar.builder(
              initialRating: 3,
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemCount: 5,
              itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
              itemBuilder: (context, _) => Icon(
                Icons.star,
                color: Colors.amber,
              ),
              onRatingUpdate: (rating) {
                print(rating);
              },
            ),
            SizedBox(width:20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RichText(
                  text: TextSpan(
                      text: '''Avg''',
                      style: TextStyle(
                          color: AppColors.colorBluePrimary,
                          fontSize: 12,
                          fontWeight: FontWeight.w400),
                      children: const <TextSpan>[]),
                ),
                RichText(
                  text: TextSpan(
                      text: '''4.0/5.0''',
                      style: TextStyle(
                          color: AppColors.colorBluePrimary,
                          fontSize: 13,
                          fontWeight: FontWeight.w600),
                      children: const <TextSpan>[]),
                ),
              ],
            ),
          ],
        ),
            SizedBox(height: 40,),
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 50,
                    child:TextButton(
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(AppColors.colorGreenPrimary),
                          shadowColor: MaterialStateProperty.all<Color>(AppColors.colorGreenPrimary.withOpacity(0.4)),
                          elevation: MaterialStateProperty.all(0), //Defines Elevation
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0),
                              ))),
                      child: Text('Rate',style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),),
                      onPressed: () {
                        _modalBottomSheetMenu();
                      },
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _modalBottomSheetMenu(){
    showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        builder: (builder){
          return Container(
            height: 200.0,
            padding: EdgeInsets.all(20.0),
            color: Colors.transparent, //could change this to Color(0xFF737373),
            //so you don't have to change MaterialApp canvasColor
            child: Container(
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(10.0),
                        topRight: const Radius.circular(10.0))),
                child: Center(
                  child: Column(
                    children: [
                      RichText(
                        text: TextSpan(
                            text: 'Rate this Course',
                            style: TextStyle(
                                color: AppColors.colorBluePrimary,
                                fontSize: 25,
                                fontWeight: FontWeight.w900),
                            children: const <TextSpan>[]),
                      ),
                      SizedBox(height: 15,),
                      RatingBar.builder(
                        initialRating: 0,
                        minRating: 0,
                        direction: Axis.horizontal,
                        allowHalfRating: true,
                        itemCount: 5,
                        itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                        itemBuilder: (context, _) => Icon(
                          Icons.star,
                          color: Colors.amber,
                        ),
                        onRatingUpdate: (rating) {
                          print(rating);
                        },
                      ),
                      SizedBox(height: 15,),

                      RichText(
                        text: TextSpan(
                            text:'Tap on the star you find appropriate',
                            style: TextStyle(
                                color: Colors.grey.shade600,
                                fontSize: 15,
                                fontWeight: FontWeight.w200),
                            children: const <TextSpan>[]),
                      ),

                    ],
                  ),
                )),
          );
        }
    );
  }
}
