import 'package:flutter/material.dart';
import 'package:youth_action_handbook/data/app_colors.dart';
import 'package:youth_action_handbook/models/course_response.dart';
import 'package:youth_action_handbook/models/single_choice_model.dart';

class MultipleChoiceItem extends StatefulWidget {
  final SingleChoiceModel? singleChoiceModel;
  final bool? isTicked;
  final Questions? question;
  final String? answer, options;

  const MultipleChoiceItem({Key? key,this.singleChoiceModel, this.options, this.answer, this.question, this.isTicked, }) : super(key: key);

  @override
  State<MultipleChoiceItem> createState() => _MultipleChoiceItemState();
}

class _MultipleChoiceItemState extends State<MultipleChoiceItem> {

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child:   Row(
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
                      widget.singleChoiceModel!.answer!,
                      style: TextStyle(
                          color: AppColors.colorBluePrimary,
                          fontSize: 14,
                          fontWeight: FontWeight.bold))),

              SizedBox(height: 5),
              Text(
                widget.options!,
                style: TextStyle(
                    color: AppColors.colorBluePrimary,
                    fontSize: 12,
                    fontWeight: FontWeight.w200),
              ),
            ],
          ),
          const  Spacer(),
          widget.isTicked==true?
          const CircleAvatar(
            radius:15 ,
            backgroundColor: Color(0xff4CD964),
            child: Icon(Icons.done,color: Colors.white,),
          )
              :CircleAvatar(
            radius:15 ,
            backgroundColor: Colors.grey.shade400,
          )
        ],
      ),

    );
  }
}
