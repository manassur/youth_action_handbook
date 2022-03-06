import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:youth_action_handbook/data/app_colors.dart';
import 'package:youth_action_handbook/models/course_response.dart';
import 'package:youth_action_handbook/models/user.dart';
import 'package:youth_action_handbook/screens/evaluation.dart';
import 'package:youth_action_handbook/services/database.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:youth_action_handbook/widgets/common.dart';

class QuizzCard extends StatefulWidget {
  final Quiz? quiz;
 String? courseId;
  QuizzCard({Key? key,this.quiz,this.courseId}) : super(key: key);

  @override
  State<QuizzCard> createState() => _QuizzCardState();
}

class _QuizzCardState extends State<QuizzCard> {
  AppUser? appUser;
  double? _quizScore=-1;
  bool? isDone=false;
  String? _currentUserId;
  DatabaseService? dbservice;
  TextEditingController _captionController = TextEditingController();
  bool _isLoading = false;

  @override
  initState() {
    super.initState();
    appUser = Provider.of<AppUser?>(context,listen:false);
    _currentUserId = appUser!.uid;
    dbservice = DatabaseService(uid: _currentUserId);
    _hasTakenQuiz();
  }

  _hasTakenQuiz() async {
    double quizScore = await dbservice!.getQuizScore(widget.courseId!,widget.quiz!.id!);
    print('_hasTakenQuizCalled : '+ quizScore.toString());
    if (mounted) {
      setState(() {
        _quizScore = quizScore;
        isDone = quizScore!=-1;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
      //   if(_quizScore!=-1) {
      //     means the quiz has been taken
      //     Flushbar(
      //       title: "Quiz taken",
      //       message: "You have already taken this quiz, but you can retake it whenever you like.",
      //       backgroundColor: AppColors.colorYellow,
      //       duration: Duration(seconds: 2),
      //     ).show(context);
      //  }
      //  else{
          Navigator.push(context,
              MaterialPageRoute(builder: (context) =>
                  EvaluationScreen(
                      quiz: widget.quiz, courseId: widget.courseId)));
        // }

        },
      child: Container(
        padding: EdgeInsets.symmetric(vertical:30,horizontal: 15),
        margin: EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
            color: isDone!?Colors.white: AppColors.colorGreenPrimary,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                  color:isDone!?Colors.grey.shade200: AppColors.colorGreenPrimary.withOpacity(0.2),
                  spreadRadius: 3,
                  blurRadius: 5,
                  offset: Offset(4,6)
              )
            ]
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              flex:5,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(widget.quiz!.title!,style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold,color: isDone!? AppColors.colorBluePrimary:Colors.white),),
                 SizedBox(height:5),
              //    Text(widget.quiz!.title!,style: TextStyle(fontWeight: FontWeight.w100,fontSize: 12,color: isDone!? AppColors.colorBluePrimary:Colors.white),),
                ],
              ),
            ),

            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  backgroundColor: isDone!?Color(0xff4CD964):Color(0xFF2DF0E0),
                    radius: 20,
                    child: Text(_quizScore!<0?'N/A': _quizScore!.toString(),style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white,fontSize: 17),)),
                Text("score",style: TextStyle(fontWeight: FontWeight.w400,fontSize: 12,color:isDone!?Colors.black87: Colors.white),),
              ],
            ),
          const SizedBox(width: 15,),
           isDone!? const CircleAvatar(
              radius:12 ,
              backgroundColor: Color(0xff4CD964),
              child: Icon(Icons.done,color: Colors.white,size: 15,),
            ):
           CircleAvatar(
             radius:13 ,
             backgroundColor: Color(0xFF2DF0E0),
             child:  CircleAvatar(
               radius:12 ,
               backgroundColor: AppColors.colorGreenPrimary,
               child: Icon(Icons.lock_outline_rounded,color: Colors.white,size: 12,),
             )
           )


          ],
        ),
      ),
    );
  }
}
