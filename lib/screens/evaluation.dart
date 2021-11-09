import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:youth_action_handbook/data/app_colors.dart';
import 'package:youth_action_handbook/data/app_texts.dart';
import 'package:youth_action_handbook/models/single_choice_model.dart';
import 'package:youth_action_handbook/widgets/multiple_choice_item.dart';
import 'package:youth_action_handbook/widgets/question_widget.dart';
import 'package:youth_action_handbook/widgets/type_answer_widget.dart';

class EvaluationScreen extends StatefulWidget {
  const EvaluationScreen({Key? key}) : super(key: key);

  @override
  _EvaluationScreenState createState() => _EvaluationScreenState();
}

class _EvaluationScreenState extends State<EvaluationScreen> {
    int selectedPos=-1;
    List<SingleChoiceModel> options = [
    SingleChoiceModel(answer: 'Answer 1',),
    SingleChoiceModel(answer: 'Answer 2',),
    SingleChoiceModel(answer: 'Answer 3'),
  ];
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Column(
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
                    ],
                  ),
                  Spacer(),
                  Column(
                    children: [
                      Icon(Icons.share,color:AppColors.colorBluePrimary,size: 35,),
                      SizedBox(height: 12,),
                      Text('Share',style:TextStyle(color:AppColors.colorBluePrimary))
                    ],
                  ),
                  SizedBox(width: 20,),
                  Column(
                    children: [
                  Image.asset('assets/certify.png',height: 50,width: 50),
                      Text('Certified',style:TextStyle(color:AppColors.colorBluePrimary))
                    ],
                  )
                ],
              ),
              Text('Evaluation 1',style: TextStyle(color: AppColors.colorBluePrimary),),
              SizedBox(height: 15,),
              RichText(
                text: TextSpan(
                    text: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vivamus sodales diam mi, ut luctus sapien vehicula vitae. Fusce iaculis eget nisl at finibus. Etiam vel libero urna. Cras a ligula non sem ultricies lobortis vitae vitae velit.',
                    style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 12,
                        fontWeight: FontWeight.w200),
                    children: const <TextSpan>[]),
              ),
              SizedBox(height: 25,),
              QuestionWidget(number:1,question:'What is Peace Education',instruction:'Type your answer in the text box below'),
              TypeAnswerWidget(),
              SizedBox(height: 25,),
              QuestionWidget(number:2,question:'What is Peace Education',instruction:'Type your answer in the text box below'),
              SizedBox(height: 25,),
              ListView.separated(
                shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (ctx,pos){
                    return GestureDetector(
                      onTap: (){
                        setState(() {
                          selectedPos=pos;
                        });
                      },
                      child: MultipleChoiceItem(
                        singleChoiceModel: options[pos],
                        isTicked: selectedPos == pos,

                      ),
                    );
                  }, separatorBuilder: (ctx,pos){
                    return Divider();
              }, itemCount: options.length)



            ],
          ),
        ),
      ),
    );
  }
}
