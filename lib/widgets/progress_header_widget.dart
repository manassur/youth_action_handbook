import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:youth_action_handbook/data/app_colors.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:youth_action_handbook/models/course_response.dart';
import 'package:youth_action_handbook/models/user.dart';
import 'package:youth_action_handbook/services/database.dart';
import 'package:youth_action_handbook/widgets/common.dart';

class ProgressHeaderWidget extends StatefulWidget {
  final Courses? courses;
  const ProgressHeaderWidget({Key? key, required this.courses}) : super(key: key);

  @override
  State<ProgressHeaderWidget> createState() => _ProgressHeaderWidgetState();
}

class _ProgressHeaderWidgetState extends State<ProgressHeaderWidget> {
  
  AppUser? appUser;
  String? _currentUserId;
  DatabaseService? dbservice;
  bool? _hasViewed;
  String total = '';
  double percentDone = 0;

  Future testFunc() async {
    print('AKBR testFUNc fired!@');
    String voids = '23';
    return voids;
  }

   Future<double> _percentageDone() async {
    
    var prefs = await SharedPreferences.getInstance();
    final lessonList =  widget.courses!.lessons!;
    bool hasViewed = false;
    int coursesDone = 0;
    total = lessonList.length.toString();

    int i = 0;
    print('AKBR start noe');
    while(i < lessonList.length){
      // hasViewed = await dbservice!.hasViewedLesson(lessonList[i].id!,widget.courses!.id!);
      hasViewed = prefs.getBool(widget.courses!.id!+'-'+lessonList[i].id!) ?? false;
      // String testVar = await testFunc();
      print('AKBR course no.'+i.toString()+' has been viewd? : '+ hasViewed.toString());
      if(hasViewed){coursesDone = coursesDone + 1;}
      i = i+1;
    }
    if (mounted) {
      setState(() {
        total = lessonList.length.toString();
        percentDone = (100 * coursesDone/lessonList.length);
      });
    }

      return percentDone;
    
  }

   @override
  initState() {
    _percentageDone().then((value) => super.initState());
    
  }
  @override

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
                      text: 'No. of Lessons :'+ total,
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
                  text: percentDone.toStringAsFixed(1) + '%',
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
          percent: percentDone/100,
          center: Text(""),
          linearStrokeCap: LinearStrokeCap.roundAll,
          progressColor: AppColors.colorGreenPrimary,
        ),
      ],
    );
  }
}
