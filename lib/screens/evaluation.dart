import 'package:another_flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:youth_action_handbook/data/app_colors.dart';
import 'package:youth_action_handbook/models/course_response.dart';
import 'package:youth_action_handbook/models/single_choice_model.dart';
import 'package:youth_action_handbook/models/user.dart';
import 'package:youth_action_handbook/services/database.dart';
import 'package:youth_action_handbook/widgets/multiple_choice_item.dart';
import 'package:youth_action_handbook/widgets/question_widget.dart';
import 'package:youth_action_handbook/widgets/type_answer_widget.dart';

class EvaluationScreen extends StatefulWidget {
  final String? courseId;
  final Quiz? quiz;
  final bool? isTicked;


  const EvaluationScreen({Key? key,
    this.isTicked,
    this.courseId,
    this.quiz,
  }) : super(key: key);

  @override
  _EvaluationScreenState createState() => _EvaluationScreenState();
}

class _EvaluationScreenState extends State<EvaluationScreen> {

  AppUser? appUser;
  double? _quizScore=-1;
  bool? isDone=false;
  String? _currentUserId;
  DatabaseService? dbservice;
  TextEditingController _captionController = TextEditingController();
  bool _isLoading = false;
  final _controller = new PageController();
  static const _kDuration = const Duration(milliseconds: 300);
  static const _kCurve = Curves.ease;
  int? currentIndex=0;
  @override
  initState() {
    super.initState();
    appUser = Provider.of<AppUser?>(context,listen:false);
    _currentUserId = appUser!.uid;
    dbservice = DatabaseService(uid: _currentUserId);
  }


  void calculateScoreAndSaveQuiz() {
    widget.quiz!.questions!.forEach((element) {
      if(element.selectedAnswerId==element.correctAnswerId){
        // question passed, save user option and mark
        dbservice!.addUserQuizRecord(widget.courseId!, widget.quiz!.id!, element.id!, element.selectedAnswerId!, element.mark!);
      }else{
        // question failed savae user option and award 0 mark
        dbservice!.addUserQuizRecord(widget.courseId!, widget.quiz!.id!, element.id!, element.selectedAnswerId!, 0);
      }
    });
    Flushbar(
      title: "Quiz Saved",
      message: "Great, you have taken this quiz",
      backgroundColor: AppColors.colorYellow,
      duration: Duration(seconds: 1),
    ).show(context).then((value) => Navigator.of(context).pop());

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF7FBFe),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Color(0xFFF7FBFe),
        leading: IconButton(
          icon:Icon(Icons.keyboard_backspace,color:AppColors.colorBluePrimary),
          onPressed: (){
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Padding(
        padding:  EdgeInsets.symmetric(horizontal:10.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: RichText(
                      text: TextSpan(
                        text: widget.quiz!.title!,
                          style: TextStyle(
                              color: AppColors.colorBluePrimary,
                              fontSize: 19,
                              fontWeight: FontWeight.w900),
                          children:  <TextSpan>[]),
                    ),
                  ),
                  Column(
                    children: [
                      Icon(Icons.share,color:AppColors.colorBluePrimary,size: 35,),
                      SizedBox(height: 12,),
                      Text('Share',style:TextStyle(color:AppColors.colorBluePrimary))
                    ],
                  ),
                  SizedBox(width: 10,),
                  Column(
                    children: [
                  Image.asset('assets/certify.png',height: 50,width: 50),
                      Text('Certified',style:TextStyle(color:AppColors.colorBluePrimary))
                    ],
                  )
                ],
              ),
              Text('Evaluation 1',style: TextStyle(color: AppColors.colorBluePrimary),),
             const  SizedBox(height: 10,),
              RichText(
                text: TextSpan(
                    text: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vivamus sodales diam mi, ut luctus sapien vehicula vitae. Fusce iaculis eget nisl at finibus. Etiam vel libero urna. Cras a ligula non sem ultricies lobortis vitae vitae velit.',
                    style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 12,
                        fontWeight: FontWeight.w200),
                    children: const <TextSpan>[]),
              ),
              SizedBox(height: 20,),

           // const   QuestionWidget(
           //      // number:widget.quiz!.questions!,
           //        number: "1",
           //        question:'What is Peace Education',
           //        instruction:'Type your answer in the text box below'
           //    ),
            //  TypeAnswerWidget(),
           //    SizedBox(height: 25,),

              SizedBox(
                height: 420,
                child: PageView.builder(

                  onPageChanged: (index){
                    setState(() {
                      currentIndex=index;
                    });
                  },
                  controller: _controller,
                  itemCount: widget.quiz!.questions!.length,
                  itemBuilder: (context, index){
                    Questions question = widget.quiz!.questions![index];
                    return Card(
                      elevation: 5,
                      color: Colors.white,
                      child: Container(
                        padding: EdgeInsets.all(10),
                        child: Column(
                          children: [
                            QuestionWidget(
                                number:question.id,
                                question:question.question,
                                instruction:'Type your answer in the text box below'),

                            SizedBox(height: 10,),

                            // list of options
                            ListView.separated(
                                shrinkWrap: true,
                                physics: NeverScrollableScrollPhysics(),
                                itemCount: question.answers!.length,
                                itemBuilder: (ctx,pos){
                                  Answers ans = question.answers![pos];

                                  return GestureDetector(
                                    onTap: (){
                                      setState(() {
                                        question.selectedAnswerId=ans.id!;
                                      });
                                    },
                                    child: MultipleChoiceItem(
                                     answer:ans,
                                      selectedAnswer:question.selectedAnswerId
                                    ),
                                  );
                                }, separatorBuilder: (ctx,pos){
                              return Divider();
                            }, ),
                          ],
                        ),
                      ),
                    );
                  },

                ),
              ),
              SizedBox(height:10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: 40,
                    width: 300,
                    child:TextButton(
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(AppColors.colorGreenPrimary),
                          shadowColor: MaterialStateProperty.all<Color>(AppColors.colorGreenPrimary.withOpacity(0.4)),
                          elevation: MaterialStateProperty.all(5), //Defines Elevation
                          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0),
                              ))),
                      child: Text(currentIndex==widget.quiz!.questions!.length-1?'Submit':'Next',style: TextStyle(fontWeight: FontWeight.bold,color: Colors.white),),
                      onPressed: () {
                        if(currentIndex==widget.quiz!.questions!.length-1){
                          calculateScoreAndSaveQuiz();
                        }else{
                          _controller.nextPage(duration: _kDuration, curve: _kCurve);

                        }

                      },
                    ),
                  ),
                ],
              ),

            ],
          ),
        ),
      ),
    );
  }

}
