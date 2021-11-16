import 'package:flutter/material.dart';
import 'package:youth_action_handbook/data/app_colors.dart';
import 'package:youth_action_handbook/models/course_response.dart';
import 'package:youth_action_handbook/models/single_choice_model.dart';

class MultipleChoiceItem extends StatefulWidget {
  final SingleChoiceModel? singleChoiceModel;
  final bool? isTicked;
  final Questions? question;
  final String? answer, options;
  // final Options? options;

  const MultipleChoiceItem({Key? key,this.singleChoiceModel, this.options, this.answer, this.question, this.isTicked, }) : super(key: key);

  @override
  State<MultipleChoiceItem> createState() => _MultipleChoiceItemState();
}

class _MultipleChoiceItemState extends State<MultipleChoiceItem> {
  int selectedPos=-1;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Row(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(width: 10),
              SizedBox(
                  width: 240,
                  child:
                  Text(
                      // widget.singleChoiceModel!.answer!,
                    widget.answer!,
                      style: TextStyle(
                          color: AppColors.colorBluePrimary,
                          fontSize: 14,
                          fontWeight: FontWeight.bold))),

              SizedBox(height: 5),
              Text(
                // 'Type out your answer in the box below',
                // widget.singleChoiceModel!.options!,
                widget.options!,
                // widget.question!.a!,

                style: TextStyle(
                    color: AppColors.colorBluePrimary,
                    fontSize: 12,
                    fontWeight: FontWeight.w200),
              ),
            ],
          ),
          Spacer(),
         widget.isTicked==true? CircleAvatar(
            radius:15 ,
            backgroundColor: Color(0xff4CD964),
            child: Icon(Icons.done,color: Colors.white,),
          ):CircleAvatar(
           radius:15 ,
           backgroundColor: Colors.grey.shade400,

         )
        ],
      ),
    );
  }
}
